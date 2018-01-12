class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :sub_title
      t.integer :num_title
      t.integer :part
      t.string :genres
      t.string :imdb
      t.text :postgres
      t.text :sunopsis
      t.timestamp :last_seen
      t.integer :watch_count
      t.integer :own
      t.references :mtype, index: true, foreign_key: true
      t.references :myear, index: true, foreign_key: true
      t.references :mformat, index: true, foreign_key: true
      t.references :quality, index: true, foreign_key: true
      t.references :mlanguage, index: true, foreign_key: true
      t.references :msubtitle, index: true, foreign_key: true
      t.references :threed, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
