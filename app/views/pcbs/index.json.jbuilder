json.array!(@pcbs) do |pcb|
  json.extract! pcb, :id, :name, :version, :start_date, :end_date, :notes, :cost, :changelog, :sch_file, :brd_file, :parent_id
  json.url pcb_url(pcb, format: :json)
end
