class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.references :map, :null => false
      t.references :location, :null => false
      t.string :name, :null => false, :limit => 240, :default => ""
      t.string :description, :null => false, :limit => 5120, :default => ""
      t.boolean :gmaps, :null => false, :default => true

      t.timestamps
    end
    add_index :marks, [:map_id, :location_id]
  end
end
