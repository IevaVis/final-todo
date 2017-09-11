class SessionsController < ApplicationController

	def signin
	end

	def login
		if params[:session][:password] == params[:session][:password_confirmation]
			if @user = User.find_by(email: params[:session][:email])
				if @user.authenticate(params[:session][:password])
					session[:current_user_id] = @user.id
					redirect_to @user
				else
					render 'signin'
				end
			else
				render 'signin'
			end
		else
			render 'signin'
		end	

	end

	def logout
		session.destroy
		redirect_to root_path
	end

end
