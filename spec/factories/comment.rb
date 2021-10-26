FactoryBot.define do
	factory :comment do
		user { create(:user) }
		commentable { create(:question) }
		body { 'TestComment' }
	end

	trait :invalid_comment do
		body { nil }
	end
end