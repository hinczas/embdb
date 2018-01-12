json.array!(@qualities) do |quality|
  json.extract! quality, :id, :quality, :notes
  json.url quality_url(quality, format: :json)
end
