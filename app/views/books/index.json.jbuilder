json.array!(@books) do |book|
  json.extract! book, :id, :title, :subtitle, :series, :isbn, :language, :sunopsis, :cover, :year, :notes, :author_id_id, :publisher_id_id
  json.url book_url(book, format: :json)
end
