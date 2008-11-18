# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  self.allow_forgery_protection = false
	
	include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '777e12608199867e6528eb1a3556d20d'
  
  before_filter :authenticate, :get_clients
  
  protected

		def authenticate
			authenticate_or_request_with_http_basic('Bot and Rose Invoice Application') do |username, password|
				current_user = User.authenticate(username, password)
			end
		end
		
		def get_clients
      @clients = Client.all :order => 'name'
		end
end
