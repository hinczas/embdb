class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|
      t.string :name
      t.string :full_name
      t.text :address
      t.string :website
      t.string :contact
      t.text :notes

      t.timestamps null: false
    end
  end
end
