require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Invoice do
  before(:each) do
    @valid_attributes = {
    	:date => '2008-01-01',
    	:paid => '2008-02-01',
    	:project_name => 'NANETS website',
    	:client => Client.find(:first)
    }
  end

  it "should create a new instance given valid attributes" do
    Invoice.create!(@valid_attributes)
  end
  
  it "should default date and paid to today" do
  	@invoice = Invoice.new
  	@invoice.date.should == Time.today
  	@invoice.paid.should == Time.today
  end
  
  it "should create an adjustment item when a total is assigned that doesnt equal the sum of the line items" do
  	@invoice = Invoice.first
  	count = @invoice.adjustments.length
  	@invoice.total += 50
  	@invoice.adjustments.length.should == count+1
  	@invoice.adjustments.last.total.should == 50
  end

  it "should not create an adjustment item when a total is assigned that equals the sum of the line items" do
  	@invoice = Invoice.first
  	count = @invoice.adjustments.length
  	@invoice.total = @invoice.total
  	@invoice.adjustments.length.should == count
  end
end
