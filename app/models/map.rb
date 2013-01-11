class Map < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :locations
  has_many :status_updates, :dependent => :destroy  
  acts_as_followable
  acts_as_gmappable

  attr_accessible :name, :description, :private, :longitude, :latitude

  validates	:name, 
  :presence => { :message => "Field for title can't be empty." },
  :length => { :maximum => 45, :message => "Title can't be longer than 45 characters." }

  validates 	:description,
  :presence => { :message => "Field for description can't be empty." },
  :length => { :maximum => 250, :message => "Description can't be longer than 250 characters." }

  validates 	:private, :inclusion => {:in => [true, false]}

  validates	:longitude, :presence => true
  validates	:latitude, :presence => true

  def follow(user)  
    @follower = Follower.new()
    @follower.save
  end
end