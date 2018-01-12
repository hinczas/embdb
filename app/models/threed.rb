class Threed < ActiveRecord::Base
	has_many :movies, dependent: :nullify
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Threed.create! row.to_hash
	end
	end
end
