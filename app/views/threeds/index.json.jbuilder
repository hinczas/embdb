json.array!(@threeds) do |threed|
  json.extract! threed, :id, :threed, :notes
  json.url threed_url(threed, format: :json)
end
