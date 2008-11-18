require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvoicesController do
	integrate_views
	
	before(:each) do
		controller.stub!(:authenticate_or_request_with_http_basic).and_return(true)
		controller.stub!(:current_user).and_return(users(:Micah))
		@client = clients(:NANETS)
		@invoice = invoices(:invoice)
	end

  describe "should not error out" do
    it "on index" do
      get :index, :client_id => @client.id
    end
    it "on show" do
      get :show, :client_id => @client.id, :id => @invoice.id
    end
    it "on pdf formatted show" do
      get :show, :client_id => @client.id, :id => @invoice.id, :format => 'pdf'
    end
    it "on edit" do
      get :edit, :client_id => @client.id, :id => @invoice.id
    end
    it "on new" do
      get :new, :client_id => @client.id
    end
    it "on update" do
      put :update, :client_id => @client.id, :id => @invoice.id, :invoice => @invoice.attributes
    end
    it "on destroy" do
      delete :destroy, :client_id => @client.id, :id => @invoice.id
    end
    it "on create" do
      post :create, :client_id => @client.id, :invoice => @invoice.attributes
    end
    it "on paid" do
      post :paid, :client_id => @client.id, :id => @invoice.id
    end
  	
  end
end
