class MapsController < ApplicationController
  before_filter :authenticate_user!
  def index

   @maps = Map.find(:all, :conditions => [ "user_id = ?", current_user.id])

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
  #Nya objekt som kommer finnas på maps-sidan
  @status_update = StatusUpdate.new
  @status_comment = StatusComment.new

  @map_comment = MapComment.new

    #todo: kontrollera ifall anv�ndaren ska f� se kartan
    #todo: kontrollera att kartan finns
    #@map =  Map.find(:all, :conditions => [ "id = ?",  params[:id]])

  # Referens till ett Map-objekt
  @map = Map.find(params[:id])

  if request.path != map_path(@map)
    redirect_to @map, status: :moved_permanently
  end

  @locations = @map.locations

  # Referens till ett gmaps-objekt
  if @locations.any?

  	#G�r om startpunkten till en location
    @location = Location.new
  	@location.name = @map.name
  	@location.description = @map.description
  	@location.latitude = @map.latitude
  	@location.longitude = @map.longitude
  	@location.location_type = LocationType.new(:name => "Startpunkt")
  	@location.save
  	@locations << @location
    @display_map = @locations.to_gmaps4rails
  else
    @display_map = @map.to_gmaps4rails
  end
  
end

  def new
    @map = Map.new
    logger.debug @map

    #todo: h�mta default-koordinater n�nstans/anv�nds geolocation som default
    @map.longitude = 18
    @map.latitude = 59.33
    @map_options = get_map_options
  end

  def create
      
      @map = Map.new(params[:map])
      @map_options = get_map_options
      @map.gmaps = true
      @map.user_id = current_user.id
      
      puts @map

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
        if current.user == @map.user

          @map_options = get_map_options

        else
          flash[:notice] = "Fel, bara ägaren till kartan kan ändra den."
          redirect_to map_path(@map)
        end
      end

      # PUT /maps/:slug/edit
      def update
        @map = Map.find(params[:id])
        if current.user == @map.user

          @map_options = get_map_options

          if @map.update_attributes(params[:map])
            flash[:notice] = "Kartan sparades!"
            redirect_to map_path(@map)
          else
            flash[:error] = "Fel intraffade nar kartan skulle sparas."
            render :action => "edit"
          end
        else
          flash[:notice] = "Fel, bara ägaren till kartan kan uppdatera den."
        end
      end

      def destroy
       @map = Map.find(params[:id])
       if current.user == @map.user
         if @map.destroy
           flash[:notice] = "Kartan borttagen"
         else
           flash[:notice] = "Fel nar kartan skulle tagas bort"
         end
       else
         flash[:notice] = "Fel, bara ägaren till kartan kan ta bort den."
       end
       redirect_to root_path
     end
     
     # Sets options for map
     def get_map_options
       
        return  {
          "map_options" => {
            "auto_zoom" => false,
            "zoom" => 8,
            "center_latitude" => @map.latitude,
            "center_longitude" => @map.longitude
            },
            "markers" => {
              "data" => @map.to_gmaps4rails
            }
        }
        	
     end
  end
