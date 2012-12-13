class Map < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :map_locations
	acts_as_gmappable
   
   attr_accessor :first_name, :last_name
   
	validates_presence_of :user_id, :message => "User could not be found!"
	
	validates_length_of :description, :maximum => 45 , :message => "Description can't be longer than 45 characters!"
	
	validates :private, :inclusion => {:in => [true, false]}
   
   validates	:longitude, :presence => true
  	validates	:latitude, :presence => true
	
end