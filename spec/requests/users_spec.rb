require 'rails_helper'
RSpec.describe "User API", type: :request do 
	let(:user) { build(:user) }
	let(:headers) { valid_headers.except("Authorization") }
	let(:valid_attributes) do 
		attributes_for(:user, password_confirmation: user.password)
	end

	# user signup test 
	describe "POST /signup" do
		context "when valid request" do 
			before { post "/signup", params: valid_attributes.to_json, headers: headers}
			
			it "create a new user" do
				expect(response).to have_http_status(201) 
			end

			it "returns success message" do 
				expect(json['message']).to match(/Account created successfully/)
			end

			it "returns an authentication token" do 
				expect(json["auth_token"]).not_to be_nil
			end
		end

		context "when invalid request" do 
			before { post "/signup", params: {}, headers: headers }

			it "doesn't create a new user" do 
				expect(response).to have_http_status(422)
			end

			it "return failure message" do 
				expect(json["message"])
					.to match(/Validation failed: Name can't be blank, Email can't be blank, Password digest can't be blank/)
			end
		end

	end
end