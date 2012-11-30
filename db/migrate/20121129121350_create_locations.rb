class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :header, :limit => 32, :null => false
      t.string :description, :limit => 256, :null => false
      t.float :longitude, :null => false
      t.float :latitude, :null => false
      t.datetime :date
      t.boolean :private, :default => false, :null => false
      t.timestamps
    end
  end

  def down
    drop_table :locations
  end
end
