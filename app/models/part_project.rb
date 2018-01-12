class PartProject < ActiveRecord::Base
	belongs_to :part
	belongs_to :project
	
	def num_parts
		PartProject.sum(:quantity)
	end
	def upd_qte(idd, val)
		qte = val.first
		part = PartProject.find(idd)
		part.update_column(:quantity, "#{qte}")
		part.save!
	end
	def self.pcb_price(id)
		query = <<-SQL
		  SELECT ROUND(SUM(a.quantity*b.p_price),2) as pcb_cost
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE a.pcb_id=#{id}
		SQL

		self.find_by_sql(query)
	end
	def self.parts_count(id)
		query = <<-SQL
		  SELECT SUM(a.quantity) as parts_count
		  FROM part_projects a
		  WHERE a.project_id=#{id}
		SQL

		self.find_by_sql(query)
	end
	def self.parts_owned(id)
		query = <<-SQL
		  SELECT SUM(CASE WHEN b.p_quantity > a.quantity then a.quantity ELSE b.p_quantity END) as parts_owned
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE a.pcb_id=#{id}
		  AND b.p_quantity>0
		SQL

		self.find_by_sql(query)
	end
	def self.parts_buy(id)
		query = <<-SQL
		  SELECT SUM(a.quantity-(CASE WHEN b.p_quantity is NULL then 0 else b.p_quantity END)) as parts_buy
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE a.pcb_id=#{id} and  (a.quantity>b.p_quantity or b.p_quantity is null)
		SQL

		self.find_by_sql(query)
	end
	
	def self.project_parts(id)
		query = <<-SQL
		  SELECT a.quantity, b.*, c.pk_name, d.m_full_name, a.quantity*b.p_price as line_price
		  FROM part_projects a
		  join parts b on a.part_id=b.id
		  left join packages c on b.package_id=c.id
		  left join manufacturers d on b.manufacturer_id=d.id
		  WHERE a.project_id=#{id}
		SQL

		self.find_by_sql(query)
	end
	def used_qte(id)
		PartProject.where(part_id: id).sum(:quantity)
	end
	
end
