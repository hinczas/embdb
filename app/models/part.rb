class Part < ActiveRecord::Base
require 'csv'
require 'rails/all'
  validates :part_number, presence: true, allow_blank: false, :uniqueness => {:case_sensitive => false}
  validates :part_name, presence: true, allow_blank: false
  validates :p_note, presence: true, allow_blank: false
  validates :p_description, presence: true, allow_blank: false
  validates :p_price, presence: true, allow_blank: false
  validates :p_quantity, presence: true, allow_blank: false
  belongs_to :package
  belongs_to :location
  belongs_to :manufacturer
  belongs_to :type
  # has_and_belongs_to_many :pcbs
  has_many :part_pcbs
  has_many :pcbs, through: :part_pcbs
  has_many :part_projects
  has_many :projects, through: :part_projects
  accepts_nested_attributes_for :part_pcbs,
           :reject_if => :all_blank,
           :allow_destroy => true
  
  def sum_price
	Part.sum(p_price)
  end
  
  def qte_price
	p_price*PartPcb.where(part_id: :id).take.quantity
  end
  
  def part_list
	 part_name.ljust(10, padstr=' ')+" - "+if self.package; self.package.pk_name.ljust(10, padstr=' '); else ""; end+",  Qty: #{p_quantity}"
  end
  
  def part_list2
	part_name[0,10].ljust(10, padstr=' ')+" - "+if self.package; self.package.pk_name[0,10].ljust(10, padstr=' '); else ""; end+",  Qty: #{p_quantity}"
  end
  
  def pcb_parts
	 part_name[0,10].ljust(10, padstr=' ')+" - "+if self.package; self.package.pk_name[0,10].ljust(10, padstr=' '); else ""; end
  end
  
  def self.owned
	where("p_quantity > 0")
  end
  def self.search(search)
	where("keywords LIKE :search OR part_number LIKE :search OR part_name LIKE :search OR p_description LIKE :search OR p_note LIKE :search OR p_type LIKE :search",search: "%#{search}%")
  end
  def self.search3(search)
		query = <<-SQL
		  SELECT a.*
		  FROM parts a
		  left join types b on a.type_id=b.id
		  left join locations c on a.location_id=c.id
		  left join manufacturers d on d.id=a.manufacturer_id
		  left join packages e on a.package_id = e.id
		  WHERE b.name LIKE '%#{search}%'
		  or c.l_name LIKE '%#{search}%'
		  or d.m_full_name LIKE '%#{search}%'
		  or d.m_name LIKE '%#{search}%'
		  or e.pk_name LIKE '%#{search}%'
		  or a.keywords LIKE '%#{search}%'
		  OR a.part_number LIKE '%#{search}%' 
		  OR a.part_name LIKE '%#{search}%' 
		  OR a.p_description LIKE '%#{search}%' 
		  OR a.p_note LIKE '%#{search}%' 
		  OR a.p_type LIKE '%#{search}%'
		SQL

		self.find_by_sql(query)
	end
	
  def self.search2(search)
		query = <<-SQL
		  SELECT a.*
		  FROM parts a
		  left join types b on a.type_id=b.id
		  WHERE b.name LIKE '%#{search}%'
		SQL

		self.find_by_sql(query)
	end
  def self.searchid(search)
	where("id = :search",search: "#{search}")
  end
  def self.search_number(search)
	where("part_number = :search",search: "#{search}")
  end
  def self.searchm(id)
	if id
		where("manufacturer_id = :id ",id: "#{id}")
	else
		where("manufacturer_id IS NULL")
	end		
  end
  def self.searchl(id)
	if id
	where("location_id = :id ",id: "#{id}")
	else
	where("location_id IS NULL")
	end
  end
  def self.searchp(id)
	where("package_id = :id ",id: "#{id}")
  end
  def self.searcht(id)
	where("type_id = :id ",id: "#{id}")
  end
  def self.searchemptyl
	where("location_id IS NULL")
  end
  def self.searchemptym
	where("manufacturer_id IS NULL")
  end
  def self.searchemptyp
	where("package_id IS NULL")
  end
  def self.searchemptyt
	where("type_id IS NULL")
  end
  def self.import(file)	
	CSV.foreach(file.path, headers: true) do |row|
		Part.create! row.to_hash
	end
	end
	
  def self.to_buy
		query = <<-SQL
		  SELECT distinct b.*
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE  (a.quantity>b.p_quantity or b.p_quantity is null or b.p_quantity=0)
		SQL

	self.find_by_sql(query)
  end
  
    def self.to_buy_all
		query = <<-SQL
		  select a.*, b.used_qte - a.quantity as used, round(a.p_price*(b.used_qte - a.quantity),2) as cost
			from (select *, case when p_quantity is null then 0 else p_quantity end as quantity from parts) a
			join (select part_id, sum(quantity) as used_qte from part_pcbs
			group by part_id) b
			on a.id=b.part_id
			where used >0
		SQL

	self.find_by_sql(query)
  end
  
  def self.no_buy(pid)
		query = <<-SQL
		  SELECT sum(a.quantity)-max(CASE WHEN b.p_quantity is NULL then 0 else b.p_quantity END) as buy_qte
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE  b.id=#{pid} and (a.quantity>b.p_quantity or b.p_quantity is null)
		SQL

	self.find_by_sql(query)
	end
 
   def self.projects(id)
		query = <<-SQL
		    select distinct x.*
			from projects x
			left join pcb_projects z on z.project_id=x.id
			left join pcbs a on a.id=z.pcb_id
			left join part_pcbs b on a.id=b.pcb_id
			left join parts c on b.part_id=c.id
			where c.id=#{id}
		SQL

	self.find_by_sql(query)
	end
  
	def self.to_csv(options = {})
		headers= ['part_number','part_name','p_type','p_description','voltage','current','p_note', 'buy_qte', 'buy_cost']
		cols= ['part_number','part_name','p_type','p_description','voltage','current','p_note', 'used', 'cost']
		CSV.generate(options) do |csv|
		  csv << headers
		  to_buy_all.each do |part|
			csv << part.attributes.values_at(*cols)
		  end
		end
	  end
	  
  	def self.all_csv(options = {})
		CSV.generate(options) do |csv|
		  csv << column_names
		  self.all.each do |part|
			csv << part.attributes.values_at(*column_names)
		  end
		end
	  end
	  
    def self.parts_used_no
		query = <<-SQL
		  SELECT sum(a.quantity)-max(CASE WHEN b.p_quantity is NULL then 0 else b.p_quantity END) as buy_qte
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE (a.quantity>b.p_quantity or b.p_quantity is null)
		  group by a.part_id
		SQL

	self.find_by_sql(query)
	end
	
end
