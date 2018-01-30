class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :l_name
      t.text :l_description
      t.text :l_note

      t.timestamps null: false
    end
  end
end
