class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @groups = Group.all.order("created_at DESC")
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
    @group = Group.includes(:areas, :parts).find_by(id: params[:id])
    if @group.present?
      @areas = @group.areas
      @parts = @group.parts
    else
      redirect_to root_path
    end
  end

  def edit
    @group = Group.find_by(id: params[:id])
    if @group.present?
      unless current_user.id == @group.user_id
        redirect_to root_path
      end
    else
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

  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to groups_path
  end

  def search
    search_area_params = params[:area_ids].compact_blank
    search_part_params = params[:part_ids].compact_blank
    @groups = Group.search(search_area_params, search_part_params).order("created_at DESC")
  end

  private
  def group_params
    params.require(:group).permit(:title, :content, area_ids: [], part_ids: []).merge(user_id: current_user.id)
  end
end
