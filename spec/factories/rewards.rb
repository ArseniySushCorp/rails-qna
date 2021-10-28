FactoryBot.define do
  factory :reward do
    title { 'MyReward' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/reward.png')) }
    question
  end
end
