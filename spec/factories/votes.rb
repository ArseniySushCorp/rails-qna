FactoryBot.define do
	factory :vote do
		user { create(:user) }
		votable { create(:question) }
		liked { true }
	end
end