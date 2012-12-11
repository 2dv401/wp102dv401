class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, :null => false, :limit => 50
      t.text :description, :null => false, :limit => 256
      t.boolean :private, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
end
