require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
	describe "todo" do
		before(:each) do
			@line_item = line_items(:todo1)
		end
	
		it "should calculate the hours correctly" do
			@line_item.hours.should == 0
		end
	
		it "should calculate the total correctly" do
			@line_item.total.should == 0
		end
		
		it "should be less than all other line items" do
			(@line_item < line_items(:billed1)).should == true
			(@line_item > line_items(:billed1)).should == false
			(@line_item == line_items(:todo1)).should == true
			(@line_item == line_items(:billed1)).should == false
			(@line_item <=> line_items(:billed1)).should == -1
		end
	end

	describe "work" do
		before(:each) do
			@line_item = line_items(:billed1)
		end
	
		it "should calculate the hours correctly" do
			@line_item.hours.should == 1
		end
	
		it "should calculate the total correctly" do
			@line_item.total.should == 50
		end

		it "should be compared to other line items by start time descending" do
			(line_items(:billed1) > line_items(:billed2)).should == true
			(line_items(:billed1) < line_items(:billed2)).should == false
			(line_items(:billed1) <=> line_items(:billed2)).should == 1
		end
		
		it "should be greater than todo items" do
			(@line_item > line_items(:todo1)).should == true
			(@line_item < line_items(:todo1)).should == false
			(@line_item <=> line_items(:todo1)).should == 1
		end

		it "should be less than adjustment items" do
			(@line_item < line_items(:adjustment1)).should == true
			(@line_item > line_items(:adjustment1)).should == false
			(@line_item <=> line_items(:adjustment1)).should == -1
		end

	end

	describe "adjustment" do
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
	end
end
