require 'rails_helper'

RSpec.describe Todo, type: :model do
	context "validations" do
		it "accept description as string" do
			should have_db_column(:description).of_type(:string)
		end

		it "has status as boolean" do
			should have_db_column(:status).of_type(:boolean).with_options(default: false)
		end
	end

	context "format" do
		todo = Todo.new
		it { expect(todo).to validate_presence_of(:description) }
	end

	context "associations" do
		todo = Todo.new
		it { expect(todo).to belong_to(:user) }
	end

	context "custom methods check and uncheck" do
		it "changes todo status to true" do
			user = User.create(email: "nicholasowh@hotmail.com", first_name: "Nicholas", last_name: "Ong", password: "123456", password_confirmation: "123456")
			todo = user.todos.create(description: "asdasd")
			todo.check
			expect(Todo.last.status).to eq(true)
		end

		it "changes todo status to false" do
			user = User.create(email: "nicholasowh@hotmail.com", first_name: "Nicholas", last_name: "Ong", password: "123456", password_confirmation: "123456")
			todo = user.todos.create(description: "asdasd")
			todo.check
			todo.uncheck
			expect(Todo.last.status).to eq(false)
		end
	end
end