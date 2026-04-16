class DirectMessage < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  after_create_commit :broadcast_message
  after_destroy_commit :broadcast_remove

  private

  def broadcast_message
    ActionCable.server.broadcast(
      "conversation_#{conversation.id}",
      render_message
    )
    conversation.touch
  end

  def broadcast_remove
    ActionCable.server.broadcast(
      "conversation_#{conversation.id}",
      { remove: id }
    )
  end

  def render_message
    ApplicationController.renderer.render(
      partial: "direct_messages/direct_message",
      locals: { direct_message: self, user_id: user_id }
    )
  end
end
