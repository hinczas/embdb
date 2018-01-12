json.array!(@mlanguages) do |mlanguage|
  json.extract! mlanguage, :id, :mlanguage, :notes
  json.url mlanguage_url(mlanguage, format: :json)
end
