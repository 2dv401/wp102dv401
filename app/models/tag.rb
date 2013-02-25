class Tag < ActiveRecord::Base
  has_and_belongs_to_many :maps, uniq: true

  attr_accessible :word
end
