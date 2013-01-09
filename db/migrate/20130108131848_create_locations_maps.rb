class CreateLocationsMaps < ActiveRecord::Migration
  def up
    create_table :locations_maps, :id => false do |t|
      t.references :location
      t.references :map
    end

    add_index :locations_maps, [:location_id, :map_id]

  end

  def down
    drop_table :locations_maps
  end
end