require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Client do
  before(:each) do
  	@client = clients(:NANETS)
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
		@client.todo.length.should == 2
	end
  # balance credits debits todo
end
