class MapsController < ApplicationController
  before_filter :authenticate_user!
  def index
    ## Hämtar alla kartor användaren äger
    @maps = Map.order("created_at ASC").find_all_by_user_id(current_user.id)
  end

  def toggle
    @map = Map.find(params[:map_id])
    if current_user.follows?(@map)
      current_user.unfollow!(@map)
    else
      current_user.follow!(@map)
    end
    render :template => 'maps/follow/toggle'
  end

  def show
    #Nya objekt som kan skapas på maps-sidan
    @status_update = StatusUpdate.new
    @status_comment = StatusComment.new
    @map_comment = MapComment.new
    @mark = Mark.new do |m|
      m.build_location
    end


    # Referens till ett Map-objekt
    @map = Map.find(params[:id])

    # Kontrollerar om användaren har behörighet att titta på kartan.
    if @map.private? and @map.user.id != current_user.id
      flash[:notice] = "Kartan du forsoker titta pa ar privat!"
      redirect_to root_path
    end

    display_map(@map)
  end

  def new
    @map = Map.new
    #todo: h�mta default-koordinater n�nstans/anv�nds geolocation som default
    @map.location = Location.new do |l|
      l.latitude = 60
      l.longitude = 15
    end
    @map.zoom = 5
    display_map(@map)
  end

  def create
    @map = Map.new(params[:map]) do |m|
      m.user = current_user
      m.location = Location.find_by_latitude_and_longitude(m.latitude, m.longitude) || m.location
    end
    display_map(@map)

    if @map.save
      flash[:notice] = "Kartan sparades!"
      redirect_to profile_map_path(@map.user.slug, @map.slug)
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
      redirect_to profile_map_path(@map.user.slug, @map.slug)
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
        redirect_to profile_map_path(@map.user.slug, @map.slug)
      else
        flash[:error] = "Fel intraffade nar kartan skulle sparas."
        redirect_to edit_profile_map_path(@map.user.slug, @map.slug)
      end
    else
      flash[:notice] = "Fel, bara agaren till kartan kan uppdatera den."
      redirect_to profile_map_path(@map.user.slug, @map.slug)
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
            "center_latitude" => map.latitude.present? ? map.latitude : 60,
            "center_longitude" => map.longitude.present? ? map.longitude : 15
        },
        "markers" => {
          "data" => map.marks.to_gmaps4rails  do |mark, marker|
            marker.infowindow render_to_string(:partial => "marks/foobar",  :locals => { :mark => mark}) # Rendera 
            # en partial i infofönstret
            
            # ändra markeringens bild
            marker.picture({
                            :picture => "http://icons.iconarchive.com/icons/icons-land/vista-map-markers/32/Map-Marker-Bubble-Chartreuse-icon.png",
                            :width   => 32,
                            :height  => 32
                           })

            # Titeln
            marker.title   mark.name
            
            # Sidebar - inte implementerat
            #marker.sidebar "i'm the sidebar"

            # Om man vill lägga till fler fält till markeringen i jsonformat
            marker.json({ :id => mark.id, :foo => "bar" })
          end
        }
    }
  end
end
