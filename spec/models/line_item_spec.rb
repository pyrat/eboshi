require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
	describe "work" do
		describe "billed" do
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
		
			it "should be less than adjustment items" do
				(@line_item < line_items(:adjustment1)).should == true
				(@line_item > line_items(:adjustment1)).should == false
				(@line_item <=> line_items(:adjustment1)).should == -1
			end

			it "should not be checked" do
				@line_item.checked?.should be_false
			end

			it "should report as complete" do
				@line_item.incomplete?.should be_false
			end
		end
		
		describe "unbilled" do
			before do
				@line_item = line_items(:unbilled1)
			end
			it "should be checked" do
				@line_item.checked?.should be_true
			end
		end
		
		describe "incomplete" do
			before do
				@line_item = line_items(:incomplete1)
			end
			it "should report as incomplete" do
				@line_item.incomplete?.should be_true
			end
						
			it "should clock out correctly" do
				@line_item.clock_out(50, 'testing unbilled')
			end

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
		
		it "should not be checked" do
			@line_item.checked?.should be_false
		end

		it "should respond via total" do
			a = Adjustment.new(:total => 50)
			a.total.should == 50
		end
	end
end
