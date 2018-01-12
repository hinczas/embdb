class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :part_number
      t.text :part_name
      t.string :p_type
      t.text :p_description
      t.text :keywords
      t.float :voltage
      t.float :current
      t.text :p_note
      t.integer :p_quantity
      t.integer :p_pin_count
      t.references :package, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.references :manufacturer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
