class StatusUpdatesController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @status_update = StatusUpdate.find(params[:status_update_id])

    if current_user.likes?(@status_update)
      current_user.unlike!(@status_update)
    else
      current_user.like!(@status_update)
    end

    redirect_to map_path(params[:map_id])
  end

  def create
    #Skapar ny statusuppdatering från post-parametrarna samt lägger till aktuella användaren
    @status_update = StatusUpdate.new(params[:status_update])
    @status_update.user = current_user
    @status_update.map = Map.find(params[:map_id])

    if @status_update.save
      flash[:notice] = "Statusuppdatering sparad"
    else
      flash[:notice] = "Fel nar statusuppdatering skulle sparas"
    end
    redirect_to map_path(params[:map_id])
  end

  def destroy
    @status_update = StatusUpdate.find(params[:id])
    @status_update.destroy
    redirect_to map_path(params[:map_id])
  end
end
