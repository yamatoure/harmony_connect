class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    user = User.find_by(id: params[:id])
    if user.present?
      unless current_user.id == user.id
        redirect_to root_path
      else
        @groups = user.groups
        @member = user.member
      end
    else
      redirect_to root_path
    end
  end

  def edit
    user = User.find_by(id: params[:id])
    if user.present?
      unless current_user.id == user.id
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(current_user.id)
    if user.destroy
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
