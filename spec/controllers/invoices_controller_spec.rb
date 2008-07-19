require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvoicesController do
	integrate_views
	
	before(:each) do
		controller.stub!(:authenticate_or_request_with_http_basic).and_return(true)
		controller.stub!(:current_user).and_return(users(:Micah))
	end
  
  describe "responding to GET" do

		before do
			@invoice = Invoice.first
			@client = @invoice.client
		end

  	describe "index" do

		  it "should expose all client invoices as @invoices" do
		    get :index, :client_id => @client
		    assigns[:invoices].should == @client.invoices
		  end

		end

		describe "show" do

		  it "should expose the requested invoice as @invoice" do
		    get :show, :client_id => @client, :id => @invoice
		    assigns[:invoice].should == @invoice
		  end
		  		  
		end

		describe "new" do
		
		  it "should expose a new invoice as @invoice" do
		    get :new, :client_id => @client
		    assigns[:invoice].class.should == Invoice
		  end
		  
		end

		describe "edit" do
		
		  it "should expose the requested invoice as @invoice" do
		    get :edit, :client_id => @client, :id => @invoice
		    assigns[:invoice].should == @invoice
		  end

		end
		
	end

  describe "responding to POST create" do

    describe "with valid params" do
      
			before do
      	@invoice = Invoice.first
      	@client = @invoice.client
      	@invoice.id = nil
      	@invoice.date = '1000-01-01'
      	@invoice.paid = '1000-01-01'
      	@invoice.project_name = 'test'

      	invoice_params = @invoice.attributes
      	invoice_params[:line_items] = LineItem.all
        post :create, :client_id => @client, :invoice => invoice_params
			end
			
      it "should expose an @invoice" do
        assigns(:invoice).class.should == Invoice
      end
      
      it "should save the record" do
      	assigns(:invoice).new_record?.should == false
      end

			it "should assign line items from params" do
				assigns(:invoice).line_items.length.should > 0
			end
			
      it "should redirect to the created invoice" do
        response.should redirect_to(client_invoice_path(@client, assigns(:invoice)))
      end
      
    end
    
    describe "with invalid params" do

			before do
      	@invoice = Invoice.first
      	@invoice.id = nil
      	@invoice.date = '1000-01-01'
      	@invoice.project_name = nil?
      	@client = @invoice.client
        post :create, :client_id => @client, :invoice => @invoice.attributes
			end

      it "should expose an @invoice" do
        assigns(:invoice).should == @invoice
      end
      
      it "should not save the record" do
      	Invoice.find_by_date('1000-01-01').should == nil
      end

      it "should re-render the 'new' template" do
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    describe "with valid params" do

			before do
      	@invoice = Invoice.first
      	@client = @invoice.client
        put :update, :client_id => @client, :id => @invoice, :invoice => @invoice.attributes
			end

      it "should update the requested invoice" do
      	@invoice.project_name = 'test'
        put :update, :client_id => @client, :id => @invoice, :invoice => @invoice.attributes
        Invoice.first.project_name.should == 'test'
      end
			
      it "should expose the requested invoice as @invoice" do
        assigns(:invoice).should == @invoice
      end

      it "should redirect to the invoice" do
        response.should redirect_to(client_invoice_path(@client, @invoice))
      end

    end
    
    describe "with invalid params" do
			before(:each) do
				@invoice = Invoice.first
				@invoice.project_name = nil
        put :update, :id => @invoice, :client_id => @invoice.client, :invoice => @invoice.attributes
			end

      it "should not update the requested invoice" do
      	Invoice.first.project_name.should_not == nil
      end

      it "should expose the invoice as @invoice" do
        assigns(:invoice).should == @invoice
      end

      it "should re-render the 'edit' template" do
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
  	before(:each) do
  		@invoice = Invoice.first
      delete :destroy, :id => @invoice, :client_id => @invoice.client
  	end

    it "should destroy the requested invoice" do
			lambda { Invoice.find(@invoice.id) }.should raise_error(ActiveRecord::RecordNotFound)
    end
  
    it "should redirect to the invoices list" do
      response.should redirect_to(client_line_items_path(@invoice.client))
    end

  end

end
