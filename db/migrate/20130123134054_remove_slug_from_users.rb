class RemoveSlugFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :slug
  end

  def down
  end
end
