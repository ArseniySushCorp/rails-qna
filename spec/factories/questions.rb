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
    end
  end

  trait :with_answers do
    transient { answers_count { 3 } }

    after(:create) { |question, evaluator| create_list(:uniq_answer, evaluator.answers_count, question: question, user: question.user) }
  end

  trait :with_file do
    after(:build) do |question|
      question.files.attach(
        io: File.open(Rails.root.join('spec/rails_helper.rb')),
        filename: 'rails_helper.rb',
        content_type: '.rb'
      )
    end
  end

  trait :with_reward do
    reward
  end

  trait :invalid_question do
    title { nil }
  end
end