class CreateInstagrams < ActiveRecord::Migration
  def change
    create_table :instagrams do |t|
      t.string :hashtag
      t.integer :user_id, :null => false
      t.integer :map_id, :null => false
      t.timestamps
    end
  end
end
