class SearchesController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :map, :name, full: :true
  def autocomplete

    # bygger ihop en array med taggarna man sökt på, splittat på kommatecken
    @terms = params[:term].downcase.gsub(" ","").split(",")

    # Hämtar kartorna som matchar taggarna och tar bort dubletter
    @maps_from_tag_search = Tag.find_all_by_word(@terms, :include => [:maps]).collect(&:maps).flatten.uniq

    # Sök på kartors namn
    @maps_from_search = Map.find_all_by_name(params[:term]);

    # Sorterar kartorna efter hur många taggar som träffar
    @sorted_maps_from_tag_search =  @maps_from_tag_search.sort_by{|map| -map.tag_match_count(@terms)}

    # Sätter ihop arrayerna med sökresultaten
    @maps_from_search.concat(@maps_from_tag_search)


    # Tar bort dubletter
    @maps_from_search.uniq!
    
    #Bygger ihop en hash som sedan renderas ut till json
    @hash = []
    @maps_from_search.each do |map|
      @hash << {
        name: map.name, 
        tag_list: map.tag_list, 
        href: profile_map_url(map.user.slug, map.slug)
      }
    end

    render json: @hash
  end

  def search
    @result_maps = Map.search_for(params[:term.downcase])
    @result_users = User.search_for(params[:term])
    @result_count = @result_maps.size + @result_users.size
  end

  def result
    tags = Tag.find_by_word(params[:query.downcase])
    if tags
      @result_maps = tags.maps
      @result_count = @result_maps.size
    end

  end
end
