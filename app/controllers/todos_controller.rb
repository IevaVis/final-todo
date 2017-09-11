class TodosController < ApplicationController
	before_action :require_login

	def new
		@todo = Todo.new
		unless current_user.position == "admin" || current_user.paid == true || current_user.todos.count < 5
			redirect_to current_user
		end
	end

	def create
		if current_user.todos.count < 5 || current_user.paid == true || current_user.position == "admin"
			@todo = current_user.todos.new(description: params[:todo][:description])
			if @todo.save
				if todo_pictures
					assign_todo_pictures
				end
				redirect_to current_user
			else
				render 'new'
			end
		else
			redirect_to current_user
		end
	end

	def edit
		@todo = Todo.find(params[:id])
	end

	def update
		@todo = Todo.find(params[:id])
		if @todo.user_id == current_user.id
			if @todo.update(description: params[:todo][:description])
				if todo_pictures
					assign_todo_pictures
				end
				redirect_to current_user
			else
				render 'edit'
			end
		else
			redirect_to root_path
		end
	end

	def destroy
		@todo = Todo.find(params[:id])
		if @todo.user_id == current_user.id
			@todo.destroy
			redirect_to current_user
		else
			redirect_to root_path
		end
	end

	def toggle
		@todo = Todo.find(params[:id])
		if @todo.user_id == current_user.id
			if @todo.status == true
				@todo.uncheck
			else
				@todo.check
			end
		end
		render json: @todo
	end

	private
	def todo_pictures
		params[:todo][:avatars]
	end

	def assign_todo_pictures
		@todo.avatars = todo_pictures
		@todo.save!
	end	
end
