class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @user = User.find_by_slug(params[:id])
    
    if @user.nil?
      redirect_to root_path
    else
      @maps = @user.maps
    end
  end

  def show_maps
    @user = User.find_by_slug(params[:profile_id])
    @maps = @user.maps
  end
end