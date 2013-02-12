class JavascriptsController < ApplicationController
  ### UNDER UTVECKLING!
  ### ANVÄND EJ!
  ### PILLA INTE SÖNDER KOD!
  ### EJ SLUTGILTLIG VERSION!
  def maps
    require('json')
    api_key = params[:api_key]

    ## Kolla om en API-nyckel är medskickad, är den inte det, ge ett felmeddelande
    ## TODO: Sätta korrekt HTTP-status vid fel
    unless(params.has_key?(:api_key))
      output = {'error' => 'Saknar API-nyckel'}.to_json
      render :json => output
      return
    end

    ## Hämtar aktuell karta.
    @embed_map = Map.find_by_api_key(api_key)

    ## Kolla om kartan är privat, privata karotr kan inte användas med API:et
    ## TODO: Sätta korrekt HTTP-status vid fel.
    if @embed_map.private?
      output = {'error' => 'Kan ej badda in privata kartor.'}.to_json
      render :json => output
      return
    end

    ## Map i json
    @map = @embed_map.to_json

    ## Göra om koordinater till korrekt json
    @marks_coordinates = @embed_map.marks.to_gmaps4rails

    ## Markeringar i json-format med diverse info, tex namn beskrivning osv.
    @marks_info = @embed_map.marks.to_json

    ## Locations i JSON
    @location = @embed_map.location.to_json
  end
end

