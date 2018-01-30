class ChangeFileType < ActiveRecord::Migration
  def change
	change_column :parts, :file_1,  :binary
  end
end
