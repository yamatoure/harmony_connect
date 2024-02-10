class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @members = Member.all
  end

  def new
    if current_user.member.present?
      redirect_to edit_member_path(current_user.member)
    else
      @member = Member.new
    end
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to members_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @member = Member.find(params[:id])
    @areas = @member.areas
    @parts = @member.parts
  end

  def edit
    @member = Member.find(params[:id])
    unless current_user.id == @member.user_id
      redirect_to root_path
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to members_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    member = Member.find(params[:id])
    member.destroy
    redirect_to members_path
  end

  private
  def member_params
    params.require(:member).permit(:title, :content, area_ids: [], part_ids: []).merge(user_id: current_user.id)
  end
end
