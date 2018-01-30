class CreatePackages < ActiveRecord::Migration
  def change		
	create_table :packages, force: :cascade do |t|
		t.string   :pk_number
		t.string   :pk_name
		t.text     :pk_description
		t.text     :pk_note
		t.timestamp :created_at
		t.timestamp :updated_at
		t.text     :pk_photo
		
		t.timestamps null: false
    end
  end
end
