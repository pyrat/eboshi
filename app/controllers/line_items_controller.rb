class LineItemsController < ApplicationController
	before_filter :get_line_item, :only => [:show, :edit, :update, :destroy, :clock_out]
	before_filter :get_client

	in_place_edit_for :line_item, :notes
	in_place_edit_for :line_item, :rate
	in_place_edit_for :todo, :notes
	
  def new
    @line_item = @client.line_items.new
  end

  def edit
  end

  def create
    @line_item = @client.line_items.build params[:line_item]
		
		if @line_item.save
		  flash[:notice] = 'LineItem was successfully created.'
		  redirect_to invoices_path(@client)
		else
		  render :action => "new"
		end
  end

  def update
    if @line_item.update_attributes params[@line_item.class.to_s.underscore]
      flash[:notice] = 'LineItem was successfully updated.'
      redirect_to invoices_path(@client) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @line_item.destroy

		respond_to do |format|
			format.html { redirect_to invoices_path(@client) }
			format.js { render :json => @line_item.invoice_total }
		end
  end
  
  def clock_in
  	@line_item = @client.clock_in current_user
  	
		respond_to do |format|
			format.html { render :action => 'new' }
			format.js { render :partial => 'line_item', :object => @line_item }
		end
  end
  
  def clock_out
  	@line_item.clock_out
  	
  	respond_to do |format|
  	  format.html { redirect_to invoices_path(@client) }
  	  format.js do
  	    render :json => {
    	    :line_item => render_to_string(:partial => 'line_item', :object => @line_item),
          :total => @line_item.invoice_total
        }
      end
  	end
  end
  
  def merge
    work = Work.merge_from_ids params[:line_item_ids]
    @invoice = work.invoice || @client.build_invoice_from_unbilled
    respond_to do |format|
      format.html { redirect_to invoices_path(@client) }
      format.js { render :partial => 'line_item', :locals => { :line_item => work } }
    end
  end

  protected
    def get_line_item
      @line_item = LineItem.find params[:id]
    end

  	def get_client
		  @client = @line_item.try(:client) || Client.find(params[:client_id])
	  end

end
