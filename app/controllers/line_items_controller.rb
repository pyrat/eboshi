class LineItemsController < ApplicationController
	before_filter :get_client
	before_filter :get_line_item, :only => [:show, :edit, :update, :destroy, :clock_out]

	in_place_edit_for :line_item, :notes
	in_place_edit_for :line_item, :rate
	in_place_edit_for :todo, :notes
	
  def index
    @invoices = @client.invoices_with_unbilled
  end

  def show
  end

  def new
    @line_item = @client.line_items.new
  end

  def edit
  end

  def create
    @line_item = @client.line_items.build params[:line_item]
		
		if @line_item.save
		  flash[:notice] = 'LineItem was successfully created.'
		  redirect_to line_items_path(@client)
		else
		  render :action => "new"
		end
  end

  def update
    if @line_item.update_attributes params[@line_item.class.to_s.underscore]
      flash[:notice] = 'LineItem was successfully updated.'
      redirect_to line_items_path(@client) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @line_item.destroy

		respond_to do |format|
			format.html { redirect_to line_items_path(@client) }
			format.js do
				render :update do |page|
					page.remove "line_item_#{@line_item.id}"
				end
			end
		end
  end
  
  def clock_in
  	@line_item = @client.clock_in current_user
  	
  	render :update do |page|
  		page.insert_html :after, 'new_line_items', :partial => 'line_item'
  	end
  end
  
  def clock_out
  	@line_item.clock_out params[:rate], params[:notes]
  	
  	render :update do |page|
  		page.replace "line_item_#{@line_item.id}", :partial => 'line_item'
  	end
  end
  
	def assign
	  @invoice = Invoice.find params[:invoice_id]
	  @invoice.line_item_ids += params[:invoice][:line_item_ids]
		
    render :update do |page|
      params[:invoice][:line_item_ids].each do |id|
        page.remove "line_item_#{id}"
      end	    
	    page.replace "invoice_#{@invoice.id}", :partial => 'invoice', :object => @invoice
	    page.call 'restripe'
    end
	end
	
  def unassign
    ids = params[:invoice][:line_item_ids]
    LineItem.update_all "invoice_id = NULL", :id => ids
		
    render :update do |page|
	    ids.each do |id|
	      page.remove "line_item_#{id}"
	    end
	    page.replace "invoice_new", :partial => 'invoice', :object => @client.build_invoice_from_unbilled
    end
  end
  
	def merge
	  work = Work.merge_from_ids params[:invoice][:line_item_ids]
	  @invoice = work.invoice || @client.build_invoice_from_unbilled
	  render :update do |page|
	    page.replace "invoice_#{@invoice.id_or_new}", :partial => 'invoice', :object => @invoice
	  end
	end

  def import
  end
  
  def doimport
  	require 'csv'
  	
  	if params[:clear] == 1
    	@client.line_items.destroy_all
    	@client.invoices.destroy_all
    end
  	
  	map = nil
  	CSV::Reader.parse(params[:csv]) do |row|
  		if map.nil?
  			map = row
  			next
  		end
  		li = LineItem.new
  		row.each_with_index do |col, i|
  			next unless map[i]
  			next if map[i] == 'total'
  			if col && ['start', 'finish'].include?(map[i])
  				time = Time.parse(col)
  				eval("li.#{map[i]} = li.created_at")
  				eval("li.#{map[i]} = li.#{map[i]}.change(:hour => time.hour, :min => time.min)")
  			else
	  			eval("li.#{map[i]} = col")
	  		end
	  		li.user_id ||= current_user	 
	  		li.client = @client 		
  		end
  		
  		if li.notes =~ /paid/i
  		  i = @client.invoices.build :date => row[map.index('created_at')], :paid => row[map.index('created_at')], :project_name => @client.name
  		  i.total = row[map.index('total')].to_i * -1
  		  i.save!  		  
  		else
  		  li.type = 'Work'
  			li.finish = li.finish.advance(:days => 1) if li.finish < li.start 
  			li.save!
  		end

		end
		redirect_to line_items_path(@client)
  end
  
  protected
    def get_line_item
      @line_item = LineItem.find params[:id]
    end

  	def get_client
		  @client = Client.find(params[:client_id])
	  end

end
