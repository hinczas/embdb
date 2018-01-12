class Genre < ActiveRecord::Base
  has_and_belongs_to_many :movies
  
  def self.search(search)
    searchstr = search.gsub!(" "){""}
    actual_search=search
    begin
		actual_search=searchstr.split(",")
	rescue
		actual_search=search
	end
	where("name in (:search)", search: actual_search)
  end
end
