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

  def show
    @group = Group.find(params[:id])
    @areas = @group.areas
    @parts = @group.parts
  end

  def edit
    @group = Group.find(params[:id])
    unless current_user.id == @group.user_id
      redirect_to root_path
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  def group_params
    params.require(:group).permit(:title, :content, area_ids: [], part_ids: []).merge(user_id: current_user.id)
  end
end
