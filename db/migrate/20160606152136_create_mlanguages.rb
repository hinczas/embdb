class CreateMlanguages < ActiveRecord::Migration
  def change
    create_table :mlanguages do |t|
      t.string :mlanguage
      t.text :notes

      t.timestamps null: false
    end
  end
end
