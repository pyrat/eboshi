class Invoice < ActiveRecord::Base
	belongs_to :client
	has_many :line_items, :dependent => :destroy
	has_many :todos
	has_many :works
	has_many :adjustments
	
	validates_presence_of :client, :date, :paid, :project_name
	
	def initialize(options = {})
		options = {} if options.nil?
		options.reverse_merge!(:date => Date.today, :paid => Date.today)
		super
	end

	def total
		line_items.to_a.sum(&:total)
	end
	
	def total=(value)
		difference = value.to_f - total
		return total if difference == 0
		adjustments << Adjustment.new(:client => client, :total => difference)
	end
	
end
