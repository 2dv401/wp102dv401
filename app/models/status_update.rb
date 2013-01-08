class StatusUpdate < ActiveRecord::Base
	belongs_to :map
	attr_accessible :content
	validates :content, presence: true, length: { :maximum => 5120 }
end
