Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  post "auth/login", to: "authentications#authenticate"
  post "/signup", to: "users#create"

 	#non default version have to be definied above the default version  
	scope module: :v2, constraints: ApiVersion.new("v2") do 
		resources :todos, only: :index 
	end

	scope module: :v1, constraints: ApiVersion.new("v1", true) do 
		resources :todos do 
			resources :items 
		end
	end

end
