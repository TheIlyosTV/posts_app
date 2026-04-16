class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.all_conversations.includes(:sender, :receiver, :direct_messages)
    @users = User.where.not(id: current_user.id).order(created_at: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])
    redirect_to conversations_path, alert: "Sizning chatingizga kirishga ruxsat yo'q!" unless @conversation.sender_id == current_user.id || @conversation.receiver_id == current_user.id
    @direct_messages = @conversation.direct_messages.includes(:user).order(created_at: :asc)
    @other_user = @conversation.other_user(current_user)
  end

  def create
    receiver = User.find(params[:user_id])

    if receiver.id == current_user.id
      redirect_to conversations_path, alert: "O'zingiz bilan chat qila olmaysiz!"
      return
    end

    @conversation = Conversation.between(current_user.id, receiver.id).first

    if @conversation.nil?
      @conversation = Conversation.create(sender_id: current_user.id, receiver_id: receiver.id)
    end

    redirect_to conversation_path(@conversation)
  end
end
