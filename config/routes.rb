ActionController::Routing::Routes.draw do |map|
	map.root :controller => 'clients', :action => 'index'

  map.resources :clients do |client|
	  client.resources :line_items, :collection => [:import, :doimport]
	  client.resources :invoices, :member => [:assign]
	end
	
	map.create_todo '/clients/:client_id/create_todo', :controller => 'line_items', :action => 'create_todo'
	map.clock_in '/clients/:client_id/clock_in', :controller => 'line_items', :action => 'clock_in'
	map.clock_out '/clients/:client_id/line_item/:id/clock_out', :controller => 'line_items', :action => 'clock_out'
  
  map.resources :users
  map.resource :session
	map.signup '/signup', :controller => 'users', :action => 'new'
	map.login '/login', :controller => 'sessions', :action => 'new'
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
