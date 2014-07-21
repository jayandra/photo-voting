class ContestsController < ApplicationController
	# GET    /contests(.:format)
	def index
		@current_round = Contest::get_round(cookies[:key])#http_lib_object.current_round
	end

 	# POST  /contests/update_contest(.:format)
	def update_contest
		api_response = Contest::post_round(cookies[:key], params)
		if(api_response["status"] == "FAIL")
			if(api_response["code"] == 400)
				flash[:alert] = "You missed some pair of images for this round"
			elsif(api_response["code"] == 403)
				flash[:alert] = "Please select good images between each pairs"
			end
		end

		redirect_to contests_path
	end

	# GET    /contests/reset_contest(.:format)
	def reset_contest
		Contest::reset_contest(cookies[:key], params)

		redirect_to contests_path
	end
end
