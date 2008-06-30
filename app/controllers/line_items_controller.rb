class LineItemsController < ApplicationController
	before_filter :get_client
	
	def get_client
		@client = Client.find(params[:client_id])
	end
	
  # GET /line_items
  def index
    @invoices = @client.invoices.find(:all, :order => 'date DESC')
    invoice = Invoice.new
    invoice.line_items = @client.line_items.find(:all, :conditions => "invoice_id IS NULL AND start IS NOT NULL", :order => 'start DESC')
    @invoices.unshift invoice
		@clock_in = LineItem.new(:user => current_user, :start => Time.now, :finish => Time.now, :rate => current_user.rate)
		@clock_out = LineItem.find(:first)
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

    redirect_to(client_line_items_url) 
  end
  
  def import
  end
  
  def doimport
  	require 'csv'
  	
  	@client.line_items.destroy_all
  	@client.payments.destroy_all
  	
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
	  		Payment.create :client_id => @client.id, :total => row[map.index('total')].to_i * -1, :date => row[map.index('created_at')], :paid => row[map.index('created_at')]
  		else
  			li.finish = li.finish.advance(:days => 1) if li.finish < li.start 
  			li.save!
  		end

		end
		redirect_to client_line_items_path(@client)
  end
end
