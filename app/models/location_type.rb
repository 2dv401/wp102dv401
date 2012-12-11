class LocationType < ActiveRecord::Base
	has_many :locations
  	# attr_accessible :title, :body
end
