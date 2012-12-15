class DashboardController < ApplicationController
	before_filter :authenticate_user!

  def index
  	@User = User.all


  	if connected_user = session['warden.user.twitter.connected_user.key'].present?
  		connected_user = User.find(connected_user)

	  # Ask user if she/he wants to merge her/his accounts
	  # (or just go ahead and merge them)
	end
  end
end
