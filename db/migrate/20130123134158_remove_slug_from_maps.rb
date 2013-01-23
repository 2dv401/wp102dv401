class RemoveSlugFromMaps < ActiveRecord::Migration
  def up
    remove_column :maps, :slug
  end

  def down
  end
end
