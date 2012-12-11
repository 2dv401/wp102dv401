class CreateLocationTypes < ActiveRecord::Migration
  def change
    create_table :location_types do |t|
		t.string :name, :null => false, :limit => 45
		t.timestamps
    end
  end
  
  def down
    drop_table :location_types
  end
end
