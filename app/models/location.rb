class Location < ActiveRecord::Base
	has_and_belongs_to_many :maps
	belongs_to :location_type

  	attr_accessible :date, :description, :name, :latitude, :longitude, :private

  	validates	:name, 
  				:presence => { :message => "The field for name can't be empty." },
  				:length => { :maximum => 32, :message => "Name can't be longer than 32 characters." }

  	validates	:description, 
  				:presence => { :message => "The field for description can't be empty." },
  				:length => { :maximum => 250, :message => "Description can't be longer than 250 characters." }

  	validates	:longitude, :presence => true
  	validates	:latitude, :presence => true
end
