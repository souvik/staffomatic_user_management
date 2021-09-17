module Trackable
  include ActiveSupport::Concern

  def log_activity
    activity = current_user.log_activity(
      fullpath: request.fullpath,
      method: request.request_method,
      payload: request.request_parameters
    )
    activity.save!
  end
end
