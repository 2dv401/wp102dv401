class SearchesController < ApplicationController
  before_filter :authenticate_user!

  def cloud_search

  end

  def search
    @result_maps = Map.search_for(params[:query])
    @result_users = User.search_for(params[:query])
    @result_count = @result_maps.size
  end

end
