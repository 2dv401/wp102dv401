class Tag < ActiveRecord::Base
  has_and_belongs_to_many :maps, uniq: true
  validates :word, :uniqueness => { :case_sensitive => false }
  attr_accessible :word
  
  before_save do
    self.word = self.word.downcase
  end
end
