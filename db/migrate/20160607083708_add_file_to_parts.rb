class AddFileToParts < ActiveRecord::Migration
  def change
    add_column :parts, :file_1, :blob
  end
end
