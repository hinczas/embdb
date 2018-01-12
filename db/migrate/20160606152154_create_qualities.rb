class CreateQualities < ActiveRecord::Migration
  def change
    create_table :qualities do |t|
      t.string :quality
      t.text :notes

      t.timestamps null: false
    end
  end
end
