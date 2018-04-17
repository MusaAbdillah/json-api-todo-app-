require 'rails_helper'

RSpec.describe Todo, type: :model do
	# association test 
	# ensure todo model has a 1:m relationship with item 
	it { should have_many(:items).dependent(:destroy) }
	# validation test 
	# ensure title, created_by column are present before saving 
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:created_by) }
end
