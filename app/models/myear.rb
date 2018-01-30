class Myear < ActiveRecord::Base
	has_many :movies, dependent: :nullify
  def self.search(search)
	keyword=search[0..3]
	where("myear = :keyword",keyword: "#{keyword}")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Myear.create! row.to_hash
	end
	end
end
