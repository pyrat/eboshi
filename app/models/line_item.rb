class LineItem < ActiveRecord::Base
	belongs_to :client
	belongs_to :user
	belongs_to :invoice
	
	named_scope :unbilled, :conditions => "invoice_id IS NULL AND start IS NOT NULL", :order => 'start DESC'

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
	
	def user_name=(name)
		unless name.nil?
			user = User.find_by_login(name)
			user_id = user.try(:id)
		end
	end
	
	def invoice_total
	  invoice.try(:total) || client.balance
	end
end
