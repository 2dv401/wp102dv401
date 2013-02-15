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

    # Kontrollerar att användaren är kartans ägare
    if @map.user == current_user
      @mark = Mark.new do |m|
        m.map = @map
        m.build_location
      end
      display_map(@mark.map)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @mark }
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # GET /marks/1/edit
  def edit
    @mark = Mark.find(params[:id])
    @map = @mark.map

    # Kollar så att användaren är ägare till markeringen eller kartan
    if @mark.user == current_user or @map.user == current_user
      display_map(@mark.map)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @mark }
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # POST /marks
  # POST /marks.json
  def create
    @map = Map.find_by_slug(params[:map_id])

    # kontrollerar att användaren är ägare till kartan
    if @map.user == current_user
      @mark = Mark.new(params[:mark]) do |m|
        m.map = @map
        m.user = current_user
        m.location = Location.find_by_latitude_and_longitude(m.latitude, m.longitude) || m.location
      end

      unless @mark.exists_in_map?
        display_map(@mark.map)
        respond_to do |format|
          if @mark.save
            format.html {
              flash[:success] = t :created, mark: @mark.name, scope: [:marks]
              redirect_to profile_map_path(@mark.map.user.slug, @mark.map.slug)
            }
            format.json { render json: @mark, status: :created, location: @mark.map }
          else
            format.html {
              flash[:error] = t :failed_to_create, scope: [:marks]
              render action: "new"
            }
            format.json { render json: @mark.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:error] = t :mark_exists_in_map, scope: [:marks]
        render action: "new"
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # PUT /marks/1
  # PUT /marks/1.json
  def update
    @mark = Mark.find(params[:id])
    @map = @mark.map

    # Kollar så att användaren är ägare till markeringen eller kartan
    if @mark.user == current_user or @map.user == current_user
      respond_to do |format|
        if @mark.update_attributes(params[:mark])
          format.html {
            flash[:success] = t :updated, mark: @mark.name, scope: [:marks]
            redirect_to profile_map_path(@mark.map.user.slug, @mark.map.slug)
          }
          format.json { head :no_content }
        else
          format.html {
            flash[:error] = t :failed_to_update, scope: [:marks]
            render action: "edit" }
          format.json { render json: @mark.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  # DELETE /marks/1
  # DELETE /marks/1.json
  def destroy
    @mark = Mark.find(params[:id])
    @map = @mark.map

    # Kollar så att användaren är ägare till markeringen eller kartan
    if @mark.user == current_user or @map.user == current_user
      respond_to do |format|
        if @mark.destroy
          format.html { flash[:success] = t :removed, mark: @mark.name, scope: [:marks] }
          format.json { head :no_content }
        else
          format.html { flash[:error] = t :failed_to_remove, scope: [:marks] }
          format.json { render json: @mark.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = t :access_denied
    end
    redirect_to profile_map_path(@mark.map.user.slug, @mark.map.slug)
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
