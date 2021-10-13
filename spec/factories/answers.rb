FactoryBot.define do
  sequence :body_answer do |n|
    "Answer body #{n}"
  end

  factory :answer do
    body { 'MyAnswer' }
    association :question
    association :user, factory: :user

    factory :uniq_answer do
      body
      association :question
      association :user, factory: :user
    end

    trait :invalid do
      body { nil }
    end
  end
end
