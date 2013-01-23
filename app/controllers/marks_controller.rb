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
    @map = Map.find_by_slug(params[:map_id])
    @mark = Mark.new do |m|
      m.map = @map
      m.build_location
    end
    display_map(@mark.map)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mark }
    end
  end

  # GET /marks/1/edit
  def edit
    # Inte 100%
    @mark = Mark.find(params[:id])
    display_map(@mark.map)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mark }
    end
  end

  # POST /marks
  # POST /marks.json
  def create
    @mark = Mark.new(params[:mark]) do |m|
      m.map = Map.find_by_slug(params[:map_id])
      m.user = current_user
      m.location = Location.find_by_latitude_and_longitude(m.latitude, m.longitude) ||  m.location
    end

    unless @mark.exists_in_map?
      respond_to do |format|
        if @mark.save
          format.html { redirect_to @mark.map, notice: 'Markeringen har sparats' }
          format.json { render json: @mark, status: :created, location: @mark.map }
        else
          format.html { redirect_to new_map_mark_path(@mark.map, @mark)}
          format.json { render json: @mark.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "Det finns redan en markering med denna position!"
      redirect_to new_map_mark_path(@mark.map, @mark)
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

  # Sets options for map
  def display_map(map)
    @display_map =  {
        "map_options" => {
            "auto_zoom" => true,
            "MapTypeId" => map.map_type.present? ? map.map_type : "HYBRID",
            "zoom" => map.zoom.present? ? map.zoom : 5,
            "center_latitude" => map.location.latitude.present? ? map.location.latitude : 60,
            "center_longitude" => map.location.longitude.present? ? map.location.longitude : 15
        },
        "markers" => {
            "data" => map.marks.to_gmaps4rails
        }
    }
  end
end
