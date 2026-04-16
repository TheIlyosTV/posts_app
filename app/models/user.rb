class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :avatar

  has_many :conversations, -> { order(updated_at: :desc) }, foreign_key: :sender_id, dependent: :destroy
  has_many :conversations_as_receiver, -> { order(updated_at: :desc) }, class_name: "Conversation", foreign_key: :receiver_id, dependent: :destroy

  def all_conversations
    Conversation.where("sender_id = ? OR receiver_id = ?", id, id).order(updated_at: :desc)
  end

  def get_conversation_with(other_user)
    Conversation.between(id, other_user.id).first
  end

  def conversations
    all_conversations
  end

  def unread_notifications_count
    notifications.unread.count
  end
end
