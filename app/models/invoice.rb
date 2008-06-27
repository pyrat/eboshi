class Invoice < ActiveRecord::Base
	belongs_to :client
	has_many :line_items
	
	validates_presence_of :client, :date, :paid, :project_name
	
	def total
		line_items.to_a.sum(&:total)
	end
	
end
