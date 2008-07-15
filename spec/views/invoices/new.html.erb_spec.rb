require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invoices/new.html.erb" do
  include InvoicesHelper
  
  before(:each) do
    assigns[:invoice] = stub_model(Invoice,
      :new_record? => true
    )
    assigns[:client] = @client = Client.first
  end

  it "should render new form" do
    render "/invoices/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", client_invoices_path(@client)) do
    end
  end
end


