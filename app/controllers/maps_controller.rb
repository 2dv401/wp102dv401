class MapsController < ApplicationController
  before_filter :authenticate_user!
  def index

   @maps = Map.find(:all, :conditions => [ "user_id = ?", current_user.id])
 end

 def follow
    @map = Map.find(params[:map_id])
    current_user.follow!(@map)
    redirect_to @map
 end

 def unfollow
    @map = Map.find(params[:map_id])
    current_user.unfollow!(@map)
    redirect_to @map
 end
 def show

    #Ny statusuppdatering som ligger och hänger
    @status_update = StatusUpdate.new

    #todo: kontrollera ifall användaren ska få se kartan
    #todo: kontrollera att kartan finns
    #@map =  Map.find(:all, :conditions => [ "id = ?",  params[:id]])

    # Referens till ett Map-objekt
   @map = Map.find(params[:id])

   @locations = @map.locations
   
   # Referens till ett gmaps-objekt
   if @locations.any?
    @display_map = @locations.to_gmaps4rails
  else
    @display_map = @map.to_gmaps4rails
  end
  
end

def new
  @map = Map.new
  logger.debug @map

      #todo: hämta default-koordinater nånstans/används geolocation som default
      @map.longitude = 18
      @map.latitude = 59.33

      @map_options = {
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

      def create
        @map = Map.new

        @map.name = params[:name]
        @map.description = params[:description]

        @map.latitude = params[:latitude]
        @map.longitude = params[:longitude]

      #todo: Av någon anledning går det inte att skapa karta om private är "false"
      @map.private = params[:private]
      @map.gmaps = true
      
      @map.user_id = current_user.id

      @map_options = {
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

        if @map.save
          redirect_to map_path(@map)
        else
          render :action => "new"
        end

      end

      def edit
      end

      def update
      end

      def destroy
       @map = Map.find(params[:id])
       @map.destroy
     end
   end
