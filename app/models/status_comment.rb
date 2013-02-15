class StatusComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :status_update

  acts_as_likeable

  attr_accessible :content

  validates :content, presence: true, length: { maximum: 5120 }
end
