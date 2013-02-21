class StatusUpdatesController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @update = StatusUpdate.find(params[:status_update_id])

    if current_user.likes?(@update)
      current_user.unlike!(@update)
    else
      current_user.like!(@update)
    end

    render template: 'status_updates/remote/like_button_toggle'
  end

  def create
    #Skapar ny statusuppdatering från post-parametrarna samt lägger till aktuella användaren
    @update = StatusUpdate.new(params[:status_update])
    @update.user = current_user
    @update.map = Map.find(params[:map_id])
    if current_user == @update.map.user
      if @update.save
        flash[:success] = t :created, scope: [:status_updates]
      else
        flash[:error] = t :failed_to_create, scope: [:status_updates]
      end
    else
      flash[:error] = t :access_denied
    end
    redirect_to profile_map_path(@update.map.user.slug, @update.map.slug)
  end

  def destroy
    @update = StatusUpdate.find(params[:id])
    @destroyed_update = @update

    if current_user == @update.user
      if @update.destroy
        flash[:success] = t :removed, scope: [:status_updates]
      else
        flash[:error] = t :failed_to_remove, scope: [:status_updates]
      end
    else
      flash[:error] = t :access_denied
    end
    render template: 'status_updates/remote/remove_status_update'
  end
end
