class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show ]
  before_action :set_current_user, only: [ :update ]

  def show
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profil muvaffaqiyatli yangilandi!"
    else
      @user = current_user
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_user
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def set_current_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:username, :avatar, :first_name, :last_name, :phone, :bio)
  end
end
