RSpec.describe Ability, type: :model do
	subject(:ability) { described_class.new(user) }

	describe 'for guest' do
		let(:user) { nil }

		it { should be_able_to :read, Question }
		it { should be_able_to :read, Answer }
		it { should be_able_to :read, Comment }

		it { should_not be_able_to :manage, :all }
	end

	describe 'for user' do
		let(:user) { create(:user) }
		let(:other) { create(:user) }

		it { should be_able_to :read, :all }
		it { should be_able_to :create, Question }
		it { should be_able_to :create, Answer }
		it { should be_able_to :create, Comment }
		it { should be_able_to :vote, Comment }
		it { should be_able_to :vote, Answer }
		it { should be_able_to :cancel_vote, create(:vote, user: user), user: user }
		it { should be_able_to :manage, create(:question, user: user), user: user }
		it { should be_able_to :manage, create(:answer, user: user), user: user }
		it { should be_able_to :manage, create(:comment, user: user), user: user }
		it { should be_able_to :nominate, create(:answer, question: create(:question, user: user)), user: user }

		it { should_not be_able_to :manage, :all }
		it { should_not be_able_to :cancel_vote, create(:vote, user: other), user: user }
		it { should_not be_able_to :manage, create(:question, user: other), user: user }
		it { should_not be_able_to :manage, create(:answer, user: other), user: user }
		it { should_not be_able_to :manage, create(:comment, user: other), user: user }
		it { should_not be_able_to :nominate, create(:answer, question: create(:question, user: other)), user: user }
		it { should_not be_able_to :vote, create(:vote, user: user), user: user }
		it { should_not be_able_to :vote, create(:vote, user: user), user: user }
	end
end