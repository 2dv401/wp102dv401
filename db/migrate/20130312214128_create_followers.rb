class CreateFollowers < ActiveRecord::Migration
  def up
    create_table :followers do |t| 
      t.timestamps
    end
  end

  def down
    drop_table :followers
  end
end
