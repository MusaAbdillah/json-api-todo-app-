require 'rails_helper'

RSpec.describe Item, type: :model do
	# association 
	# ensure that item belongs to todo
	it { should belong_to(:todo) }
	# validation 
	# ensure that name is present before saving 
	it { should validate_presence_of(:name) }
end
