class ApplicationController < ActionController::Base
  include UsersHelper

	def require_login
		unless session[:current_user_id]
			render "welcome/index"
		end
	end
end
