class LineItemsRenameEndToFinish < ActiveRecord::Migration
  def self.up
  	rename_column :line_items, :end, :finish
  end

  def self.down
  	rename_column :line_items, :finish, :end
  end
end
