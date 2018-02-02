class AddFileToParts < ActiveRecord::Migration
  def change
    add_column :parts, :file_1, :text
  end
end
