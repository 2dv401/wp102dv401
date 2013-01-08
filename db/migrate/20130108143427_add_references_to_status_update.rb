class AddReferencesToStatusUpdate < ActiveRecord::Migration
  def change
  	change_table :status_updates do |t|
  		t.references :map
      t.references :user
  	end
  end
end
