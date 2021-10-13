RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'when user is the author' do
      expect(user).to be_author_of(question)
    end

    it 'when user is not the author' do
      expect(another_user).not_to be_author_of(question)
    end
  end
end
