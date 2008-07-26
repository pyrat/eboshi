class LineItemsController < ApplicationController
	before_filter :get_client
	in_place_edit_for :line_item, :notes
	
	def get_client
		@client = Client.find(params[:client_id])
	end
	
  # GET /line_items
  def index
    @invoices = @client.invoices.find(:all, :order => 'date DESC')
    invoice = Invoice.new
    invoice.line_items = @client.line_items.find(:all, :conditions => "invoice_id IS NULL AND start IS NOT NULL", :order => 'start DESC')
    @invoices.unshift invoice
  end

  # GET /line_items/1
  def show
    @line_item = LineItem.find(params[:id])
  end

  # GET /line_items/new
  def new
    @line_item = @client.line_items.new
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  def create
    @line_item = @client.line_items.new(params[:line_item])
		
		if @line_item.save
		  flash[:notice] = 'LineItem was successfully created.'
		  redirect_to client_line_items_path(@client)
		else
		  render :action => "new"
		end
  end

  # PUT /line_items/1
  def update
    @line_item = LineItem.find(params[:id])
    if @line_item.update_attributes(params[:line_item])
      flash[:notice] = 'LineItem was successfully updated.'
      redirect_to client_line_items_path(@client) 
    else
      render :action => "edit" 
    end
  end

  # DELETE /line_items/1
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

		respond_to do |format|
			format.html { redirect_to client_line_items_path(@client) }
			format.js do
				render :update do |page|
					page.remove "line_item_#{@line_item.id}"
				end
			end
		end
  end
  
  def clock_in
  	@line_item = @client.clock_in(current_user)
  	
  	render :update do |page|
  		page.insert_html :after, 'new_line_items', :partial => 'line_item'
  	end
  end
  
  def clock_out
  	@line_item = LineItem.find(params[:id])
  	@line_item.clock_out(params[:rate], params[:notes])
  	
  	render :update do |page|
  		page.replace "line_item_#{@line_item.id}", :partial => 'line_item'
  	end
  end
  
  def create_todo
    @line_item = Todo.new(params[:line_item])
    @client.line_items << @line_item
		
		render :update do |page|
			page.insert_html :after, 'new_todos', :partial => 'line_item'
		end
  end
  
	def assign
	  @invoice = Invoice.find params[:invoice_id]
	  @invoice.line_item_ids = (@invoice.line_item_ids + params[:invoice][:line_item_ids]).uniq
		@invoice.save!
		
    render :update do |page|
      params[:invoice][:line_item_ids].each do |id|
        page.remove "line_item_#{id}"
      end	    
	    page.replace "invoice_#{@invoice.id}", :partial => 'invoice', :object => @invoice
	    page.call 'restripe'
    end
	end

  def unassign
	  params[:invoice][:line_item_ids].each do |id|
	    li = LineItem.find(id)
	    li.invoice = nil
	    li.save
	  end
		
    render :update do |page|
	    page.remove params[:invoice][:line_item_ids].collect {|id| "line_item_#{id}"}
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
  		
  		if li.notes == "PAID"
	  		#Payment.create :client_id => @client.id, :total => row[map.index('total')].to_i * -1, :date => row[map.index('created_at')], :paid => row[map.index('created_at')]
  		else
  		  li.type = 'Work'
  			li.finish = li.finish.advance(:days => 1) if li.finish < li.start 
  			li.save!
  		end

		end
		redirect_to client_line_items_path(@client)
  end
end
