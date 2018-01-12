json.array!(@authors) do |author|
  json.extract! author, :id, :name, :last_name, :notes
  json.url author_url(author, format: :json)
end
