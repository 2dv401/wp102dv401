class LocationsController < ApplicationController
  def create
    @location = Location.find_by_latitude_and_longitude(@map.latitude,@map.longitude)
    # Om inte positionen finns skapas den
    unless @location.any?
      @location = Location.new do |l|
        l.longitude = @map.longitude
        l.latitude = @map.latitude
      end
  end

  def destroy
  end
end
