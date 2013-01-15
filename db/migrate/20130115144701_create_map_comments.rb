class CreateMapComments < ActiveRecord::Migration
  def change
    create_table :map_comments do |t|
      t.references :map, :null => false
      t.references :user, :null => false
      t.string :content, :null => false, :limit => 5120, :default => ""

      t.timestamps
    end
    add_index :map_comments, :map_id
    add_index :map_comments, :user_id
  end
end
