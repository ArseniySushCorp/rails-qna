FactoryBot.define do
  factory :answer do
    correct { false }
    body { 'answer text' }

    question

    trait :invalid do
      body { nil }
    end
  end
end
