require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Client do
  before(:each) do
  	@client = clients(:NANETS)
  	@user = users(:Micah)
  end

  it "should create a new instance given valid attributes" do
    Client.create!(@client.attributes)
  end
	  
  it "should calculate the balance correctly" do
  	@client.balance.should == 100
  end
  
  it "should calculate the credits correctly" do
  	@client.credits.should == 150
  end

  it "should calculate the debits correctly" do
  	@client.debits.should == 50
  end

	it "should provide a todo list" do
		@client.todos.length.should == 2
	end
	
	it "should calculate a default rate given a user" do
		@client.default_rate(@user).should == 50
		Client.new.default_rate(@user).should == 65
	end
	
	it "should return a incomplete work item on clock_in" do
		li = @client.clock_in(@user)
		li.class.should == Work
		li.incomplete?.should be_true
	end
	
	it "should return an unsaved invoice with all unbilled line items" do
	  i = @client.build_invoice_from_unbilled
	  i.new_record?.should be_true
	  i.line_items.should == LineItem.unbilled
	end
end
