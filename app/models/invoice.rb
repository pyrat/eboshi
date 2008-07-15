class Invoice < ActiveRecord::Base
	belongs_to :client
	has_many :line_items
	
	validates_presence_of :client, :date, :paid, :project_name
	
	def initialize(options = {})
		options.reverse_merge!(:date => Date.today, :paid => Date.today)
		super options
	end

	def total
		line_items.to_a.sum(&:total)
	end
	
end
