require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	let(:valid_create_params) {{ first_name: "Nicholas", last_name: "Ong", email: "nicholasowh@hotmail.com", password: "qaqaqaqa1130", password_confirmation: "qaqaqaqa1130" }}
	let(:invalid_create_params) {{ first_name: "John", last_name: "Soo", email: "asdasd", password: "qweqweqweqwe", password_confirmation: "qweqweqweqwe" }}
	let(:valid_update_params) {{ first_name: "John", last_name: "Hon" }}

	it "render new user page" do
		get :new
		expect(response).to have_http_status(:success)
	end

	it "render edit user page" do
		get :edit, params: { id: 1 }
		expect(response).to have_http_status(:success)
	end

	it "shows user page" do
		get :edit, params: { id: 1 }
		expect(response).to have_http_status(:success)
	end

	describe "POST #create" do
		context "valid_create_params" do
			it "creates user if params are correct" do
				expect { post :create, params: {user: valid_create_params} }.to change(User, :count).by(1)
			end

			it "redirects to login page after user is created" do
				post :create, params: {user: valid_create_params}
				expect(response).to redirect_to(sign_in_path)
			end
		end

		context "invalid_create_params" do
			it "does not create user if params are incorrect" do
				expect { post :create, params: {user: invalid_create_params} }.to change(User, :count).by(0)
			end

			it "renders create page again after failing" do
				post :create, params: {user: invalid_create_params}
				expect(response).to render_template('new')
			end
		end
	end

	describe "POST #update" do
		context "valid_update_params" do
			it "updates the user's name after updating" do
				user = User.create(valid_create_params)
				user.update!(valid_update_params)
				expect(user.name).to eq(valid_update_params[:first_name] + " " + valid_update_params[:last_name])
			end

			it "redirects to user's page after updating" do
				user = User.create(valid_create_params)
				session[:current_user_id] = user.id
				post :update, params: {user: valid_update_params, id: user.id}
				expect(response).to redirect_to user_path(user)
			end
		end
	end
end