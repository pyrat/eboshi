class Invoice < ActiveRecord::Base
	belongs_to :client
	has_many :line_items, :dependent => :destroy
	has_many :todos
	has_many :works
	has_many :adjustments
	
	named_scope :unpaid, :conditions => "paid = '0000-00-00 00:00:00' OR paid IS NULL"
	named_scope :paid, :conditions => "paid > 0"
	
	validates_presence_of :client, :date, :project_name

	def initialize(options = {})
		options = {} if options.nil?
		options.reverse_merge!(:date => Date.today)
		super
	end

	def total
		line_items.to_a.sum(&:total)
	end
	
	def total=(value)
		difference = value.to_f - total
		return total if difference.abs < 0.01
		adjustments << Adjustment.new(:client => client, :total => difference)
	end

  def attributes=(attrs)
    # check for nulling checkbox
    attrs.delete_if { |k,v| k =~ /^paid\([1-3]i\)$/ } if attrs['paid'] == "0"
    super(attrs)
  end
  
  def status
    return 'unbilled' if new_record?
    return paid ? 'paid' : 'unpaid'
  end
  
  def number
    client.invoices.count(:conditions => ['date < ?', date]) + 1
  end
end
