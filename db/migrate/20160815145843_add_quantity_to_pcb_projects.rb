class AddQuantityToPcbProjects < ActiveRecord::Migration
  def change
    add_column :pcb_projects, :quantity, :integer
  end
end
