class AddPhotoToPcbs < ActiveRecord::Migration
  def change
    add_column :pcbs, :photo, :text
  end
end
