class StatusCommentsController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @map = Map.find(params[:map_id])
    @update = StatusUpdate.find(params[:status_update_id])
    @status_comment = StatusComment.find(params[:status_comment_id])

    if current_user.likes?(@status_comment)
      current_user.unlike!(@status_comment)
    else
      current_user.like!(@status_comment)
    end

    render :template => 'status_comments/like/toggle'
  end

  def create
    #Skapar ny statusuppdatering från post-parametrarna samt lägger till aktuella användaren
    @status_comment = StatusComment.new(params[:status_comment])
    @status_comment.user = current_user
    @status_comment.status_update = StatusUpdate.find(params[:status_update_id])

    if @status_comment.save
      flash[:notice] = "Kommentaren sparad"
    else
      flash[:notice] = "Fel nar kommentaren skulle sparas"
    end
    redirect_to map_path(params[:map_id])
  end

  def destroy
    @status_comment = StatusComment.find(params[:id])
    if current_user == @status_comment.user || current_user == @status_comment.status_update.map.user
      if @status_comment.destroy
        flash[:notice] = "Kommentaren borttagen"
      else
        flash[:notice] = "Fel nar kommentaren skulle tagas bort"
      end
    else
      flash[:notice] = "Fel, bara personen som skrev kommentaren och agaren till kartan kan ta bort den."
    end
    redirect_to map_path(params[:map_id])
  end
end
