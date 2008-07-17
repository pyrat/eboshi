class SchemaWideChangeRateToDecimal < ActiveRecord::Migration
  def self.up
  	change_column :line_items, :rate, :decimal, :precision => 10, :scale => 2
  	change_column :users, :rate, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  	change_column :line_items, :rate, :integer
  	change_column :users, :rate, :integer
  end
end
