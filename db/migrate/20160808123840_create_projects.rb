class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :code
      t.string :name
      t.string :version
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.text :description
      t.text :log
      t.string :folder_location
      t.string :background

      t.timestamps null: false
    end
  end
end
