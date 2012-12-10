class Map < ActiveRecord::Base
	belongs_to :user
	has_many :map_places
	
	validates_presence_of :map_id, :message => "Map could not be found!"
	
	validates_presence_of :user_id, :message => "User could not be found!"
	
	validates_presence_of :description, :message => "Last name can't be empty!"
	validates_length_of :description, :maximum=> 45 , :message => "Description can't be longer than 30 characters!"
	
	validates_presence_of :private, :message => ""
	
end