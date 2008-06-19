class Invoice < ActiveRecord::Base
	belongs_to :client
	has_many :line_items
	
	def total
		line_items.to_a.sum(&:total)
	end
	
end
