class RenameMaplocations < ActiveRecord::Migration
  def self.up
    rename_table :map_locations, :locations_maps
  end

 def self.down
    rename_table :locations_maps, :map_locations
 end
end