class User < ApplicationRecord
  has_secure_password

  enum status: { deleted: 0, active: 1, archived: 2 }, _prefix: true

  has_many :activity_logs

  validates :email, presence: true, uniqueness: true

  def update_status_by_action(action_name)
    case action_name
    when 'archive'
      raise SUM::DesireStatusError.new('active') unless status_active?
      status_archived!
    when 'unarchive'
      raise SUM::DesireStatusError.new('archived') unless status_archived?
      status_active!
    when 'destroy'
      raise SUM::DesireStatusError.new('active/archived') if status_deleted?
      status_deleted!
    else
      return
    end
    notify_on_status_change
  end

  def notify_on_status_change
    UserMailer.with(user: self).status_change_notifier.deliver_now
  end

  def log_activity(activity_detail)
    activity_logs.build(
      performed_action: activity_detail[:fullpath],
      action_method: activity_detail[:method],
      payload: activity_detail[:payload]
    )
  end
end
