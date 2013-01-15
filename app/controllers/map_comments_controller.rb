class MapCommentsController < ApplicationController

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
    @map_comment.destroy
    redirect_to map_path(params[:map_id])
  end
end
