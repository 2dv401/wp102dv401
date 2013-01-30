class StatusUpdatesController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @update = StatusUpdate.find(params[:status_update_id])

    if current_user.likes?(@update)
      current_user.unlike!(@update)
    else
      current_user.like!(@update)
    end

    render :template => 'status_updates/like/toggle'
  end

  def create
    #Skapar ny statusuppdatering från post-parametrarna samt lägger till aktuella användaren
    @update = StatusUpdate.new(params[:status_update])
    @update.user = current_user
    @update.map = Map.find(params[:map_id])

    if @update.save
      flash[:notice] = "Statusuppdatering sparad"
    else
      flash[:notice] = "Fel nar statusuppdatering skulle sparas"
    end
    redirect_to profile_map_path(@update.map.user.slug, @update.map.slug)
  end

  def destroy
    @update = StatusUpdate.find(params[:id])
    @map = @update.map
    if current_user == @update.user
      if @update.destroy
        flash[:notice] = "Statusen borttagen"
      else
        flash[:notice] = "Fel nar statusen skulle tagas bort"
      end
    else
      flash[:notice] = "Fel, bara agaren till kartan kan ta bort statusen."
    end
    redirect_to profile_map_path(@map.user.slug, @map.slug )
  end
end
