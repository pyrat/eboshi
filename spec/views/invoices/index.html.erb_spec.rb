require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/invoices/index.html.erb" do
  include InvoicesHelper
  
  before(:each) do
  	assigns[:client] = Client.first
    assigns[:invoices] = [
      stub_model(Invoice),
      stub_model(Invoice)
    ]
  end

  it "should render list of invoices" do
    render "/invoices/index.html.erb"
  end
end

