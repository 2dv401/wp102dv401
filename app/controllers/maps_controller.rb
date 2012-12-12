class MapsController < ApplicationController
  def index
  
  #todo: kontrollera att en användare är inloggad
  #todo: hämta endast användarens kartor
  @maps = Map.all.to_gmaps4rails
  
  end

  def new
      #todo: kontrollera att en användare är inloggad
		newmap = Map.new
      #todo: sätt default-koordinater nånstans
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
