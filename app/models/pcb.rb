class Pcb < ActiveRecord::Base
belongs_to :parent, :class_name => 'Pcb'
has_many :children, :class_name => 'Pcb', :foreign_key => :parent_id
  validates :version,  presence: true, allow_blank: false, length: { is: 2 }, format: { with: /[0-9][A-Z]/, message: "only allows digit + letter" }
  has_many :part_pcbs, dependent: :destroy
  has_many :parts, through: :part_pcbs
  has_many :pcb_projects
  has_many :projects, through: :pcb_projects
  accepts_nested_attributes_for :part_pcbs,
           :allow_destroy => true
validate :validate_end




def pcb_list
	"#{name} - #{version}"
end
def name_full
	"#{name}_#{version}"
end
def pcb_list2
	(name+"_"+version).ljust(10, padstr=' ')+" - "+ start_date.to_s.strip.rjust(11, padstr='0')
end
def self.search(search)
	where("name LIKE :search OR version LIKE :search OR notes LIKE :search",search: "%#{search}%")
end

def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Pcb.create! row.to_hash
	end
end
def self.lookup(pcb_name, id)
	where("name LIKE :search and id!=:idd",search: "%#{pcb_name}%", idd: "#{id}")
end

def pcb_cost
	self.part_pcbs.pcb_price(self.id).first.pcb_cost
end

def self.max_version(pcb_name, id, curr)
	query = <<-SQL
	  select id from pcbs a where version in (select max(version) 
	  from pcbs where name like '#{pcb_name}%' and id!="#{id}" and version <"#{curr}") and name like '#{pcb_name}%'  and id!="#{id}"
	SQL

self.find_by_sql(query)
end

def self.all_cost
	query = <<-SQL
	  select a.*, sum(b.quantity* case when c.p_price is null then 0 else c.p_price end) as pcb_cost
		from pcbs a
		left join part_pcbs b on a.id=b.pcb_id
		left join parts c on b.part_id=c.id
		group by a.id
	SQL

self.find_by_sql(query)
end

def self.latest(nam)
		Pcb.where(name: nam).maximum("version")
end

def self.all_csv(options = {})
cols= ['name', 'version', 'start_date', 'end_date', 'photo', 'notes', 'pcb_cost', 'changelog', 'sch_file', 'brd_file', 'parent_id']
	CSV.generate(options) do |csv|
	  csv << cols
	  self.all_cost.each do |row|
		csv << row.attributes.values_at(*cols)
	  end
	end
  end
  
  def self.mob_csv(options = {})
	id = options[:id]
	options = {}
	sub_part_names = ['pcb','pcb_ver','part_number','m_full_name', 'part_name', 'p_type','pk_name', 'p_note', 'p_price', 'quantity', 'line_price']
	pcb_names = ['name', 'version']
	CSV.generate(options) do |csv|
		csv << sub_part_names
		csv << Pcb.find(id).attributes.values_at(*pcb_names)
		PartPcb.backup_pcb_parts(id).each do |part|
			csv << part.attributes.values_at(*sub_part_names)
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
