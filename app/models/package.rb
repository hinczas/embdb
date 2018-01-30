class Package < ActiveRecord::Base
  validates :pk_name, presence: true, allow_blank: false , :uniqueness => {:case_sensitive => false}
  has_many :parts, dependent: :nullify
  def self.search_number(search)
	where("lower(pk_name) = lower(:search)",search: "#{search}")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Package.create! row.to_hash
	end
	end
end
