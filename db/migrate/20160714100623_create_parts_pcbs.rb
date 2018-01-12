class CreatePartsPcbs < ActiveRecord::Migration
  def change
    create_table :parts_pcbs, :id => false do |t|
      t.integer :part_id
      t.integer :pcb_id

      t.timestamps null: false
    end
    add_index :parts_pcbs, :part_id
    add_index :parts_pcbs, :pcb_id
    add_index :parts_pcbs, [:part_id, :pcb_id], unique: true
  end
end
