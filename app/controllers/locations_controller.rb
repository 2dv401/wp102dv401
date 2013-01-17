class LocationsController < ApplicationController
  def create
    # @location = Location.find_or_create_by_latitude_and_longitude(params[:latitude], params[:longitude])
  end

  def destroy
    location = Location.find(params[:id])

    location.destroy
  end
end
