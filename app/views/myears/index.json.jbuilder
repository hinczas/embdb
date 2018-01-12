json.array!(@myears) do |myear|
  json.extract! myear, :id, :myear, :notes
  json.url myear_url(myear, format: :json)
end
