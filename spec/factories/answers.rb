FactoryBot.define do
  factory :answer do
    body { 'MyAnswer' }
    question
    association :user, factory: :user

    factory :uniq_answer do
      sequence :body do |n|
        "Answer body #{n}"
      end
      question
      association :user, factory: :user
    end
  end

  trait :invalid do
    body { nil }
  end
end