class Project < ActiveRecord::Base
require 'csv'
require 'rails/all'
  validates :name,  presence: true, allow_blank: false
  validates :code,  presence: true, allow_blank: false, :uniqueness => {:case_sensitive => false}
  has_many :pcb_projects
  has_many :pcbs, through: :pcb_projects
  has_many :part_projects
  has_many :parts, through: :part_projects
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, allow_destroy: true
validate :validate_end
  
  
def self.search(search)
	where("name LIKE :search OR version LIKE :search OR notes LIKE :search OR description like :search OR code like :search",search: "%#{search}%")
end

def self.pcbs_cost(id)
	query = <<-SQL
	  select sum(z.quantity * b.quantity * case when c.p_price is null then 0 else c.p_price end) as pr_cost
		from projects x
		left join pcb_projects z on z.project_id=x.id
		left join pcbs a on a.id=z.pcb_id
		left join part_pcbs b on a.id=b.pcb_id
		left join parts c on b.part_id=c.id
		where x.id=#{id}
	SQL

self.find_by_sql(query)
end

def self.pcbs_pr_cost(id)
	query = <<-SQL
	  select sum(z.quantity * a.cost) as pr_cost
		from projects x
		left join pcb_projects z on z.project_id=x.id
		left join pcbs a on a.id=z.pcb_id
		where x.id=#{id}
	SQL

self.find_by_sql(query)
end




def self.parts_cost(id)
	query = <<-SQL
	  select sum(b.quantity * case when c.p_price is null then 0 else c.p_price end) as pr_cost
		from projects x
		left join part_projects b on x.id=b.project_id
		left join parts c on b.part_id=c.id
		where x.id=#{id}
	SQL

self.find_by_sql(query)
end

def self.all_cost(id)
	query = <<-SQL
	  select round(sum(z.quantity * b.quantity * case when c.p_price is null then 0 else c.p_price end), 2) as pr_cost
		from projects x
		left join pcb_projects z on z.project_id=x.id
		left join pcbs a on a.id=z.pcb_id
		left join part_pcbs b on a.id=b.pcb_id
		left join parts c on b.part_id=c.id
		where x.id=#{id}
	SQL

self.find_by_sql(query)
end

def self.latest_cost(id)
	query = <<-SQL
	  select round(sum(z.quantity * b.quantity * case when c.p_price is null then 0 else c.p_price end), 2) as pr_cost
		from projects x, (select name, max(version) as version from pcbs group by name) table1
		left join pcb_projects z on z.project_id=x.id
		left join pcbs a on a.id=z.pcb_id
		left join part_pcbs b on a.id=b.pcb_id
		left join parts c on b.part_id=c.id
		where x.id=#{id}
		and a.name=table1.name and a.version=table1.version
	SQL

self.find_by_sql(query)
end

def self.all_parts(id)
	query = <<-SQL
	  select sum(b.quantity * z.quantity) as quantity, b.part_id, c.*, case when c.p_type is null then "" else c.p_type end as type
		from projects x
		left join pcb_projects z on z.project_id=x.id
		left join pcbs a on a.id=z.pcb_id
		left join part_pcbs b on a.id=b.pcb_id
		left join parts c on b.part_id=c.id
		where x.id=#{id} and b.part_id is not null
		group by b.part_id
	SQL

self.find_by_sql(query)
end

def self.latest_parts(id)
	query = <<-SQL
	  select sum(b.quantity * z.quantity) as quantity, b.part_id, c.*, case when c.p_type is null then "" else c.p_type end as type
		from projects x, (select name, max(version) as version from pcbs group by name) table1
		left join pcb_projects z on z.project_id=x.id
		left join pcbs a on a.id=z.pcb_id
		left join part_pcbs b on a.id=b.pcb_id
		left join parts c on b.part_id=c.id
		where x.id=#{id} and b.part_id is not null
		and a.name=table1.name and a.version=table1.version
		group by b.part_id
	SQL

self.find_by_sql(query)
end

def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Project.create! row.to_hash
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

def self.mob_csv(options = {})
	id = options[:id]
	options = {}
	sub_part_names = ['pcb','pcb_ver','part_number','m_full_name', 'part_name', 'p_type','pk_name', 'p_note', 'p_price', 'quantity', 'line_price']
	part_names = ['part_number','m_full_name', 'part_name', 'p_type','pk_name', 'p_note', 'p_price', 'quantity', 'line_price']
	pcb_names = ['name', 'version']
	CSV.generate(options) do |csv|
		csv << sub_part_names
		PartProject.project_parts(id).each do |row|
			csv << row.attributes.values_at(*sub_part_names)
		end
		Project.find(id).pcbs.each do |row|
			csv << row.attributes.values_at(*pcb_names)
			PartPcb.pcb_parts(row.id, id).each do |part|
				csv << part.attributes.values_at(*sub_part_names)
			end
		end
	end
end

private

def compare_dates
  if self.end_date.nil? or (self.start_date <= self.end_date)
    true
  else
    false
  end
end

def validate_end
  errors.add("End date", "cannot be before start date.") unless compare_dates
end

end
