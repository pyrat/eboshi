class InvoicesController < ApplicationController
	before_filter :get_invoice, :except => [:index, :new, :create]
	before_filter :get_client
	
	def index
	  respond_to do |format|
	    format.html
	    format.js { render :partial => 'invoice', :collection => @client.invoices.paid }
	  end
	end
	
	def show
		respond_to do |format|
			format.html 
			format.pdf do
				send_data InvoiceDrawer.draw(@invoice),
				  :filename => "bot-and-rose_invoice-#{@invoice.id}.pdf",
				  :type => 'application/pdf',
				  :disposition => 'inline'
			end
	  end
	end

	def new
		@invoice = @client.build_invoice_from_unbilled 
	end

	def edit
	  respond_to do |format|
	    format.html
	    format.js { render :partial => 'full', :locals => { :invoice => @invoice } } 
	  end
	end

	def create
	  @invoice = @client.invoices.new params[:invoice]
	  if @invoice.save
	    flash[:notice] = 'Invoice was successfully created.'
	    redirect_to invoices_path(@client)
	  else
	    render :action => "new"
	  end
	end

	def update
	  @invoice.attributes = params[:invoice]
	  if @invoice.save
	    flash[:notice] = 'Invoice was successfully updated.'
	    redirect_to invoices_path(@client)
	  else
	    render :action => "edit" 
	  end
	end

	def destroy
	  @invoice.destroy
	  flash[:notice] = 'Invoice was successfully deleted.'

	  redirect_to invoices_path(@client)
	end
	
	def paid
	  if @invoice.update_attribute :paid, Date.today
	    flash[:notice] = 'Invoice was successfully updated.'
	    redirect_to invoices_path(@client)
	  else
	    render :action => "edit" 
	  end
	end
	
	protected 
		def get_client
			@client = @invoice.try(:client) || Client.find(params[:client_id])
		end

		def get_invoice
		  @invoice = Invoice.find params[:id]
		end

end
