FactoryBot.define do
  sequence :title do |n|
    "Question #{n}"
  end

  sequence :body do |n|
    "Body of Question #{n}"
  end

  factory :question do
    title { 'MyString' }
    body { 'MyQuestion' }
    association :user, factory: :user

    factory :uniq_question do
      title
      body
      association :user, factory: :user
    end

    trait :invalid do
      title { nil }
    end
  end
end
