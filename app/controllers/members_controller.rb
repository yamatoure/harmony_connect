class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @members = Member.all
  end

  def new
    @member = Member.new
  end

  def create
    
  end
end
