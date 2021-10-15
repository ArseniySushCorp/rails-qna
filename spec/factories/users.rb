FactoryBot.define do
  sequence(:email) { |n| "user#{n}@test.com" }
  fake_password = Faker::Internet.password

  factory :user do
    email
    password { fake_password }
    password_confirmation { fake_password }
  end
end
