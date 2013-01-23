class Mark < ActiveRecord::Base

  belongs_to :user
  belongs_to :map
  belongs_to :location
  acts_as_gmappable
  accepts_nested_attributes_for :location
  attr_accessible :description, :name, :location_attributes


  validates	:name, :presence => true, :length => { :maximum => 240 }
  validates	:description, :presence => true, :length => { :maximum => 5120 }

  def longitude
    self.location.longitude
  end

  def latitude
    self.location.latitude
  end

  def exists_in_map?
    self.map.marks.find_each do |mark|
      if self.location == mark.location
        return true
      end
    end
    return false
  end
end
