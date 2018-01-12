class CreatePartPcbs < ActiveRecord::Migration
  def change
    create_table :part_pcbs do |t|
	  t.belongs_to :part, index: true
      t.belongs_to :pcb, index: true
      t.integer :quantity
      t.timestamps null: false
    end
  end
end
