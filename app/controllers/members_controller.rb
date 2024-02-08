class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def new
    @member = Member.new
  end

  def create
    
  end
end
