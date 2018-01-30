class AddForeignKey < ActiveRecord::Migration
  def change
	add_foreign_key :parts, :manufacturers
	add_foreign_key :parts, :locations
	add_foreign_key :parts, :packages
  end
end
