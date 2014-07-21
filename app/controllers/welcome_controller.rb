class WelcomeController < ApplicationController
	# GET    /welcome(.:format)
	def index
	end

	# POST   /welcome/set_key(.:format)
	def set_key
		cookies[:key] = params[:key] == "" ? (ENV['MPC_KEY'] || APPCONSTANTS::MPC_KEY) : params[:key]

		redirect_to contests_url
	end

end