class Location < ActiveRecord::Base
  acts_as_gmappable
  has_many :marks, dependent: :destroy
  accepts_nested_attributes_for :marks
  has_many :maps, dependent: :destroy

  attr_accessible :latitude, :longitude

  validates	:longitude, presence: true, format: { with: /^(-?(?:1[0-7]|[1-9])?\d(?:\.\d{1,18})?|180(?:\.0{1,18})?)$/ }
  validates	:latitude, presence: true, format: { with: /^(-?[1-8]?\d(?:\.\d{1,18})?|90(?:\.0{1,18})?)$/ }
end
