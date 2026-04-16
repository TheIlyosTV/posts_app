class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  has_many :direct_messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :receiver_id }

  scope :between, ->(user1_id, user2_id) {
    where("(conversations.sender_id = ? AND conversations.receiver_id = ?) OR (conversations.sender_id = ? AND conversations.receiver_id = ?)", user1_id, user2_id, user2_id, user1_id)
  }

  def other_user(current_user)
    sender_id == current_user.id ? receiver : sender
  end

  def last_message
    direct_messages.last
  end

  broadcasts_to ->(conversation) { "conversations" }, inserts_by: :prepend
end
