class StatusUpdate < ActiveRecord::Base
	belongs_to :map
  belongs_to :user

  has_many :likes, :class_name => "Like",
           :source => :user,
           :dependent => :destroy


	attr_accessible :content, :map_id, :user_id, :likes

  validates :content, presence: true, length: { :maximum => 5120 }
  validates :map_id, presence: true
  validates :user_id, presence: true
end
