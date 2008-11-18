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
  
  it "should default date and paid to nil" do
  	@invoice = Invoice.new
  	@invoice.date.should == Time.today
  	@invoice.paid.should == nil
  end
  
  it "should create an adjustment item when a total is assigned that doesnt equal the sum of the line items" do
  	@invoice = Invoice.first
  	count = @invoice.adjustments.length
  	@invoice.total += 50
  	@invoice.adjustments.length.should == count+1
  	@invoice.adjustments.last.total.should == 50
  end
  
  it "should handle the total attribute through mass assignment" do
    @invoice = Invoice.first
    total = @invoice.total
    @invoice.attributes = { :total => total-50 }
    @invoice.save
    @invoice = Invoice.first
    @invoice.total.should == total-50
  end

  it "should not create an adjustment item when a total is assigned that equals the sum of the line items" do
  	@invoice = Invoice.first
  	count = @invoice.adjustments.length
  	@invoice.total = @invoice.total
  	@invoice.adjustments.length.should == count
  end
  
  it "should handle the paid boolean through mass assignment" do
    @invoice = Invoice.new "paid(1i)" => "2008", "paid(2i)" => "10", "paid(3i)" => "1", "paid" => "0"
    @invoice.paid.should be_nil

    @invoice = Invoice.new 
    @invoice.attributes = { "paid(1i)" => "2008", "paid(2i)" => "10", "paid(3i)" => "1", "paid" => "1" }
    @invoice.paid.to_s(:slash).should == "10/01/08"
  end
end
