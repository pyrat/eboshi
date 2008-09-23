require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Todo do
  it "should assign user by name" do
    todo = todos(:todo1)
    todo.user_name = 'Micah'
    todo.user.name.should == 'Micah'
  end
end
