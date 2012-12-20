class AddGmapsToLocation < ActiveRecord::Migration  
   def self.up
      add_column :locations ,:gmaps, :boolean, :default=>true, :null=>false
   end
 
   def self.down
      remove_column :gmaps
   end
end  