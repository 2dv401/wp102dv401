class AddSlugToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :slug, :string
    add_index :maps, :slug
  end
end
