ActionController::Routing::Routes.draw do |map|
	map.root :controller => 'clients', :action => 'index'

  map.resources :clients do |client|
	  client.resources :line_items, :collection => [:import, :doimport]
	  client.resources :invoices, :member => [:assign]
	end
  
  map.resources :users
  map.resource :session
	map.signup '/signup', :controller => 'users', :action => 'new'
	map.login '/login', :controller => 'sessions', :action => 'new'
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
