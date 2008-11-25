require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Work do
  describe "when merging a list of ids" do
    it "should gracefully handle a single id" do
      work = Work.merge_from_ids [line_items(:billed1).id]
      work.reload
      work.should == line_items(:billed1)
    end
    it "should correctly merge multiple items" do
      work = Work.merge_from_ids [line_items(:billed1).id, line_items(:billed2).id]
      work.reload
      work.invoice.should == invoices(:invoice)
      work.hours.should == 2
      work.total.should == 100
      work.notes.should include(line_items(:billed1).notes)
      work.notes.should include(line_items(:billed2).notes)
      lambda { Work.find(line_items(:billed1).id) }.should raise_error(ActiveRecord::RecordNotFound)
      lambda { Work.find(line_items(:billed2).id) }.should_not raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
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
		
		it "should be able to set hours manually" do
		  @line_item.hours = 4
		  @line_item.hours.should == 4
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
			@line_item.clock_out
		end
	end

end
