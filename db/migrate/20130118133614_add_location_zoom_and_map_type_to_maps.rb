class AddLocationZoomAndMapTypeToMaps < ActiveRecord::Migration
  def change
    change_table :maps do |t|
      t.remove :user_id, :latitude, :longitude

      t.references :location, :null => false
      t.references :user, :null => false
      t.integer :zoom, :null => false, :default => 8
      t.string :map_type, :null => false, :default => "HYBRID"
    end
  end
end
