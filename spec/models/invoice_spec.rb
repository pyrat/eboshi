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
end
