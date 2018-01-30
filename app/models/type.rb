class Type < ActiveRecord::Base
  validates :name, presence: true, allow_blank: false, :uniqueness => {:case_sensitive => false}
  has_many :parts, dependent: :nullify
  def self.search_name(search)
	where("lower(name) = lower(:search)",search: "#{search}")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Location.create! row.to_hash
	end
	end
end
