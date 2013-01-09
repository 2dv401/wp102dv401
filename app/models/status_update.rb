class StatusUpdate < ActiveRecord::Base
	belongs_to :map
  belongs_to :user



	attr_accessible :content, :map_id, :user_id

  validates :content, presence: true, length: { :maximum => 2 }
  validates :map_id, presence: true
  validates :user_id, presence: true
end
