class AddPriceToParts < ActiveRecord::Migration
  def change
    add_column :parts, :p_price, :float
  end
end
