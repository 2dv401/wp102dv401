class LocationsController < ApplicationController
	before_filter :authenticate_user!, :except => [:create]
	def index
	end
	def show
	end
	def new
	end
	def create 
		@map = Map.find(params[:id])
		
		@location = Location.new
		@location.name = params[:titel]
		@location.description = params[:description]
		@location.longitude = params[:longitude]
		@location.latitude = params[:latitude]
		@location.date = Time.now
		#locationtype måste implementeras rätt
		@location.place_type_id = 1
		
		if @location.save
		   @map.locations << @location
		   #av någon anledning blir man utloggad när man postar formuläret, kanske beror på devise? 
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
	end
end
