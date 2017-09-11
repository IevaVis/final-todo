class User < ApplicationRecord
	mount_uploader :avatar, AvatarUploader
	has_many :todos, dependent: :destroy
	has_secure_password
	validates :email, uniqueness: true
	validates :email, :uniqueness=> true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "error"}
	validates :first_name, :last_name, :password, :password_confirmation, :email, presence: true, on: [:create]
	
	enum position: [:user, :admin]

	def name
		self.first_name + " " + self.last_name
	end
end
