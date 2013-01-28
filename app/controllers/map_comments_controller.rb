class MapCommentsController < ApplicationController

  # POST map/:id/map_comments/toggle_like
  def toggle_like
    @map = Map.find(params[:map_id])
    @map_comment = MapComment.find(params[:map_comment_id])

    if current_user.likes?(@map_comment)
      current_user.unlike!(@map_comment)
    else
      current_user.like!(@map_comment)
    end
    render :template => 'map_comments/like/toggle'
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
    redirect_to profile_map_path(@comment.map.user.slug, @comment.map.slug)
  end

  # DELETE /maps/:id/map_comments/1
  # DELETE /maps/:id/map_comments/1.json
  def destroy
    @comment = MapComment.find(params[:id])
    @map = @comment.map
    if current_user == @comment.user || current_user == @map.user
      if @comment.destroy
        flash[:notice] = "Kommentaren borttagen"
      else
        flash[:notice] = "Fel nar kommentaren skulle tagas bort"
      end
    else
      flash[:notice] = "Fel, bara personen som skrev kommentaren och agaren till kartan kan ta bort den."
    end
    redirect_to profile_map_path(@map.user.slug, @map.slug)
  end
end
