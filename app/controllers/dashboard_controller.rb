class DashboardController < ApplicationController
	before_filter :authenticate_user!

  def index
  	@User = User.all
  end
end
