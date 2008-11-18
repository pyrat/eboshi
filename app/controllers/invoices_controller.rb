class InvoicesController < ApplicationController
	before_filter :get_client
	before_filter :get_invoice, :except => [:new, :create]
	
	def show
		respond_to do |format|
			format.html 
			format.pdf do
				send_data InvoiceDrawer.draw(@invoice), :filename => 'invoice.pdf', :type => 'application/pdf', :disposition => 'inline'
			end
	  end
	end

	def new
		@invoice = @client.invoices.new params[:invoice]
	end

	def edit
	end

	def create
	  @invoice = @client.invoices.new params[:invoice]
	  if @invoice.save
	    flash[:notice] = 'Invoice was successfully created.'
	    redirect_to line_items_path(@client)
	  else
	    render :action => "new"
	  end
	end

	def update
	  @invoice.attributes = params[:invoice]
	  if @invoice.save
	    flash[:notice] = 'Invoice was successfully updated.'
	    redirect_to line_items_path(@client)
	  else
	    render :action => "edit" 
	  end
	end

	def destroy
	  @invoice.destroy
	  flash[:notice] = 'Invoice was successfully deleted.'

	  redirect_to line_items_path(@client)
	end
	
	def paid
	  if @invoice.update_attribute :paid, Date.today
	    flash[:notice] = 'Invoice was successfully updated.'
	    redirect_to line_items_path(@client)
	  else
	    render :action => "edit" 
	  end
	end
	
	protected 
		def get_client
			@client = Client.find params[:client_id]
		end

		def get_invoice
		  @invoice = Invoice.find params[:id]
		end

end
