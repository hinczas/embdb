class CreateGenresMovies < ActiveRecord::Migration
  def change
    create_table :genres_movies, :id => false do |t|
      t.integer :genre_id
      t.integer :movie_id

      t.timestamps null: false
    end
    add_index :genres_movies, :genre_id
    add_index :genres_movies, :movie_id
    add_index :genres_movies, [:genre_id, :movie_id], unique: true
  end
end
