class CreatePcbProjects < ActiveRecord::Migration
  def change
    create_table :pcb_projects do |t|
	  t.belongs_to :pcb, index: true
      t.belongs_to :project, index: true
      t.timestamps null: false
    end
  end
end
