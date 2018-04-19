class User < ApplicationRecord
	# association 
	has_many :todos, foreign_key: :created_by
	# validation 
	validates_presence_of(:name)
	validates_presence_of(:email)
	validates_presence_of(:password_digest)
	# bcrypt to encryp password
	has_secure_password
end
