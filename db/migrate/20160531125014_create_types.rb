class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :name
      t.text :t_description
      t.text :t_note

      t.timestamps null: false
    end
  end
end
