class CreateMapLocations < ActiveRecord::Migration
  def change
     create_table :map_locations, :id => false do |t|
      t.integer :map_id
      t.integer :location_id
    end
  end
  
   def down
      drop_table :map_locations
   end
end