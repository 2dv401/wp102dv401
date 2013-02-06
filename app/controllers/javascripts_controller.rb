class JavascriptsController < ApplicationController
  ### UNDER UTVECKLING!
  ### ANVÄND EJ!
  ### PILLA INTE SÖNDER KOD!
  ### EJ SLUTGILTLIG VERSION!
  def maps
    require('json')
    api_key = params[:api_key]

    ## Hämtar aktuell karta.
    @embed_map = Map.find_by_api_key(api_key)

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
  end
end

