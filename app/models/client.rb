class Client < ActiveRecord::Base
	has_many :line_items
	has_many :invoices
	
	validates_presence_of :name
	
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
	  now = Time.now
  	line_item = LineItem::Work.create(
  		:start => now,
  		:finish => now,
  		:user => user,
  		:rate => user.rate
  	)
  	line_items << line_item
  	line_item
	end
end
