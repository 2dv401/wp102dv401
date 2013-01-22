class MarksController < ApplicationController
  # GET /marks
  # GET /marks.json
  def index
    @marks = Mark.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @marks }
    end
  end

  # GET /marks/1
  # GET /marks/1.json
  def show
    @mark = Mark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mark }
    end
  end

  # GET /marks/new
  # GET /marks/new.json
  def new
    @mark = Mark.new
    @map = Map.find(params[:map_id]) 
    @mark.build_location
    @display_map = @map.to_gmaps4rails
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mark }
    end
  end

  # GET /marks/1/edit
  def edit

    # Inte 100%
    @mark = Mark.find(params[:id])
  end

  # POST /marks
  # POST /marks.json
  def create
    @mark = Mark.new(params[:mark])

    @mark.location = Location.find_by_latitude_and_longitude(@mark.location.latitude, @mark.location.longitude) ||  @mark.location

    # Eftersom parametrarna innehåller kartans slug istället för ID
    # måste vi hitta ID't genom att att slå upp kartan mot sluggen
    # och sedan koppla kartan till markeringen
    @mark.map = Map.find_by_slug(params[:map_id])
    
    respond_to do |format|
      if @mark.save
        format.html { redirect_to @mark.map, notice: 'Mark was successfully created.' }
        format.json { render json: @mark, status: :created, location: @mark.map }
      else
        format.html { render action: "new" }
        format.json { render json: @mark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /marks/1
  # PUT /marks/1.json
  def update

    # Inte 100% än
    # 
    # 
    @mark = Mark.find(params[:id])

    respond_to do |format|
      if @mark.update_attributes(params[:mark])
        format.html { redirect_to @map, notice: 'Mark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marks/1
  # DELETE /marks/1.json
  def destroy
    @mark = Mark.find(params[:id])
    @mark.destroy

    respond_to do |format|
      format.html { redirect_to marks_url }
      format.json { head :no_content }
    end
  end
end
