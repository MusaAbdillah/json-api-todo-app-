require 'rails_helper'

RSpec.describe "Authentications", type: :request do 
	# Authentications test suite 
	describe "POST /auth/login" do 
		# create user 
		let!(:user) { create(:user) }
		# set headers for authorizations
		let(:headers) { valid_headers.except("Authorizations")}
		# set test valid and invalid credentials 
		let(:valid_credentials) do 
			{
				email: user.email, 
				password: user.password
			}.to_json
		end

		let(:invalid_credentials) do 
			{
				email: Faker::Internet.email, 
				password: Faker::Internet.password
			}.to_json
		end

		# set request.headers to our custome headers 
		# before { allow(request).to receive(:headers).and_return(headers) }
	
		# return auth token when request is valid 
		context "When request is valid" do
			before { post "/auth/login", params: valid_credentials, headers: headers} 
			it "returns an authentications token" do
				expect(json['auth_token']).not_to be_nil
			end
		end

		# return failure message when request is invalid 
		context "when request is invalid" do
			before { post "/auth/login", params: invalid_credentials, headers: headers}
			it "retursn an failure message" do
				expect(json['message']).to match(/Invalid credentials/) 
			end 
		end
	end
end