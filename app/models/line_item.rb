class LineItem < ActiveRecord::Base
	belongs_to :client
	belongs_to :user
	belongs_to :invoice

	validates_presence_of :user_id, :client_id, :start, :finish, :rate
	
	def hours
		(finish - start) / 60 / 60
	end
	
	def total
		hours * rate
	end
	
	def user_name=(name)
		unless name.nil?
			user = User.find_by_login(name)
			user_id = user.try(:id)
		end
	end
end
