json.array!(@projects) do |project|
  json.extract! project, :id, :code, :name, :version, :start_date, :end_date, :notes, :description, :log, :folder_location, :background
  json.url project_url(project, format: :json)
end
