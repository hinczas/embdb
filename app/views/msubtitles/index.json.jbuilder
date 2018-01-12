json.array!(@msubtitles) do |msubtitle|
  json.extract! msubtitle, :id, :msubtitle, :notes
  json.url msubtitle_url(msubtitle, format: :json)
end
