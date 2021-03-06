require 'rails_helper'
RSpec.describe "todos API", type: :request do 
	# add todos owner 
	let(:user){ create(:user) }
	let(:another_user){ create(:user)}
	# initialize data
	let!(:todos) { create_list(:todo, 10, created_by: user.id )}
	let(:todo_id) { todos.first.id }
	# initialize data another user 
	let!(:another_todos) { create_list(:todo, 10, created_by: another_user.id )}
	let(:another_todo_id) { another_todos.first.id }
	# authorize request 
	let(:headers) { valid_headers }

	# test for 'GET /todos'
	describe 'GET /todos' do 
		before { get '/todos', params: {}, headers: headers}

		it "returns todos" do
			# json is custome helper 
			expect(json).not_to be_empty
			expect(json.size).to eq(10) 
		end

		it "retursns status code 200" do
			expect(response).to have_http_status(200) 
		end
	end

	# test for 'GET /todos/id'
	describe "GET /todos/:id" do
		before { get "/todos/#{todo_id}", params: {}, headers: headers}

		context "when the record exist" do 
			
			it "returns the todo" do
				expect(json).not_to be_empty
				expect(json['id']).to eq(todo_id) 
			end

			it "returns status code 200" do
				expect(response).to have_http_status(200) 
			end
		end

		context "when the todo exist but not valid user" do 
			let(:todo_id){ another_todo_id }
			it "returns status code" do 
				expect(response).to have_http_status(401)
			end
		end

		context "when the record not exist" do
			let(:todo_id) { 100 }

			it "returns status code 404" do 
				expect(response).to have_http_status(404)
			end

			it "returns a not found messange" do
				expect(response.body).to match(/Couldn't find Todo/) 
			end 
		end 
	end

	# test for 'POST /todos'
	describe "POST /todos" do
		# valid payload
		let(:valid_attributes) do
			{ title: "Learn Elm", created_by: user.id.to_s }.to_json
		end

		context "when the request is valid" do
			before { post '/todos', params: valid_attributes, headers: headers }

			it "create todo" do
				expect(json['title']).to eq("Learn Elm") 
			end 

			it "returns status code 201" do 
				expect(response).to have_http_status(201)
			end
		end

		context "when the request in invalid" do
			let(:invalid_attributes){ { title: nil}.to_json }
			before { post '/todos', params: invalid_attributes, headers: headers}

			it "returns status code 422" do
				expect(response).to have_http_status(422) 
			end 

			it "returns a validation failur message" do
				expect(json["message"]).to match(/Validation failed: Title can't be blank/) 
			end
		end 
	end

	# test for 'PUT /todos/:id'
	describe "PUT /todos/:id" do
		let(:valid_attributes) { {title: 'Shopping', created_by: user.id.to_s}.to_json}

		context "when the record exist" do
			before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers}

			it "updates the record" do 
				expect(response.body).to be_empty
			end

			it "returns status code 204" do 
				expect(response).to have_http_status(204)
			end 
		end

		context "when the record exist but not valid user" do 
			let(:todo_id) { another_todo_id }

			before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers}

			it "returns status code 401" do
				expect(response).to have_http_status(401) 
			end

		end


	end

	# test for DELETE '/todos/:id'
	describe "DELETE /todos/:id" do
		before { delete "/todos/#{todo_id}", params: {}, headers: headers}

		context "when request valid and user also valid" do 
			it "returns status code 204" do
				expect(response).to have_http_status(204) 
			end 
		end

		context "when request valid but user not valid" do 
			let(:todo_id){ another_todo_id }
			
			it "returns status code 401" do 
				expect(response).to have_http_status(401)
			end
		end
	end

end