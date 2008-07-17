class InvoicesController < ApplicationController
	before_filter :get_client
	before_filter :get_invoice, :except => [:index, :new, :create]
	
	protected 
		def get_client
			@client = Client.find params[:client_id]
		end

		def get_invoice
		  @invoice = Invoice.find params[:id]
		end

	public
		def index
		  @invoices = @client.invoices
		end

		def show
			respond_to do |format|
				format.html 
				format.pdf do
					send_data InvoiceDrawer.new.draw(@invoice), :filename => 'invoice.pdf', :type => 'application/pdf', :disposition => 'inline'
				end
		  end
		end

		def new
			@invoice = @client.invoices.new params[:invoice]
		end

		def edit
		end

		def create
		  @invoice = @client.invoices.new
		  @invoice.attributes = params[:invoice]

		  if @invoice.save
		    flash[:notice] = 'Invoice was successfully created.'
		    redirect_to client_invoice_path(@client, @invoice)
		  else
		    render :action => "new"
		  end
		end

		def update
		  if @invoice.update_attributes params[:invoice]
		    flash[:notice] = 'Invoice was successfully updated.'
		    redirect_to client_invoice_path(@client, @invoice)
		  else
		    render :action => "edit" 
		  end
		end

		def destroy
		  @invoice.destroy
		  flash[:notice] = 'Invoice was successfully deleted.'

		  redirect_to client_line_items_path(@client)
		end
		
		def assign
			@invoice.line_item_ids = params[:line_items]
			@invoice.save
			
		  redirect_to client_line_items_path(@client)
		end
end
