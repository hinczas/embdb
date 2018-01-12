class CreateShoppingLists < ActiveRecord::Migration
  def change
    create_table :shopping_lists do |t|
      t.integer :item_id
      t.string :item_type
      t.integer :item_quantity

      t.timestamps null: false
    end
  end
end
