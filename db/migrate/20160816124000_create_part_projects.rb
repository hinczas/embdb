class CreatePartProjects < ActiveRecord::Migration
  def change
    create_table :part_projects do |t|
	  t.belongs_to :part, index: true
      t.belongs_to :project, index: true
      t.integer :quantity
      t.timestamps null: false
    end
  end
end
