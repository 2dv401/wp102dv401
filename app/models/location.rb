class Location < ActiveRecord::Base

  has_many :marks, :dependent => :destroy

  attr_accessible :latitude, :longitude

  validates	:longitude, :presence => true
  validates	:latitude, :presence => true
end
