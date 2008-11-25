require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
  it "should be able to set user name manually" do
    @line_item = line_items(:billed1)
    @line_item.user_name = 'Micah'
    @line_item.user.should == users(:Micah)
  end
  
  it "should return invoice total if billed" do
    @invoice = invoices(:invoice)
    @billed = line_items(:billed1)
    @billed.invoice_total.should == @invoice.total
  end
  
  it "should return client balance if unbilled" do
    @unbilled = line_items(:unbilled1)
    @client = clients(:NANETS)
    @unbilled.invoice_total.should == @client.balance
  end
end
