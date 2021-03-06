class Client < ActiveRecord::Base
	has_many :line_items
	has_many :todos
	has_many :works
	has_many :adjustments
	has_many :invoices
	
	validates_presence_of :name

	def build_invoice_from_unbilled
  	invoices.build :line_items => line_items.unbilled
	end

	def invoices_with_unbilled
    [build_invoice_from_unbilled] + invoices.all(:order => 'date DESC')
	end
	
	def balance
		credits - debits
	end
	
	def credits
		line_items.to_a.sum(&:total)
	end
	
	def debits
		invoices.to_a.sum(&:total)
	end
	
	def todo
		line_items.find :all, :conditions => { :type => 'Todo' }, :order => 'created_at DESC'
	end
	
	def clock_in(user)
	  returning line_item = Work.new do
	    now = Time.now
	    line_item.attributes = { :start => now, :finish => now, :user => user, :rate => default_rate(user) }
    	self.line_items << line_item
  	end
	end
	
	def default_rate(user)
	  # look for last rate for this client / agent combo. fallback to default user rate.
		line_items.find(:first, :conditions => ["type='Work' AND start <> finish AND user_id=? AND rate IS NOT NULL", user.id], :order => "start DESC").try(:rate) || user.rate
	end
end
