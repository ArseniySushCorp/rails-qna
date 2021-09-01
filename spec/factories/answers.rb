FactoryBot.define do
  factory :answer do
    correct { false }
    body { Faker::Books::Lovecraft.sentence }

    question

    trait :invalid do
      body { nil }
    end
  end
end
