class Todo < ApplicationRecord
	mount_uploaders :avatars, AvatarUploader
	belongs_to :user
	validates :description, presence: true

	def check
		self.status = true
		self.save
	end

	def uncheck
		self.status = false
		self.save
	end
end
