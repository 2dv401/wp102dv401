class AddApikeyToMaps < ActiveRecord::Migration
  def change
  	add_column :maps, :api_key, :string
  end
end
