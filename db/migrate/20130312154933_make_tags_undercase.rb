class MakeTagsUndercase < ActiveRecord::Migration
  def change
    Tag.all.each do |tag|
      tag.update_attributes word: tag.word.downcase
    end
  end
end
