class Map < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :map_locations
	
	validates_presence_of :map_id, :message => "Map could not be found!"
	
	validates_presence_of :user_id, :message => "User could not be found!"
	
	validates_length_of :description, :maximum => 45 , :message => "Description can't be longer than 30 characters!"
	
	validates_presence_of :private, :message => ""
	
end