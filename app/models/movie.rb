class Movie < ActiveRecord::Base
require 'csv'
  belongs_to :mtype
  belongs_to :myear
  belongs_to :mformat
  belongs_to :quality
  belongs_to :mlanguage
  belongs_to :msubtitle
  belongs_to :threed
  has_and_belongs_to_many :genres
 
  
  def self.search(search)
	where("title LIKE :search OR sub_title LIKE :search ",search: "%#{search}%")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Movie.create! row.to_hash
	end
	end
	  	def self.all_csv(options = {})
		CSV.generate(options) do |csv|
		  csv << column_names
		  self.all.each do |row|
			csv << row.attributes.values_at(*column_names)
		  end
		end
	  end
end
