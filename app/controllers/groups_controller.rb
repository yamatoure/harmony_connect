class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def group_params
    params.require(:group).permit(:title, :content, area_ids: [], part_ids: []).merge(user_id: current_user.id)
  end
end
