class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :name
      t.text :middle_name
      t.text :surname
      t.date :birth_date
      t.text :address
      t.string :mobile
      t.string :email
      t.string :photo
      t.string :encrypted_password
      t.string :salt
      t.text :notes
      t.string :username

      t.timestamps null: false
    end
  end
end
