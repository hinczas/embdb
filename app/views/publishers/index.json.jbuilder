json.array!(@publishers) do |publisher|
  json.extract! publisher, :id, :name, :full_name, :address, :website, :contact, :notes
  json.url publisher_url(publisher, format: :json)
end
