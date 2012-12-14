class MapsController < ApplicationController
  before_filter :authenticate_user!
  def index
  
   @maps = Map.find(:all, :conditions => [ "user_id = ?", current_user.id])
  
  end

  def show
  
   #todo: kontrollera ifall anv�ndaren ska f� se kartan
   #todo: kontrollera att kartan finns
   @map =  Map.find(:all, :conditions => [ "id = ?",  params[:id]]).to_gmaps4rails
  
  end
  
  def new
      newmap = Map.new
      logger.debug newmap
      #todo: h�mta default-koordinater n�nstans/anv�nds geolocation som default
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
      
      #todo: Av n�gon anledning g�r det inte att skapa karta om private �r "false"
      map.private = params[:private]
      map.gmaps = true
      
      #todo: s�tt r�tt id
      map.user_id = current_user.id
      
      #todo: validera map
      map.save!
      
      #todo: g� till skapad karta?
      redirect_to :controller => "maps"
  end

  def edit
  end

  def update
  end

  def delete
	
  end
end
