module RequestSpecHelper
	# parse json resonse to ruby hash
	def json 
		JSON.parse(response.body)
	end
end