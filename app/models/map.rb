class Map < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]


	belongs_to :user

  has_many :status_updates, :dependent => :destroy
  has_many :map_comments, :dependent => :destroy

  acts_as_followable
  acts_as_gmappable

  attr_accessible :name, :description, :private, :longitude, :latitude

  validates	:name, :presence => true, :length => { :maximum => 45 }
  validates	:description, :presence => true, :length => { :maximum => 250 }
  validates :private, :inclusion => {:in => [true, false]}
  validates	:longitude, :presence => true
  validates	:latitude, :presence => true




  def follow(user)  
    @follower = Follower.new()
    @follower.save
  end

end