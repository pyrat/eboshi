class TodosController < ApplicationController
  # POST /todos
  def create
    @todo = Todo.new(params[:todo])
    @todo.user = current_user
		@client = Client.find(params[:client_id])
    @client.todos << @todo

		render :update do |page|
			page.insert_html :after, 'new_todos', :partial => '/line_items/todo'
		end
  end

  # DELETE /todos/1
  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    render :update do |page|
	    page.remove "todo_#{params[:id]}"
    end
  end
end
