require 'rails_helper'

RSpec.describe User, type: :model do
	# test for association 
	it { should have_many(:todos) }
	# test for validation 
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password_digest) }
end
