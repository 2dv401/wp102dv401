class Map < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :scoped, :scope => :user

	belongs_to :user
  belongs_to :location

  has_many :marks, :dependent => :destroy
  has_many :status_updates, :dependent => :destroy
  has_many :map_comments, :dependent => :destroy

  acts_as_followable
  acts_as_gmappable
  
  MAP_TYPES = [ "HYBRID", "ROADMAP", "SATELLITE", "TERRAIN"]

  attr_accessor :longitude, :latitude
  attr_accessible :name, :description, :private, :zoom, :map_type, :longitude, :latitude

  validates	:name, :presence => true, :length => { :maximum => 45 }
  validates	:description, :length => { :maximum => 250 }
  validates :private, :inclusion => {:in => [true, false]}
  validates :map_type, :inclusion => MAP_TYPES
  validates :zoom, :numericality => { :only_integer => true }

  def follow(user)  
    @follower = Follower.new()
    @follower.save
  end

end