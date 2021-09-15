class UsersController < ApplicationController
  rescue_from SUM::SelfArchiveError, with: :handle_self_archive_error

  def index
    render jsonapi: User.all
  end

  def archive
    user = User.find(params[:id])
    raise SUM::SelfArchiveError if user == current_user
    if user.status_archived!
      user.notify_on_status_change
      render jsonapi: user
    end
  end

  private

  def handle_self_archive_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
