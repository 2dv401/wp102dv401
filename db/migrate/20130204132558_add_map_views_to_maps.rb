class AddMapViewsToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :map_views, :integer, :null => false, :default => 0
  end
end
