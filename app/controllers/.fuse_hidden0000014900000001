class ApplicationController < ActionController::API
	include Response
	include ExceptionHandler 

	# called before every action on controllers 
	before_action :authorize_request 
	attr_reader :current_user

	def correct_todo 
		if @todo.created_by.to_i != current_user.id 
			head :unauthorized 
		else
			@todo
		end
	end
	
	private 
		def authorize_request 
			@current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
		end
end
