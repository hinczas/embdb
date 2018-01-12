json.array!(@mtypes) do |mtype|
  json.extract! mtype, :id, :mtype, :notes
  json.url mtype_url(mtype, format: :json)
end
