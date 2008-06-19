class UpgradePaymentsToInvoices < ActiveRecord::Migration
  def self.up
  	add_column :line_items, :invoice_id, :integer
  	rename_table :payments, :invoices
  	rename_column :invoices, :created_at, :date
  	rename_column :invoices, :updated_at, :paid
  	rename_column :line_items, :created_at, :date
  end

  def self.down
  	rename_column :line_items, :date, :created_at
  	rename_column :invoices, :paid, :updated_at
  	rename_column :invoices, :date, :created_at
  	rename_table :invoices, :payments
  	remove_column :line_items, :invoice_id
  end
end
