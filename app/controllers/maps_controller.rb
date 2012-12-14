class MapsController < ApplicationController
  before_filter :authenticate_user!
  def index
  
   @maps = Map.find(:all, :conditions => [ "user_id = ?", current_user.id])
  
  end

  def show
  
   #todo: kontrollera ifall användaren ska få se kartan
   #todo: kontrollera att kartan finns
   @map =  Map.find(:all, :conditions => [ "id = ?",  params[:id]]).to_gmaps4rails
  
  end
  
  def new
      newmap = Map.new
      logger.debug newmap
      #todo: hämta default-koordinater nånstans/används geolocation som default
      newmap.longitude = 15
      newmap.latitude = 60
      
      @map = newmap.to_gmaps4rails
  end
  
  def create
      map = Map.new
      
      map.name = params[:name]
      map.description = params[:description]
      
      map.latitude = params[:latitude]
      map.longitude = params[:longitude]
      
      #todo: Av någon anledning går det inte att skapa karta om private är "false"
      map.private = params[:private]
      map.gmaps = true
      
      #todo: sätt rätt id
      map.user_id = current_user.id
      
      #todo: validera map
      map.save!
      
      #todo: gå till skapad karta?
      redirect_to :controller => "maps"
  end

  def edit
  end

  def update
  end

  def delete
	
  end
end
