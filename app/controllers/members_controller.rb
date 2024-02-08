class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @members = Member.all
  end

  def new
    @member = Member.new
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

  private
  def member_params
    params.require(:member).permit(:title, :content, area_ids: [], part_ids: []).merge(user_id: current_user.id)
  end
end
