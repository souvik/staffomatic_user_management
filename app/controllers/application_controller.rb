class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found_error
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record_error

  before_action :authorize!

  private

  def current_user
    user_id = JwtAuthenticationService.decode_token(request)
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end

  def authorize!
    return true if logged_in?

    render json: { message: 'Please log in' }, status: :unauthorized
  end

  def render_jsonapi_internal_server_error(exception)
    puts(exception)
    super(exception)
  end

  private

  def handle_record_not_found_error(exception)
    unprocessable_entity_error(exception.message)
  end

  def unprocessable_entity_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def handle_invalid_record_error(exception)
    messages = exception.record ? exception.record.errors: []
    render json: { errors: messages }, status: :unprocessable_entity
  end
end
