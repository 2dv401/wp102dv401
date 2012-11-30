class Location < ActiveRecord::Base
  attr_accessible :date, :description, :header, :latitude, :longitude
end
