RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:question_subscription).source(:question).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
