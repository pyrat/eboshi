class InvoicesController < ApplicationController
	before_filter :get_client
	
	def get_client
		@client = Client.find(params[:client_id])
	end
	
  # GET /invoices
  def index
    @invoices = @client.invoices.find(:all)
  end

  # GET /invoices/1
  def show
    @invoice = Invoice.find(params[:id])
		respond_to do |format|
			format.html 
			format.pdf do
				send_data InvoiceDrawer.new.draw(@invoice), :filename => 'invoice.pdf', :type => 'application/pdf', :disposition => 'inline'
			end
    end
  end

  # GET /invoices/new
  def new
    @invoice = @client.invoices.new
    @line_items = @client.line_items.find(:all, :conditions => ["id IN (?)", params[:line_items]])
    @invoice.total = @line_items.sum { |li| li.total }
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  def create
    @invoice = @client.invoices.new(params[:invoice])
    for line_item in params[:line_items]
    	@invoice.line_items << LineItem.find(line_item)
    end

    if @invoice.save
      flash[:notice] = 'Invoice was successfully created.'
      redirect_to [@client, @invoice]
    else
      render :action => "new"
    end
  end

  # PUT /invoices/1
  def update
    @invoice = Invoice.find(params[:id])

    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = 'Invoice was successfully updated.'
      redirect_to(@invoice) 
    else
      render :action => "edit" 
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    redirect_to(invoices_url) 
  end
  
  def assign
  	@invoice = Invoice.find(params[:id])
  	@invoice.line_item_ids = params[:line_items]
  	@invoice.save
  	
    redirect_to(client_line_items_path(@client))  	
  end
end
