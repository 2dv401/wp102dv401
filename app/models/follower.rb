class Follower < ActiveRecord::Base
	belongs_to :user
	belongs_to :map
  # attr_accessible :title, :body
end
