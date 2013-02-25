class CreateMapsTags < ActiveRecord::Migration
  def change
    create_table :maps_tags, id: false do |t|
      t.references :map, :null => false
      t.references :tag, :null => false
    end

    add_index :maps_tags, [ :map_id, :tag_id ], unique: true
  end
end
