class UsersController < ApplicationController
  rescue_from SUM::SelfStatusUpdateError, with: :handle_self_update_error
  rescue_from SUM::DesireStatusError, with: :handle_status_error

  include Trackable

  def index
    if params[:filter].blank?
      users = User.all
    else
      users = User.by_status(params[:filter])
    end
    render jsonapi: users
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
    raise SUM::SelfStatusUpdateError.new(params[:action]) if user.eql?(current_user)
    User.transaction do
      user.update_status_by_action(params[:action])
      log_activity
    end
    render jsonapi: user
  end

  def handle_self_update_error(exception)
    unprocessable_entity_error(exception.message)
  end

  def handle_status_error(exception)
    unprocessable_entity_error(exception.message)
  end
end
