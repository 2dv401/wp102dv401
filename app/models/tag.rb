class Tag < ActiveRecord::Base
  has_and_belongs_to_many :maps, uniq: true

  attr_accessible :word

  validates	:word, presence: true, length: { minimum: 2, maximum: 20 }
end
