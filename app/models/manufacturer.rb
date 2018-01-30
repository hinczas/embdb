class Manufacturer < ActiveRecord::Base
  validates :m_name, presence: true, allow_blank: false, :uniqueness => {:case_sensitive => false}
  has_many :parts, dependent: :nullify
  def self.search_name(search)
	where("lower(m_name) = lower(:search)",search: "#{search}")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Manufacturer.create! row.to_hash
	end
	end
end
