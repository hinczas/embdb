class CreatePcbs < ActiveRecord::Migration
  def change
    create_table :pcbs do |t|
      t.string :name
      t.string :version
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.float :cost
      t.text :changelog
      t.string :sch_file
      t.string :brd_file
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
