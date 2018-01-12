class Book < ActiveRecord::Base
require 'csv'
  has_and_belongs_to_many :authors
  belongs_to :publisher
  belongs_to :user
   def self.search(search)
	where("title LIKE :search OR subtitle LIKE :search ",search: "%#{search}%")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Book.create! row.to_hash
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
