class AddTypeRefToParts < ActiveRecord::Migration
  def change
    add_reference :parts, :type, index: true, foreign_key: true
  end
end
