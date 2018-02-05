class ShoppingList < ActiveRecord::Base
require 'csv'
require 'rails/all'

def self.all_parts
	query = <<-SQL
	  select item_id, sum(item_quantity) as item_quantity
	  from shopping_lists where item_type='part'
	  group by item_id
	SQL

self.find_by_sql(query)
end

def self.cur_qte(id)
	query = <<-SQL
	  select sum(item_quantity) as item_quantity
	  from shopping_lists where item_type='part'
	  and item_id=#{id}
	SQL

self.find_by_sql(query)
end

def self.search(search)	
	query = <<-SQL
	  select a.item_id, sum(a.item_quantity) as item_quantity
	  from shopping_lists a
	  join parts b on a.item_id=b.id
	  where a.item_type='part' and (keywords LIKE '%#{search}%' OR part_number LIKE '%#{search}%' OR part_name LIKE '%#{search}%' OR p_description LIKE '%#{search}%' OR p_type LIKE '%#{search}%')
	  group by a.item_id
	SQL

self.find_by_sql(query)
end
  
def self.all_csv
	query = <<-SQL
	  select i.item_id, p.part_name, p.part_number, p.p_price, p.p_note, m.m_name, m.m_full_name, pk.pk_name, p.p_quantity, p.p_type, sum(i.item_quantity) as item_quantity, sum(p.p_price*i.item_quantity) as buy_cost
	  from shopping_lists i
	  join parts p on i.item_id=p.id
	  left join packages pk on pk.id=p.package_id
	  left join manufacturers m on m.id=p.manufacturer_id
	  where item_type='part'
	  group by i.item_id, p.part_name, p.part_number, p.p_price, p.p_note, m.m_name, m.m_full_name, pk.pk_name, p.p_quantity, p.p_type
	SQL

self.find_by_sql(query)
end



def self.export_csv(options = {})
	headers= ['part_number','m_full_name','part_name','p_type','p_note','p_price','item_quantity','buy_cost']
	CSV.generate(options) do |csv|
	  csv << headers
	  all_csv.each do |list|
		csv << list.attributes.values_at(*headers)
	  end
	end
  end
	  
end
