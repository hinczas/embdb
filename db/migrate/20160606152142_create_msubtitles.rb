class CreateMsubtitles < ActiveRecord::Migration
  def change
    create_table :msubtitles do |t|
      t.string :msubtitle
      t.text :notes

      t.timestamps null: false
    end
  end
end
