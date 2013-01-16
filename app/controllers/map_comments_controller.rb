class MapCommentsController < ApplicationController

  # POST map/:id/map_comments/toggle_like
  def toggle_like
    @map_comment = MapComment.find(params[:map_comment_id])

    if current_user.likes?(@map_comment)
      current_user.unlike!(@map_comment)
    else
      current_user.like!(@map_comment)
    end

    redirect_to map_path(params[:map_id])
  end

  # POST map/:id/map_comments
  def create
    #Skapar ny kartkommentar från post-parametrarna samt lägger till aktuella användaren
    @comment = MapComment.new(params[:map_comment])
    @comment.user = current_user
    @comment.map = Map.find(params[:map_id])

    if @comment.save
      flash[:notice] = "Kommentaren sparad"
    else
      flash[:notice] = "Fel nar kommentaren skulle sparas"
    end
    redirect_to map_path(params[:map_id])
  end

  # DELETE /maps/:id/map_comments/1
  # DELETE /maps/:id/map_comments/1.json
  def destroy
    @map_comment = MapComment.find(params[:id])
    if current.user == @map_comment.user || current.user == @map_comment.map.user
      if @map_comment.destroy
        flash[:notice] = "Kommentaren borttagen"
      else
        flash[:notice] = "Fel nar kommentaren skulle tagas bort"
      end
    else
      flash[:notice] = "Fel, bara personen som skrev kommentaren och ägaren till kartan kan ta bort den."
    end
    redirect_to map_path(params[:map_id])
  end
end
