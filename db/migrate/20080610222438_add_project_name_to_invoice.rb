class AddProjectNameToInvoice < ActiveRecord::Migration
  def self.up
  	add_column :invoices, :project_name, :string
  end

  def self.down
  	remove_column :invoices, :project_name
  end
end
