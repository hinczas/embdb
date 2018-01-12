class AddPhotoToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :pk_photo, :text
  end
end
