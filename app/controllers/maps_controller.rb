class MapsController < ApplicationController
  def index
  
  #todo: kontrollera att en anv�ndare �r inloggad
  #todo: h�mta endast anv�ndarens kartor
  @maps = Map.all.to_gmaps4rails
  
  end

  def new
      #todo: kontrollera att en anv�ndare �r inloggad
		newmap = Map.new
      #todo: s�tt default-koordinater n�nstans
      newmap.longitude = 15
      newmap.latitude = 60
      
      @map = newmap.to_gmaps4rails
  end
  
  def create
   
  end

  def edit
  end

  def update
  end

  def delete
	
  end
end
