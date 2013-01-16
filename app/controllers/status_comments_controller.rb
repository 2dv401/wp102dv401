class StatusCommentsController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @status_comment = StatusComment.find(params[:status_comment_id])

    if current_user.likes?(@status_comment)
      current_user.unlike!(@status_comment)
    else
      current_user.like!(@status_comment)
    end

    redirect_to map_path(params[:map_id])
  end

  def create
    #Skapar ny statusuppdatering från post-parametrarna samt lägger till aktuella användaren
    @comment = StatusComment.new(params[:status_comment])
    @comment.user = current_user
    @comment.status_update = StatusUpdate.find(params[:status_update_id])

    if @comment.save
      flash[:notice] = "Kommentaren sparad"
    else
      flash[:notice] = "Fel nar kommentaren skulle sparas"
    end
    redirect_to map_path(params[:map_id])
  end

  def destroy
    @comment = StatusComment.find(params[:id])
    @comment.destroy
    redirect_to map_path(params[:map_id])
  end
end
