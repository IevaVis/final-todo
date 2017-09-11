class UsersController < ApplicationController
	before_action :require_login, only: [:show, :edit, :update]

	def new
		@user = User.new
	end

	def create
		@user = User.new(create_user_params)
		if @user.save
			if user_picture
				assign_user_picture
			end
			redirect_to sign_in_path
		else
			render "new"
		end
	end

	def show
		@user = User.find(params[:id])
		if params[:filter] == "true"
			@todos = Todo.where(user_id: params[:id], status: true)
		elsif params[:filter] == "false"
			@todos = Todo.where(user_id: params[:id], status: false)
		else
			@todos = Todo.where(user_id: params[:id])
		end
		@todos = @todos.order(:status, :description)
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.id == current_user.id
			if @user.update(edit_user_params)
				if user_picture
					assign_user_picture
				end
				redirect_to @user
			else
				render 'edit'
			end
		else
			redirect_to root_path
		end
	end

	private
	def create_user_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

	def edit_user_params
		params.require(:user).permit(:first_name, :last_name)
	end

	def user_picture
		params[:user][:avatar]
	end

	def assign_user_picture
		@user.avatar = user_picture
		@user.save!
	end
end
