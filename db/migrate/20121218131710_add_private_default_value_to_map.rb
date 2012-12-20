class AddPrivateDefaultValueToMap < ActiveRecord::Migration
  def change
    change_column_default(:maps, :private, false)
  end
end
