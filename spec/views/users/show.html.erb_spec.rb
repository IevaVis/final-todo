require 'capybara/rspec'
require 'rails_helper'

describe "toggling status of todos", js: true do
	before :each do
		user = User.create(first_name: "Nicholas", last_name: "Ong", email: "nicholasowh@hotmail.com", password: "123456", password_confirmation: "123456")
		todo = user.todos.create(description: "asdasd")
		session[:current_user_id] = user.id
		visit(root_path)
		click_link('Sign In')
		fill_in('E-mail', with: 'nicholasowh@hotmail.com')
		fill_in('Password', with: '123456')
		fill_in('Password Confirmation', with: '123456')
		click_button('Log In')
	end

	it "changes to true" do
		user = User.last
		visit(user_path(user))
		click_link("false")
		expect(find_link(id: Todo.last.id).text).to eq("true")
	end

	it "changes to false" do
		user = User.last
		todo = Todo.last
		todo.update!(status: true)
		visit(user_path(user))
		click_link("true")
		expect(find_link(id: Todo.last.id).text).to eq("false")
	end
end