class MapsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @maps = Map.order("created_at ASC").find_all_by_user_id(current_user.id)
  end

  def follow
    @map = Map.find(params[:map_id])
    current_user.follow!(@map)
    render :template => 'maps/follow/toggle'
  end

  def unfollow
    @map = Map.find(params[:map_id])
    current_user.unfollow!(@map)
    render :template => 'maps/follow/toggle'
  end
  def show
    #Nya objekt som kan skapas på maps-sidan
    @status_update = StatusUpdate.new
    @status_comment = StatusComment.new
    @map_comment = MapComment.new
    @mark = Mark.new

    # Referens till ett Map-objekt
    @map = Map.find(params[:id])

    display_map(@map)
  end

  def new
    @map = Map.new
    #todo: h�mta default-koordinater n�nstans/anv�nds geolocation som default
    @map.location = Location.find_or_create_by_latitude_and_longitude(60, 15)
    @map.zoom = 5
    display_map(@map)
  end

  def create
    @map = Map.new(params[:map])
    @map.user = current_user
    @map.location = Location.find_or_create_by_latitude_and_longitude(@map.latitude, @map.longitude)
    display_map(@map)

    if @map.save
      flash[:notice] = "Kartan sparades!"
      redirect_to map_path(@map)
    else
      flash[:error] = "Fel intraffade nar kartan skulle sparas."
      render :action => "new"
    end

  end

  # GET /maps/:slug/edit
  def edit
    @map = Map.find(params[:id])
    display_map(@map)
    unless current_user == @map.user
      flash[:notice] = "Fel, bara agaren till kartan kan andra den."
      redirect_to map_path(@map)
    end
  end

  # PUT /maps/:slug/edit
  def update
    @map = Map.find(params[:id])
    display_map(@map)
    if current_user == @map.user
      if @map.update_attributes(params[:map])
        @map.location = Location.find_or_create_by_latitude_and_longitude(@map.latitude, @map.longitude)
        flash[:notice] = "Kartan sparades!"
        redirect_to map_path(@map)
      else
        flash[:error] = "Fel intraffade nar kartan skulle sparas."
        render :action => "edit"
      end
    else
      flash[:notice] = "Fel, bara agaren till kartan kan uppdatera den."
      redirect_to map_path(@map)
    end

  end

  def destroy
    @map = Map.find(params[:id])
    if current_user == @map.user
      if @map.destroy
        flash[:notice] = "Kartan borttagen"
      else
        flash[:notice] = "Fel nar kartan skulle tagas bort"
      end
    else
      flash[:notice] = "Fel, bara agaren till kartan kan ta bort den."
    end
    redirect_to root_path
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
