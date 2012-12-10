class MapsController < ApplicationController
  def index
  end

  def new
		#todo: kontrollera ifall användaren är inloggad
		
		map = Map.new
		map.name = params[:map][:name]
		map.description = params[:map][:description]
		map.private = params[:map][:private]
		#todo:userid?
		
		#todo:validera?
		
		map.save
		redirect_to :controller => "maps" ,:action => "show", :id => map.id
  end

  def edit
  end

  def update
  end

  def delete
	#todo:kontrollera ifall användaren äger kartan
	Map.find_by_id(params[:id]).destroy
  end
end
