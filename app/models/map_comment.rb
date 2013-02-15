class MapComment < ActiveRecord::Base
  belongs_to :map
  belongs_to :user

  acts_as_likeable

  # attributes
  attr_accessible :content

  # validation
  validates :content, presence: true, length: { maximum: 5120 }

end
