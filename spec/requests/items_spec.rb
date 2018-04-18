require 'rails_helper'

RSpec.describe "Items API" do 
	# initialize the test data 
	let!(:todo) { create(:todo)}
	let!(:items) { create_list(:item, 20, todo_id: todo.id)}
	let(:todo_id) { todo.id }
	let(:id) { items.first.id }

	# test for /todos/:todo_id/items 
	describe "GET /todos/:todo_id/items" do
		before { get "/todos/#{todo_id}/items" }

		context "when todo exist" do 
			
			it "returns status code 200" do
				expect(response).to have_http_status(200) 
			end  

			it "returns all todo items" do
				expect(json.size).to eq(20) 
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

	# test for PUT /todos/:todo_id/items
	describe "PUT /todos/:todo_id/items" do
		let(:valid_attributes) { { name: "Visit Narnia", done: false } }

		context "when request attributes are valid" do 
			before { post "/todos/#{todo_id}/items", params: valid_attributes }
			
			it "returns status code 201" do 
				expect(response).to have_http_status(201)
			end 
		end

		context "when request attributes are not valid" do
			before { post "/todos/#{todo_id}/items", params: {} }

			it "returns status code 422" do
				expect(response).to have_http_status(422) 
			end 

			it "returns a failur message" do
				expect(response.body).to match(/Validation failed: Name can't be blank/) 
			end
		end
	end

	# test for PUT /todos/:todo_id/items/:id
	describe "PUT /todos/:todo_item/items/:id" do 
		let(:valid_attributes) { { name: 'Mozart' }}

		before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes }

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
	end

	# test for DELETE /todos/:todo_id/items/:id
	describe "DELETE /todos/:todo_id/items/:id" do
		before { delete "/todos/#{todo_id}/items/#{id}" }

		it "returns status code 204" do
			expect(response).to have_http_status(204)
		end 
	end
end