class ClientsController < ApplicationController
  def index
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])

    if @client.save
      flash[:notice] = 'Client was successfully created.'
      redirect_to clients_path
    else
      render :action => "new"
    end
  end

  def update
    @client = Client.find(params[:id])

    if @client.update_attributes(params[:client])
      flash[:notice] = 'Client was successfully updated.'
      redirect_to clients_path
    else
      render :action => "edit" 
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    redirect_to clients_path
  end
end
