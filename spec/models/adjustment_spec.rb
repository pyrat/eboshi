require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Adjustment do
	before(:each) do
		@line_item = line_items(:adjustment1)
	end

	it "should calculate the hours correctly" do
		@line_item.hours.should == 0
	end

	it "should calculate the total correctly" do
		@line_item.total.should == -25
	end

	it "should be greater than all other line items" do
		(@line_item > line_items(:billed1)).should == true
		(@line_item < line_items(:billed1)).should == false
		(@line_item == line_items(:adjustment1)).should == true
		(@line_item == line_items(:billed1)).should == false
		(@line_item <=> line_items(:billed1)).should == 1
	end
	
	it "should not be checked" do
		@line_item.checked?.should be_false
	end

	it "should respond via total" do
		a = Adjustment.new(:total => 50)
		a.total.should == 50
	end
end
