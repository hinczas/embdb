class AddColumnsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :director, :text
    add_column :movies, :writer, :text
    add_column :movies, :actor, :text
  end
end
