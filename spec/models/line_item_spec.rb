require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
  it "should be able to set user name manually" do
    @line_item = line_items(:billed1)
    @line_item.user_name = 'Micah'
    @line_item.user.should == users(:Micah)
  end
end
