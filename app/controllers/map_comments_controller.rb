class MapCommentsController < ApplicationController
  # GET /map_comments
  # GET /map_comments.json
  def index
    @map_comments = MapComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @map_comments }
    end
  end

  # GET /map_comments/1
  # GET /map_comments/1.json
  def show
    @map_comment = MapComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @map_comment }
    end
  end

  # GET /map_comments/new
  # GET /map_comments/new.json
  def new
    @map_comment = MapComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @map_comment }
    end
  end

  # GET /map_comments/1/edit
  def edit
    @map_comment = MapComment.find(params[:id])
  end

  # POST /map_comments
  # POST /map_comments.json
  def create
    @map_comment = MapComment.new(params[:map_comment])

    respond_to do |format|
      if @map_comment.save
        format.html { redirect_to @map_comment, notice: 'Map comment was successfully created.' }
        format.json { render json: @map_comment, status: :created, location: @map_comment }
      else
        format.html { render action: "new" }
        format.json { render json: @map_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /map_comments/1
  # PUT /map_comments/1.json
  def update
    @map_comment = MapComment.find(params[:id])

    respond_to do |format|
      if @map_comment.update_attributes(params[:map_comment])
        format.html { redirect_to @map_comment, notice: 'Map comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @map_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /map_comments/1
  # DELETE /map_comments/1.json
  def destroy
    @map_comment = MapComment.find(params[:id])
    @map_comment.destroy

    respond_to do |format|
      format.html { redirect_to map_comments_url }
      format.json { head :no_content }
    end
  end
end
