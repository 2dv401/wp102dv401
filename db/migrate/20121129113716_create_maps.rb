class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name, :null => false, :limit => 50
      t.text :description, :null => false, :limit => 256
      t.private :private, :null => false
      t.int :user_id, :null => false
      t.timestamps
    end
  end
end
