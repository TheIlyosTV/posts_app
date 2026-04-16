class ChatRoom < ApplicationRecord
  belongs_to :post
  has_many :messages, dependent: :destroy

  broadcasts_to :post
end
