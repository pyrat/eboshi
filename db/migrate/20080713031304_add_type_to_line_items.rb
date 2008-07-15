class AddTypeToLineItems < ActiveRecord::Migration
  def self.up
  	add_column :line_items, :type, :string
  	LineItem.update_all "type = 'Work'", "invoice_id IS NOT NULL"
  	LineItem.update_all "type = 'ToDo'", "invoice_id IS NULL"
  end

  def self.down
  	remove_column :line_items, :type
  end
end
