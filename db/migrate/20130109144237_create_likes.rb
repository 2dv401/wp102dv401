class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes, :id => false do |t|
      t.references :user, :null => false
      t.references :status_update, :null => false

      t.timestamps
    end
    add_index :likes, [:user_id, :status_update_id]
  end
end