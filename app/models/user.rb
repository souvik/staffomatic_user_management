class User < ApplicationRecord
  has_secure_password

  enum status: { deleted: 0, active: 1, archived: 2 }, _prefix: true

  validates :email, presence: true, uniqueness: true

  def notify_on_status_change
    UserMailer.with(user: self).status_change_notifier.deliver_now
  end
end
