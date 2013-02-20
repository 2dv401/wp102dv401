require File.dirname('') + '/config/environment.rb'
class MapsController < ApplicationController
  before_filter :authenticate_user!
  ## Skippa validering på embeddade kartor.
  skip_before_filter :authenticate_user!, only: ['embed']

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
    render template: 'maps/follow/toggle'
  end

  def show
    begin
      # Hämtar användaren som äger kartan för att filtrera
      @user = User.find(params[:profile_id])

      # Hämtar rätt karta från användarens samling
      @map = @user.maps.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      render template: 'maps/404', status: 404
      return
    end
    #Nya objekt som kan skapas på maps-sidan
    @status_update = StatusUpdate.new
    @status_comment = StatusComment.new
    @map_comment = MapComment.new
    @mark = Mark.new do |m|
      m.build_location
    end

    # Kontrollerar om användaren har behörighet att titta på kartan.
    if @map.private? and @map.user != current_user
      flash[:error] = t :private, scope: [:maps]
      render template: 'maps/show_private.html.erb'
      return
    end

    ## Räkna sidvisningar på kartan, men inte på egna kartor.
    if @map.user.id != current_user.id
      @map.increment :map_views
      @map.save
    end

    display_map(@map)
  end

  def new
    # skapar ett map-objekt och ett sätter map-location till default
    @map = Map.new do |map|
      map.location = Location.new do |l|
        l.latitude = 60
        l.longitude = 15
      end
      map.zoom = 5
    end
    display_map(@map)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {map: @map, display_map: @display_map }}
    end
  end

  def create
    # Tar bort IDt från en tidigare sparad location (om valideringen failats)
    # Tar man bort denna rad kastas undantag för det inte går att assiciera en 
    # redan befintlig location med ett objekt som inte än är skapad (kartan)
    params[:map][:location_attributes][:id] = nil

    @map = Map.new(params[:map]) do |m|
      m.user = current_user
      m.location = Location.find_by_latitude_and_longitude(m.latitude, m.longitude) || m.location
    end
    
    if @map.save
      flash[:success] = t :created, map: @map.name, scope: [:maps]
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    else
      display_map(@map)
      flash[:error] = t :failed_to_create, scope: [:maps]
      render action: :new
    end

  end

  # GET profiles/:username/maps/:slug/edit
  def edit
    # Hämtar användaren som äger kartan för att filtrera
    @user = User.find(params[:profile_id])

    # Hämtar rätt karta från användarens samling
    @map = @user.maps.find(params[:id])

    display_map(@map)
    unless current_user == @map.user
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@user.slug, @map.slug)
    end
  end

  # PUT /maps/:slug/edit
  def update
    # Hämtar rätt karta från användarens samling
    @map = Map.find(params[:id])
    # Sparar undan sluggen om namn-fältet är tomt
    @slug = @map.slug

    display_map(@map)
    if current_user == @map.user
      if @map.update_attributes(params[:map])
        @map.location = Location.find_or_create_by_latitude_and_longitude(@map.latitude, @map.longitude)
        flash[:success] = t :updated, map: @map.name, scope: [:maps]
        redirect_to profile_map_path(@map.user.slug, @map.slug)
      else
        flash[:error] = t :failed_to_update, scope: [:maps]
        render action: :edit
      end
    else
      flash[:error] = t :access_denied
      redirect_to profile_map_path(@map.user.slug, @map.slug)
    end
  end

  def destroy
    @map = Map.find(params[:id])
    @map_name = @map.name
    if current_user == @map.user
      if @map.destroy
        flash[:success] = t :removed, map: @map_name, scope: [:maps]
      else
        flash[:error] = t :failed_to_remove, scope: [:maps]
      end
    else
      flash[:error] = t :access_denied
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



  ### UNDER UTVECKLING!
  ### ANVÄND EJ!
  ### PILLA INTE SÖNDER KOD!
  ### EJ SLUTGILTLIG VERSION!
  ## ------------------------------

  ## Genererar en karta utifrån angiven API-nyckel
  def embed
    ## Beroende
    require 'json'
    ## API nyckel
    key = params[:api_key]
    ## Standard värden för höj bredd och enhet samt karttyp.
    if(params.has_key?(:width))
      @width = params[:width]
    else
      @width = '100'
    end

    if(params.has_key?(:height))
      @height = params[:height]
    else
      @height = '100'
    end

    if(params.has_key?(:unit))
      @unit = params[:unit]
    else
      @unit = '%'
    end

    if(params.has_key?(:mapType))
      @map_type = params[:mapType]
    else
      @map_type = 'ROADMAP'
    end
    ## Hämtar aktuell karta.
    @embed_map = Map.find_by_api_key(key)

    if @embed_map.private?
      output = {'error' => 'Kan ej badda in privata kartor.'}.to_json
      render :json => output
      return
    end
    ## Map i json
    @map = @embed_map.to_json

    ## Göra om koordinater till korrekt json
    @marks = @embed_map.marks.to_gmaps4rails

    ## Locations i JSON
    @location = @embed_map.location.to_json


    respond_to do |format|
      format.html { render :html => {:map => @map,
                                     :marks => @marks,
                                     :location => @location}, :layout => false }

      format.json { render :json =>  {:map => @map,
                                      :marks => @marks,
                                      :location => @location} }
    end


    ##render :layout => false
  end
end
