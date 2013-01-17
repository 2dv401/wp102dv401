class Mark < ActiveRecord::Base
  belongs_to :map
  belongs_to :location

  attr_accessible :description, :location, :map, :name

  validates	:name, :presence => true, :length => { :maximum => 240 }
  validates	:description, :presence => true, :length => { :maximum => 5120 }
end
