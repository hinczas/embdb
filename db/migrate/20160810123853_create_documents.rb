class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.string :hash_name
      t.attachment :file
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
