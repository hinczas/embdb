class Publisher < ActiveRecord::Base
require 'csv'
  validates :name, presence: true, allow_blank: false,:uniqueness => {:case_sensitive => false}
  has_many :books, dependent: :nullify
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Publisher.create! row.to_hash
	end
	end
end
