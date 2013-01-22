class AddLocationZoomAndMapTypeToMaps < ActiveRecord::Migration
  def change
    change_table :maps do |t|
      t.remove :user_id, :latitude, :longitude

      t.references :location
      t.references :user
      t.integer :zoom, :null => false, :default => 8
      t.string :map_type, :null => false, :default => "HYBRID"
    end
    add_index :maps, :user_id
    add_index :maps, :location_id
  end
end
