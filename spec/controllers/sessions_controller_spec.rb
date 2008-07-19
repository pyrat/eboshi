require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  integrate_views
  
	before(:each) do
		controller.stub!(:authenticate_or_request_with_http_basic).and_return(true)
		controller.stub!(:current_user).and_return(users(:Micah))
		@client = clients(:NANETS)
	end

  describe "should not error out" do
    it "on new" do
    	get :new
		end
		it "on create" do
			User.stub!(:authenticate).and_return(users(:Micah))
			post :create
		end
		it "on destroy" do
			get :destroy
		end
  end

end
