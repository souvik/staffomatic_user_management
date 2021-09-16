class ActivityLog < ApplicationRecord
  serialize :payload, JSON

  belongs_to :user

  validates :performed_action, presence: true
  validates :action_method, presence: true
end
