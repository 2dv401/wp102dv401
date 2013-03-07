class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
## Alla kartor
    @User = User.all

    ## Mina kartor
    @my_maps = current_user.maps

    followed_maps_ids = Follow.find_all_by_follower_type_and_followable_type_and_follower_id(
        'User','Map',current_user.id).map(&:followable_id)

    ## Kartor jag följer
    @followed_maps = Map.find(followed_maps_ids)

    # Kommer användas så att det går att kommentera statusuppdateringarna
    @status_comment = StatusComment.new

    ##@new_maps = Map.find(:all, :conditions => [" created_at between ? AND ? AND private = ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day, false],
    ##    :limit => 10, :order => 'created_at DESC')

    @new_maps = Map.where(:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)

    ## Alla kartor - Tillfälligt i DEV-läge
    @all_maps = Map.all

    if connected_user = session['warden.user.twitter.connected_user.key'].present?
      connected_user = User.find(connected_user)
      # Ask user if she/he wants to merge her/his accounts
      # (or just go ahead and merge them)
    end
  end
end
