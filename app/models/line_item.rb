class LineItem < ActiveRecord::Base
	belongs_to :client
	belongs_to :user
	belongs_to :invoice
	
	named_scope :unbilled, :conditions => "invoice_id IS NULL"

	validates_presence_of :client_id
	
	def total
		0
	end

	def hours
		return 0 unless finish and start
		(finish - start) / 60 / 60
	end
	
	def == (target)
		target == id
	end
	
	def checked?
		invoice_id.nil?
	end
end
