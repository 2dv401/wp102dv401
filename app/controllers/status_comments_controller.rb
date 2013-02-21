class StatusCommentsController < ApplicationController
  before_filter :authenticate_user!

  def toggle_like
    @status_comment = StatusComment.find(params[:status_comment_id])

    if current_user.likes?(@status_comment)
      current_user.unlike!(@status_comment)
    else
      current_user.like!(@status_comment)
    end

    render template: 'status_comments/remote/like_button_toggle'
  end

  def create
    #Skapar ny statusuppdatering från post-parametrarna samt lägger till aktuella användaren
    @comment = StatusComment.new(params[:status_comment]) do |c|
    c.user = current_user
    c.status_update = StatusUpdate.find(params[:status_update_id])
    end

    if @comment.save
      if not request.xhr?
        flash[:success] = t :created, scope: [:status_comment]
      end
    else
      if not request.xhr?
        flash[:error] = t :failed_to_create, scope: [:status_comment]
      end
    end
    render template: 'status_comments/remote/render_new_status_comment'
  end

  def destroy
    @comment = StatusComment.find(params[:id])
    @destroyed_comment = @comment

    if current_user == @comment.user || current_user == @map.user
      if @comment.destroy
        flash[:success] = t :removed, scope: [:status_comment]
      else
        flash[:error] = t :failed_to_remove, scope: [:status_comment]
      end
    else
      flash[:error] = t :access_denied
    end
    render template: 'status_comments/remote/remove_status_comment'
  end
end
