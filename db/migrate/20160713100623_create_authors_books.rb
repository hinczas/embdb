class CreateAuthorsBooks < ActiveRecord::Migration
  def change
    create_table :authors_books, :id => false do |t|
      t.integer :author_id
      t.integer :book_id

      t.timestamps null: false
    end
    add_index :authors_books, :author_id
    add_index :authors_books, :book_id
    add_index :authors_books, [:author_id, :book_id], unique: true
  end
end
