class Location < ActiveRecord::Base
  acts_as_gmappable
  has_many :marks, dependent: :destroy
  accepts_nested_attributes_for :marks
  has_many :maps, dependent: :destroy

  attr_accessible :latitude, :longitude

  validates	:longitude, presence: true
  validates	:latitude, presence: true
end
