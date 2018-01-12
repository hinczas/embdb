json.array!(@photos) do |photo|
  json.extract! photo, :id, :name, :hash_name, :project_id
  json.url photo_url(photo, format: :json)
end
