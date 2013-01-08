class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.string :content, :null => false, :limit => 5120, :default => ""
      t.timestamps
    end
  end
end
