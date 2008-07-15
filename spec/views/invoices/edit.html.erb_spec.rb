require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invoices/edit.html.erb" do
  include InvoicesHelper
  
  before(:each) do
    assigns[:invoice] = @invoice = Invoice.first
    assigns[:client] = @client = @invoice.client
  end

  it "should render edit form" do
    render "/invoices/edit.html.erb"
    
    response.should have_tag("form[action=#{client_invoice_path(@client, @invoice)}][method=post]") do
    end
  end
end


