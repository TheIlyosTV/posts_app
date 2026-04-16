class Post < ApplicationRecord
  belongs_to :user
  has_one :chat_room, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  after_create_commit :create_chat_room
  private
  def create_chat_room
    ChatRoom.create(post: self)
  end
end
