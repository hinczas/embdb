class ChangeFileTypeToString < ActiveRecord::Migration
  def change
	change_column :parts, :file_1, :text
  end
end
