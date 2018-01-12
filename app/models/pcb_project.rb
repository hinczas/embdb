class PcbProject < ActiveRecord::Base
	belongs_to :pcb
	belongs_to :project
	
	
	def upd_qte(idd, val)
		qte = val.first
		pcb = PcbProject.find(idd)
		pcb.update_column(:quantity, "#{qte}")
		pcb.save!
	end
	
	def self.project_pcb_parts(id)
		query = <<-SQL
		  SELECT a.quantity*x.quantity as quantity, b.*, c.pk_name, d.m_full_name, a.quantity*x.quantity*b.p_price as line_price
		  FROM pcb_projects x
		  join part_pcbs a on x.pcb_id=a.pcb_id
		  join parts b on a.part_id=b.id
		  left join packages c on b.package_id=c.id
		  left join manufacturers d on b.manufacturer_id=d.id
		  WHERE x.project_id=#{id}
		SQL

		self.find_by_sql(query)
	end
end
