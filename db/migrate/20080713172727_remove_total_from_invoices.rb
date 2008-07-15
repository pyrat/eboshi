class RemoveTotalFromInvoices < ActiveRecord::Migration
  def self.up
  	Invoice.all.each do |invoice|
  		total = invoice.line_items.to_a.sum(&:total)
  		next if total == invoice.total
  		adjustment = total - invoice.total
  		invoice.line_items << LineItem.new(
  			:client => invoice.client,
  			:type => 'Adjustment',
  			:rate => adjustment,
  			:notes => 'adjustment'
  		)
  	end
  	remove_column :invoices, :total
  end

  def self.down
  	add_column :invoices, :total, :integer
  end
end
