json.array!(@shopping_lists) do |shopping_list|
  json.extract! shopping_list, :id, :item_id, :item_type, :item_quantity
  json.url shopping_list_url(shopping_list, format: :json)
end
