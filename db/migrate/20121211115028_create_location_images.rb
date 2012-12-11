class CreateLocationImages < ActiveRecord::Migration
  def change
    create_table :location_images do |t|
		t.string :file_name, :null => false, :limit => 32
		t.text :description, :null => false, :limit => 256
		t.integer :location_id, :null => false
		t.timestamps
    end
  end

  def down
    drop_table :location_images
  end
end
