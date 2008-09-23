require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TodosController do
  integrate_views
  
	before(:each) do
		controller.stub!(:authenticate_or_request_with_http_basic).and_return(true)
		controller.stub!(:current_user).and_return(users(:Micah))
		@client = clients(:NANETS)
		@todo = todos(:todo1)
	end

  describe "should not error out" do
    it "on destroy" do
      delete :destroy, :id => @todo.id
    end
    it "on create" do
      post :create, :todo => @todo.attributes, :client_id => @client.id
    end
  end

end
