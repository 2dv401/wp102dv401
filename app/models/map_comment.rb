class MapComment < ActiveRecord::Base
  belongs_to :map
  belongs_to :user
  attr_accessible :content
end
