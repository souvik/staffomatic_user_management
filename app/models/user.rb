class User < ApplicationRecord
  has_secure_password

  enum status: { deleted: 0, active: 1, archived: 2 }, _prefix: true

  validates :email, presence: true, uniqueness: true

  def update_status_by_action(action_name, requester)
    raise SUM::SelfArchiveError if self.eql?(requester)
    case action_name
    when 'archive'
      raise SUM::DesireStatusError.new('active') unless status_active?
      status_archived!
    when 'unarchive'
      raise SUM::DesireStatusError.new('archived') unless status_archived?
      status_active!
    when 'destroy'
      raise SUM::DesireStatusError.new('archived') if status_deleted?
      status_deleted!
    else
      return
    end
    notify_on_status_change
  end

  def notify_on_status_change
    UserMailer.with(user: self).status_change_notifier.deliver_now
  end
end
