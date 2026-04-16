class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc).limit(10) }

  after_create_commit { broadcast_append_to "notifications_#{user_id}" }

  def mark_as_read!
    update(read: true)
  end
end
