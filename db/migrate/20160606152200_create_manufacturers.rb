class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers, force: :cascade do |t|
		t.string   :m_name
		t.text     :m_full_name
		t.text     :m_description
		t.text     :m_address
		t.text     :m_email
		t.text     :m_website
		t.text     :m_note
		t.timestamp :created_at
		t.timestamp :updated_at
		t.string   :logo
		
		t.timestamps null: false
    end
  end
end
