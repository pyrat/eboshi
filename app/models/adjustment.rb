class Adjustment < LineItem
  include Comparable
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
end
