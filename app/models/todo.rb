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
