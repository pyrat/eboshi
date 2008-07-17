class AddTypeToLineItems < ActiveRecord::Migration
  def self.up
  	add_column :line_items, :type, :string
  	LineItem.update_all "type = 'Work'"
  end

  def self.down
  	remove_column :line_items, :type
  end
end
