class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      if @post.user != current_user
        Notification.create(
          user: @post.user,
          content: "#{current_user.first_name || current_user.email.split('@').first} sizning postingizga izoh qoldirdi",
          notification_type: "comment",
          link: post_path(@post)
        )
      end
      redirect_to @post, notice: "Izoh qo'shildi!"
    else
      redirect_to @post, alert: "Izoh qo'shilmadi!"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to @comment.post, notice: "Izoh o'chirildi!"
    else
      redirect_to @comment.post, alert: "Siz faqat o'zingizning izohlaringizni o'chira olasiz!"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
