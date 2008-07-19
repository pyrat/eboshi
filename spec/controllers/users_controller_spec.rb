require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

	before(:each) do
		controller.stub!(:authenticate_or_request_with_http_basic).and_return(true)
		controller.stub!(:current_user).and_return(users(:Micah))
		@user = users(:Micah)
	end

  describe "should not error out" do
    it "on index" do
      get :index
    end
    it "on edit" do
      get :edit, :id => @user.id
    end
    it "on new" do
      get :new
    end
    it "on update" do
      put :update, :id => @user.id, :user => @user.attributes
    end
    it "on create" do
      post :create, :user => @user.attributes
    end
  end

end
