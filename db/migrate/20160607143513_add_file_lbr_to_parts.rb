class AddFileLbrToParts < ActiveRecord::Migration
  def change
    add_column :parts, :file_lbr, :text
  end
end
