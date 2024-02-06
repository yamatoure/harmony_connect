class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    
  end

  def new
    @group = Group.new
  end

  def create

  end
end
