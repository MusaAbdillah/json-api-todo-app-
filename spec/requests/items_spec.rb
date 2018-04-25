require 'rails_helper'

RSpec.describe "Items API" do
	let(:user) { create(:user) } 
	let(:another_user) { create(:user)}
	# initialize the test data 
	let!(:todo) { create(:todo, created_by: user.id)}
	let!(:items) { create_list(:item, 20, todo_id: todo.id)}
	let(:todo_id) { todo.id }
	let(:id) { items.first.id }
	# initalize the the data for another user 
	let!(:another_todo) { create(:todo, created_by: another_user.id)}
	let!(:another_items) { create_list(:item, 20, todo_id: another_todo.id)}
	let(:another_todo_id) { another_todo.id }
	let(:another_id) { another_items.first.id }
	# headers 
	let(:headers) { valid_headers }

	# test for /todos/:todo_id/items 
	describe "GET /todos/:todo_id/items" do
		before { get "/todos/#{todo_id}/items", params: {}, headers: headers }

		context "when todo exist" do 
			
			it "returns status code 200" do
				expect(response).to have_http_status(200) 
			end  

			it "returns all todo items" do
				expect(json.size).to eq(20) 
			end

		end

		context "when todo exist but user not authorized for todo" do
			let(:todo_id){ another_todo_id }

			it "return status code 401" do 
				expect(response).to have_http_status(401)
			end 
		end

		context "when todo not exist" do
			let(:todo_id) { 0 }

			it "returns status code 404" do 
				expect(response).to have_http_status(404)
			end 

			it "returns a not found message" do 
				expect(response.body).to match(/Couldn't find Todo/)
			end
		end
	end
	# test for get /todos/:todo_id/items/:id 
	describe "GET /todos/:todo_id/items/:id" do
		before { get "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }

		context "when item exist" do

			it "returns status code 200" do 
				expect(response).to have_http_status(200)
			end 

			it "returns the item" do
				expect(json).not_to be_empty
				expect(json['id']).to eq(id) 
			end
		end

		context "when item not exist" do
			let(:id) { 0 }
			
			it "returns status code 404" do 
				expect(response).to have_http_status(404)
			end 

			it "returns a not found message" do
				expect(response.body).to match(/Couldn't find Item/) 
			end
		end

		context "when todo_id not valid with current token" do 
			let(:todo_id) { another_todo_id }

			it "retunrs status code 401" do 
				expect(response).to have_http_status(401)
			end
		end 
	end

	# test for POST /todos/:todo_id/items
	describe "POST /todos/:todo_id/items" do
		let(:valid_attributes) { { name: "Visit Narnia", done: false }.to_json }

		context "when request attributes are valid" do 
			before { post "/todos/#{todo_id}/items", params: valid_attributes, headers: headers }
			
			it "returns status code 201" do 
				expect(response).to have_http_status(201)
			end 
		end

		context "when request attributes are not valid" do
			before { post "/todos/#{todo_id}/items", params: {}, headers: headers }

			it "returns status code 422" do
				expect(response).to have_http_status(422) 
			end 

			it "returns a failur message" do
				expect(response.body).to match(/Validation failed: Name can't be blank/) 
			end
		end

		context "when request attributes are valid but todo aren't valid" do 
			let(:todo_id){ another_todo_id }
			before { post "/todos/#{todo_id}/items", params: valid_attributes, headers: headers }

			
			it "returns status code 401" do 
				expect(response).to have_http_status(401)
			end
		end
	end

	# test for PUT /todos/:todo_id/items/:id
	describe "PUT /todos/:todo_item/items/:id" do 
		let(:valid_attributes) { { name: 'Mozart' }.to_json}

		before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes, headers: headers }

		context "when items exist" do
			it "returns status code 204" do 
				expect(response).to have_http_status(204)
			end 

			it "Updates the item" do
				update_item = Item.find(id)
				expect(update_item.name).to match(/Mozart/) 
			end
		end

		context "when items doesn't exist" do
			let(:id) { 0 }

			it "returns status code 404" do 
				expect(response).to have_http_status(404)
			end 

			it "returns a not found message" do
				expect(response.body).to match(/Couldn't find Item/) 
			end
		end

		context "when items exist but todo not valid" do 
			let(:todo_id){ another_todo_id }

			it "returns status code 401" do 
				expect(response).to have_http_status(401)
			end
		end

	end

	# test for DELETE /todos/:todo_id/items/:id
	describe "DELETE /todos/:todo_id/items/:id" do
		before { delete "/todos/#{todo_id}/items/#{id}", params: {}, headers: headers }
		context "when @todo.items valid" do 
			it "returns status code 204" do
				expect(response).to have_http_status(204)
			end 
		end

		context "when @todo.items not valid" do
			let(:todo_id) { another_todo_id }
			it "returns status code 401" do 
				expect(response).to have_http_status(401)
			end 
		end
	end
end