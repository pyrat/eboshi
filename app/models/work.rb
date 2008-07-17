class Work < LineItem
	validates_presence_of :user_id, :rate, :start, :finish
	
	def total
		(hours * rate).round(2)
	end
	
	def clock_out(rate, notes)
		update_attributes(:finish => Time.now, :notes => notes, :rate => rate)
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
	def incomplete?
		start == finish
	end
end
