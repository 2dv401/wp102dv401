class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.string :name
      t.string :description
      t.reference :map
      t.reference :location

      t.timestamps
    end
  end
end
