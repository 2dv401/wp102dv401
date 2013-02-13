class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, :null => false, :limit => 50
      t.text :description, :null => false, :limit => 15360, :default => ""
      t.float :longitude, :null => false
      t.float :latitude, :null => false
      t.boolean :private, :null => false, :default => false
      t.boolean :gmaps, :null => false, :default => true
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
end
