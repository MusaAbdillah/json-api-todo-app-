module V1
	class TodosController < ApplicationController
		before_action :set_todo, only: [:show, :update, :destroy]

		# get /todos 
		def index 
			@todos = current_user.todos
			json_response(@todos)
		end

		# create todo
		def create 
			@todo = current_user.todos.create!(todo_params)
			json_response(@todo, :created)
		end
		
		# get /todo
		def show 
			json_response(@todo)
		end

		# update todo
		def update 
			@todo.update(todo_params)
			head :no_content
		end

		# delete todo
		def destroy 
			@todo.destroy
			head :no_content
		end

		private 
			def set_todo
				@todo = Todo.find(params[:id])
			end

			def todo_params 
				params.permit(:title)
			end
	end
end