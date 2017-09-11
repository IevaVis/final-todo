class WelcomeController < ApplicationController
	def index
		if session[:current_user_id]
			redirect_to current_user
		end
	end
end
