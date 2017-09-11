class AdminController < ApplicationController
	before_action :require_login

	def show
		@admin = User.find(params[:id])
		if current_user.id != @admin.id
			redirect_to root_path
		end
	end

	def show_users
		@admin = User.find(params[:id])
		if current_user.id == @admin.id
			@users = User.all
		else
			redirect_to root_path
		end
	end

	def inspect_user
		@admin = User.find(params[:admin_id])
		if current_user.id == @admin.id
			@user = User.find(params[:user_id])
		else
			redirect_to root_path
		end
	end

	def delete_todo
		@admin = User.find(params[:admin_id])
		if current_user.id == @admin.id
			@todo = Todo.find(params[:todo_id])
			@user = User.find(@todo.user_id)
			@todo.destroy
			redirect_to inspect_user_path(admin_id: @admin.id, user_id: @user.id)
		else
			redirect_to root_path
		end
	end

	def remove_user
		@admin = User.find(params[:admin_id])
		if current_user.id == @admin.id
			@user = User.find(params[:user_id])
			@user.destroy
			redirect_to show_users_path(id: @admin.id)
		else
			redirect_to root_path
		end
	end

	def assign_admin
		@admin = User.find(params[:admin_id])
		if current_user.id == @admin.id
			@user = User.find(params[:user_id])
			@user.position = 1
			@user.save
			redirect_to show_users_path(id: @admin.id)
		else
			redirect_to root_path
		end
	end
end
