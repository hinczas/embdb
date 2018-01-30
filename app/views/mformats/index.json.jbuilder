json.array!(@mformats) do |mformat|
  json.extract! mformat, :id, :mformat, :notes
  json.url mformat_url(mformat, format: :json)
end
