class AddPhotoToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :l_photo, :text
  end
end
