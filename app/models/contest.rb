class Contest < ActiveRecord::Base
	# Finds details of current round or the last one if contest is completed
	def self.get_round(api_key)
		http_lib_object = MPC::ImageLibrary.new(api_key)
		begin
			current_round = http_lib_object.current_round
		rescue
			current_round = http_lib_object.round(5)
		end

		return current_round
	end

	# Posts the selected images to MPC, and if the contest is complted finalizes it
	def self.post_round(api_key, params)
		http_lib_object = MPC::ImageLibrary.new(api_key)
		data = Array.new
		current_round = http_lib_object.current_round
		round = current_round["round"]
		
		current_round["images"].each do |image|
			data << image if params[:chosen].try(:values).try(:include?, image["flickr_id"])
		end

		api_response = JSON.parse( http_lib_object.post_round(round, data) )
		if(current_round["count"] == 2)
			http_lib_object.post_finalize
		end

		return api_response
	end

	# Resets the contest by passing the users provided tags (if any)
	def self.reset_contest(api_key, params)
		http_lib_object = MPC::ImageLibrary.new(api_key)
		http_lib_object.post_reset(params[:tags])
	end

end
