class ProfilesController < ApplicationController
  def index
  end

  def show
    @user = User.find_by_slug(params[:id])
  end
end