class Work < LineItem
	validates_presence_of :user_id, :rate, :start, :finish
	
	def self.merge_from_ids(ids)
	  works = Work.find ids, :order => "finish DESC"
	  work = works.first
	  unless works.empty?
	    work.hours = works.sum(&:hours)
	    work.notes = works.collect(&:notes) * ' '
	    works.shift
	    works.each(&:destroy)
	    work.save!
	  end
	  return work
	end
	
	def total
		(hours * rate).round(2)
	end
	
	def hours=(total)
	  update_attribute :finish, start + total.hours
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
