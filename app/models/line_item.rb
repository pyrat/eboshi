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
	
	def user_name=(name)
		unless name.nil?
			user = User.find_by_login(name)
			user_id = user.try(:id)
		end
	end

	def == (target)
		target == id
	end
	
	def checked?
		invoice_id.nil?
	end

end

class Todo < LineItem
	validates_presence_of :notes

	def <=> (target)
		-1
	end
	def < (target)
		true
	end
	def > (target)
		false
	end
	
	def checked?
		false
	end


end

class Work < LineItem
	validates_presence_of :user_id, :rate, :start, :finish
	
	def total
		(hours * rate).round(2)
	end
	
	def clock_out(notes)
		update_attributes(:finish => Time.now, :notes => notes)
	end
	
	def <=> target
		result = (target <=> self.start)
		target.is_a?(Work) ? result : result*-1
	end
	def < (target)
		result = (target > self.start)
		target.is_a?(Work) ? !result : result
	end
	def > (target)
		result = (target < self.start)
		target.is_a?(Work) ? !result : result
	end
end

class Adjustment < LineItem
	validates_presence_of :rate
	
	def total
		self.rate
	end
	
	def total=(value)
		self.rate = value
	end
	
	def <=> (target)
		1
	end
	def < (target)
		false
	end
	def > (target)
		true
	end

end
