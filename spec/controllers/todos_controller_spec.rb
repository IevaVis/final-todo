require 'rails_helper'

RSpec.describe TodosController, type: :controller do
	let(:valid_create_params) {{ first_name: "Nicholas", last_name: "Ong", email: "nicholasowh@hotmail.com", password: "qaqaqaqa1130", password_confirmation: "qaqaqaqa1130" }}

	it "renders new todo page" do
		get :new
		expect(response).to have_http_status(:success)
	end

	it "does not render new todo page if todo count for user is more or equal to 5" do
		user = User.create(valid_create_params)
		session[:current_user_id] = user.id
		1.upto(5) do |x|
			user.todos.create(description: "#{x}")
		end
		get :new
		expect(response).to redirect_to(user_path(user))
	end

	it "renders new page if user has paid even if there is more than 5 todo" do
		user = User.create(valid_create_params)
		user.update!(paid: true)
		session[:current_user_id] = user.id
		1.upto(5) do |x|
			user.todos.create(description: "#{x}")
		end
		get :new
		expect(response).to have_http_status(:success)
	end

	it "renders new page if user is admin even if there is more than 5 todo" do
		user = User.create(valid_create_params)
		user.update!(position: 1)
		session[:current_user_id] = user.id
		1.upto(5) do |x|
			user.todos.create(description: "#{x}")
		end
		get :new
		expect(response).to have_http_status(:success)
	end

	it "renders edit todo page" do
		user = User.create(valid_create_params)
		get :edit, params: {id: user.id}
		expect(response).to have_http_status(:success)
	end

	describe "POST #create" do
		context "creating todo" do
			it "creates todo" do
				user = User.create(valid_create_params)
				todo = user.todos.create(description: "asdasd")
				expect(Todo.count).to eq(1)
			end

			it "creates todo if user is admin and has 5 todos" do
				user = User.create(valid_create_params)
				user.update!(position: 1)
				session[:current_user_id] = user.id
				1.upto(5) do |x|
					user.todos.create(description: "#{x}")
				end
				expect { post :create, params: {todo: {description: "asdasd"}} }.to change(Todo, :count).by(1)
			end

			it "creates todo if user has paid and has 5 todos" do
				user = User.create(valid_create_params)
				user.update!(paid: true)
				session[:current_user_id] = user.id
				1.upto(5) do |x|
					user.todos.create(description: "#{x}")
				end
				expect { post :create, params: {todo: {description: "asdasd"}} }.to change(Todo, :count).by(1)
			end

			it "redirects to show user path after creating todo" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				post :create, params: {todo: {description: "asdasd"}}
				expect(response).to redirect_to user_path(user)
			end
		end

		context "prevent creation of todo" do
			it "prevents creation of todo if user has more than 5 todos" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				1.upto(5) do |x|
					user.todos.create(description: "#{x}")
				end
				expect { post :create, params: {description: "asdasd"} }.to change(Todo, :count).by(0)
			end
		end
	end

	describe "DELETE #destroy" do
		context "deleting todo" do
			it "deletes todo" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				todo = user.todos.create(description: "asdasd")
				expect { delete :destroy, params: {id: todo.id} }.to change(Todo, :count).by(-1)
			end

			it "redirect to user's path after deleting todo" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				todo = user.todos.create(description: "asdasd")
				delete :destroy, params: { id: todo.id }
				expect(response).to redirect_to user_path(user)
			end
		end
	end

	describe "POST #toggle" do
		context "toggle status" do
			it "toggles false to true" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				todo = user.todos.create(description: "asdasd")
				post :toggle, params: { id: todo.id }
				expect(Todo.where(status: true).count).to eq(1)
			end

			it "toggles true to false" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				todo = user.todos.create(description: "asdasd")
				todo.update!(status: true)
				post :toggle, params: { id: todo.id }
				expect(Todo.where(status: false).count).to eq(1)
			end
		end
	end
end