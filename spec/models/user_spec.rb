require 'rails_helper'

RSpec.describe User, type: :model do
	context "validations" do
		it "should have firstname column with string" do
			should have_db_column(:first_name).of_type(:string)
		end

		it "should have lastname column with string" do
			should have_db_column(:last_name).of_type(:string)
		end

		it "should have email column with string" do
			should have_db_column(:email).of_type(:string)
		end

		it "should have password_digest column with string" do
			should have_db_column(:password_digest).of_type(:string)
		end

		it "should have position column with integer" do
			should have_db_column(:position).of_type(:integer).with_options(default: "user")
		end

		it "should have paid column with boolean" do
			should have_db_column(:paid).of_type(:boolean).with_options(default: false)
		end
	end

	context "format" do
		user = User.new
		it { expect(user).to allow_value("qaqaqaqaowh@hotmail.com").for(:email) }
		it { expect(user).to_not allow_value("asdubEfosabfnqwo").for(:email) }
		it { expect(user).to validate_presence_of(:email) }
	end

	context "associations" do
		user = User.new
		it { expect(user).to have_many(:todos).dependent(:destroy) }
	end

	context "custom method" do
		it "Combines first name and last name" do
			user = User.create(email: "nicholasowh@hotmail.com", first_name: "Nicholas", last_name: "Ong", password: "123456", password_confirmation: "123456")
			expect(User.last.name).to eq("Nicholas Ong")
		end
	end
end