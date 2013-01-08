class StatusUpdate < ActiveRecord::Base
	belongs_to :map
  belongs_to :user

  has_many :comments

	attr_accessible :content
	validates :content, presence: true, length: { :maximum => 5120 }
end
