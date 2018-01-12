class PartPcb < ActiveRecord::Base
	belongs_to :part
	belongs_to :pcb
	
	def num_parts
		PartPcb.sum(:quantity)
	end
	def upd_qte(idd, val)
		qte = val.first
		part = PartPcb.find(idd)
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
		  FROM part_pcbs a
		  join parts b on a.part_id=b.id
		  WHERE a.pcb_id=#{id}
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
	
	def self.pcb_parts(id, pid) 
		query = <<-SQL
		  SELECT a.quantity*x.quantity as quantity, b.*, c.pk_name, d.m_full_name, (a.quantity*x.quantity*b.p_price) as line_price
		  FROM part_pcbs a
		  left join parts b on a.part_id=b.id
		  left join packages c on b.package_id=c.id
		  left join manufacturers d on b.manufacturer_id=d.id
		  left join pcb_projects x on a.pcb_id=x.pcb_id
		  WHERE a.pcb_id=#{id}
		  and x.project_id=#{pid}
		SQL

		self.find_by_sql(query)
	end
	
	def self.backup_pcb_parts(id) 
		query = <<-SQL
		  SELECT a.quantity, b.*, c.pk_name, d.m_full_name, (a.quantity*b.p_price) as line_price
		  FROM part_pcbs a
		  left join parts b on a.part_id=b.id
		  left join packages c on b.package_id=c.id
		  left join manufacturers d on b.manufacturer_id=d.id
		  WHERE a.pcb_id=#{id}
		SQL

		self.find_by_sql(query)
	end
	
	def used_qte(id)
		PartPcb.where(part_id: id).sum(:quantity)
	end
	
end
