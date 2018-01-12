class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :last_name
      t.text :notes

      t.timestamps null: false
    end
  end
end
