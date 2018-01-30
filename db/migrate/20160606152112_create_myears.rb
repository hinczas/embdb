class CreateMyears < ActiveRecord::Migration
  def change
    create_table :myears do |t|
      t.integer :myear
      t.text :notes

      t.timestamps null: false
    end
  end
end
