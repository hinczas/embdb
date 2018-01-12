class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.integer :series
      t.string :isbn
      t.string :language
      t.text :sunopsis
      t.string :cover
      t.string :cover_typ
      t.integer :year
      t.text :notes
      t.references :author, index: true, foreign_key: true
      t.references :publisher, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
