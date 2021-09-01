FactoryBot.define do
  factory :question do
    title { Faker::Books::Lovecraft.location }
    body { Faker::Books::Lovecraft.location }

    trait :invalid do
      title { nil }
    end
  end
end
