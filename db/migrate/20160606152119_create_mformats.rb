class CreateMformats < ActiveRecord::Migration
  def change
    create_table :mformats do |t|
      t.string :mformat
      t.text :notes

      t.timestamps null: false
    end
  end
end
