class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, :null => false, :limit => 50
      t.text :description, :null => false
      t.string :creator
      t.timestamps
    end
  end
end
