class StatusUpdatesController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @update = StatusUpdate.find(params[:status_update_id])

    if current_user.likes?(@update)
      current_user.unlike!(@update)
    else
      current_user.like!(@update)
    end

    render :template => 'status_updates/remote/like_button_toggle'
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
    @destroyed_update = @update

    if current_user == @update.user
      if @update.destroy
        flash[:notice] = "Statusen borttagen"
      else
        flash[:notice] = "Fel nar statusen skulle tagas bort"
      end
    else
      flash[:notice] = "Fel, bara agaren till kartan kan ta bort statusen."
    end
    render :template => 'status_updates/remote/remove_status_update'
  end
end
