class DashboardController < ApplicationController
	before_filter :authenticate_user!

  def index
   @User = User.all

	@maps = Map.find(:all, :conditions => [ "user_id = ?", current_user.id])

	followed_maps_ids = Follow.find_all_by_follower_type_and_followable_type_and_follower_id(
								'User','Map',current_user.id).map(&:followable_id)
	
	@followed_maps = Map.find(followed_maps_ids)

	@new_maps = Map.find(:all, :conditions => [" created_at between ? AND ? AND private = ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day, false],
			:limit => 10, :order => 'created_at DESC')
	
  ## Alla kartor - Tillfälligt i DEV-läge
  @all_maps = Map.all
	
  	if connected_user = session['warden.user.twitter.connected_user.key'].present?
  		connected_user = User.find(connected_user)
	  # Ask user if she/he wants to merge her/his accounts
    # (or just go ahead and merge them)
    end

  end
end
