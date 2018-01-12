class AddLogoToManufacturers < ActiveRecord::Migration
  def change
    add_column :manufacturers, :logo, :string
  end
end
