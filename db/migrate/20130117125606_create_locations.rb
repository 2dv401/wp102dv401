class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float :longitude, :null => false
      t.float :latitude, :null => false

      t.timestamps
    end
  end
end
