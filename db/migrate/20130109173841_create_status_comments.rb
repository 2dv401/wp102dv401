class CreateStatusComments < ActiveRecord::Migration
  def change
    create_table :status_comments do |t|
      t.references :user, :null => false
      t.references :status_update, :null => false
      t.string :content, :null => false, :limit => 5120, :default => ""

      t.timestamps
    end
    add_index :status_comments, [:user_id, :status_update_id]
  end
end
