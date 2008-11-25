require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItemsController do
  integrate_views
  
	before(:each) do
		controller.stub!(:authenticate_or_request_with_http_basic).and_return(true)
		controller.stub!(:current_user).and_return(users(:Micah))
		@client = clients(:NANETS)
		@line_item = @client.works.first
	end

  describe "should not error out" do
    it "on edit" do
      get :edit, :client_id => @client.id, :id => @line_item.id
    end
    it "on new" do
      get :new, :client_id => @client.id
    end
    it "on update" do
      put :update, :client_id => @client.id, :id => @line_item.id, :line_item => @line_item.attributes
    end
    it "on destroy" do
      delete :destroy, :client_id => @client.id, :id => @line_item.id
    end
    it "on create" do
      post :create, :client_id => @client.id, :client => @client.attributes
    end

    it "on clock_in" do
      get :clock_in, :client_id => @client.id
    end
		it "on clock_out" do
			@line_item = line_items(:incomplete1)
			get :clock_out, :client_id => @client.id, :id => @line_item.id
		end
  	
  end
end
