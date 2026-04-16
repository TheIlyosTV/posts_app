class DirectMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])

    if @conversation.sender_id != current_user.id && @conversation.receiver_id != current_user.id
      redirect_to conversations_path, alert: "Siz bu chatga xabar yubora olmaysiz!"
      return
    end

    @message = @conversation.direct_messages.build(message_params)
    @message.user = current_user

    if @message.save
      recipient = @conversation.other_user(current_user)
      if recipient != current_user
        Notification.create(
          user: recipient,
          content: "#{current_user.first_name || current_user.email.split('@').first} sizga xabar yubordi",
          notification_type: "message",
          link: conversation_path(@conversation)
        )
      end
      @conversation.touch
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      redirect_to conversation_path(@conversation), alert: "Xabar yuborilmadi!"
    end
  end

  private

  def message_params
    params.require(:direct_message).permit(:content)
  end
end
