class Author < ActiveRecord::Base
require 'csv'
  validates :name, :last_name, presence: true, allow_blank: false, :uniqueness => {:case_sensitive => false}
  has_and_belongs_to_many :books
  
  def full_name
	 "#{last_name}, #{name}"
  end
  
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Author.create! row.to_hash
	end
	end
end
