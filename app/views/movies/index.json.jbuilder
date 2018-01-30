json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :sub_title, :num_title, :part, :genres, :imdb, :postgres, :sunopsis, :last_seen, :watch_count, :own, :mtype, :myear, :mformat, :quality, :mlanguage, :msubtitle, :threed
  json.url movie_url(movie, format: :json)
end
