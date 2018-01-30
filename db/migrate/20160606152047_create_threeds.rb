class CreateThreeds < ActiveRecord::Migration
  def change
    create_table :threeds do |t|
      t.string :threed
      t.text :notes

      t.timestamps null: false
    end
  end
end
