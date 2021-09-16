class UsersController < ApplicationController
  rescue_from SUM::SelfStatusUpdateError, with: :handle_self_update_error
  rescue_from SUM::DesireStatusError, with: :handle_status_error

  def index
    render jsonapi: User.all
  end

  def archive
    modify_status
  end

  def unarchive
    modify_status
  end

  def destroy
    modify_status
  end

  private
  def modify_status
    user = User.find(params[:id])
    user.update_status_by_action(params[:action], current_user)
    render jsonapi: user
  end

  def handle_self_update_error(exception)
    unprocessable_entity_error(exception.message)
  end

  def handle_status_error(exception)
    unprocessable_entity_error(exception.message)
  end
end
