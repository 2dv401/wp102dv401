class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :word, :null => false, :limit => 20

      t.timestamps
    end
  end
end
