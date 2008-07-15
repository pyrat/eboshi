require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvoicesController do

  describe "route generation" do

    it "should map { :controller => 'invoices', :action => 'index', :client_id => '1' } to /clients/1/invoices" do
      route_for(:controller => "invoices", :action => "index", :client_id => '1').should == "/clients/1/invoices"
    end
  
    it "should map { :controller => 'invoices', :action => 'new', :client_id => '1' } to /clients/1/invoices/new" do
      route_for(:controller => "invoices", :action => "new", :client_id => '1').should == "/clients/1/invoices/new"
    end
  
    it "should map { :controller => 'invoices', :action => 'show', :id => 2, :client_id => '1' } to /clients/1/invoices/2" do
      route_for(:controller => "invoices", :action => "show", :client_id => '1', :id => 2).should == "/clients/1/invoices/2"
    end
  
    it "should map { :controller => 'invoices', :action => 'edit', :id => 2, :client_id => '1' } to /clients/1/invoices/2/edit" do
      route_for(:controller => "invoices", :action => "edit", :client_id => '1', :id => 2).should == "/clients/1/invoices/2/edit"
    end
  
    it "should map { :controller => 'invoices', :action => 'update', :id => 2, :client_id => '1' } to /clients/1/invoices/2" do
      route_for(:controller => "invoices", :action => "update", :client_id => '1', :id => 2).should == "/clients/1/invoices/2"
    end
  
    it "should map { :controller => 'invoices', :action => 'destroy', :id => 2, :client_id => '1' } to /clients/1/invoices/2" do
      route_for(:controller => "invoices", :action => "destroy", :client_id => '1', :id => 2).should == "/clients/1/invoices/2"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'invoices', action => 'index' } from GET /clients/1/invoices" do
      params_from(:get, "/clients/1/invoices").should == {:controller => "invoices", :action => "index", :client_id => '1'}
    end
  
    it "should generate params { :controller => 'invoices', action => 'new' } from GET /clients/1/invoices/new" do
      params_from(:get, "/clients/1/invoices/new").should == {:controller => "invoices", :action => "new", :client_id => '1'}
    end
  
    it "should generate params { :controller => 'invoices', action => 'create' } from POST /clients/1/invoices" do
      params_from(:post, "/clients/1/invoices").should == {:controller => "invoices", :action => "create", :client_id => '1'}
    end
  
    it "should generate params { :controller => 'invoices', action => 'show', id => '2' } from GET /clients/1/invoices/1" do
      params_from(:get, "/clients/1/invoices/2").should == {:controller => "invoices", :action => "show", :id => "2", :client_id => '1'}
    end
  
    it "should generate params { :controller => 'invoices', action => 'edit', id => '2' } from GET /clients/1/invoices/2/edit" do
      params_from(:get, "/clients/1/invoices/2/edit").should == {:controller => "invoices", :action => "edit", :id => "2", :client_id => '1'}
    end
  
    it "should generate params { :controller => 'invoices', action => 'update', id => '2' } from PUT /clients/1/invoices/2" do
      params_from(:put, "/clients/1/invoices/2").should == {:controller => "invoices", :action => "update", :id => "2", :client_id => '1'}
    end
  
    it "should generate params { :controller => 'invoices', action => 'destroy', id => '2', :client_id => '1' } from DELETE /clients/1/invoices/2" do
      params_from(:delete, "/clients/1/invoices/2").should == {:controller => "invoices", :action => "destroy", :id => "2", :client_id => '1'}
    end
  end
end
