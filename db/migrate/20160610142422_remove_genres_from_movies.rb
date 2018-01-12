class RemoveGenresFromMovies < ActiveRecord::Migration
  def change
    remove_column :movies, :genres, :string
  end
end
