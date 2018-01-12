class ChangeFileTypeToDate < ActiveRecord::Migration
  def change
	change_column :movies, :last_seen, :date
  end
end
