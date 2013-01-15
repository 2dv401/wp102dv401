class CreateMapComments < ActiveRecord::Migration
  def change
    create_table :map_comments do |t|
      t.references :map
      t.references :user
      t.string :content

      t.timestamps
    end
    add_index :map_comments, :map_id
    add_index :map_comments, :user_id
  end
end
