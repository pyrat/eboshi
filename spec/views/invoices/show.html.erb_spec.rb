require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invoices/show.html.erb" do
  include InvoicesHelper
  
  before(:each) do
    assigns[:invoice] = @invoice = Invoice.first
    assigns[:client] = @client = @invoice.client
  end

  it "should render attributes in <p>" do
    render "/invoices/show.html.erb"
  end
end
