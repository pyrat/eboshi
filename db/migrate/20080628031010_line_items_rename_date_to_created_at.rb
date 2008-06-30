class LineItemsRenameDateToCreatedAt < ActiveRecord::Migration
  def self.up
  	rename_column :line_items, :date, :created_at
  end

  def self.down
  	rename_column :line_items, :created_at, :date
  end
end
