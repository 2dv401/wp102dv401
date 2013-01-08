class CreateLocationsMaps < ActiveRecord::Migration
  def up
    create_table :locations_maps, :id => false do |t|
      t.integer :location_id
      t.integer :map_id
    end

    add_index :locations_maps, [:location_id, :map_id]

  end

  def down
    drop_table :locations_maps
  end
end