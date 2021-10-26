RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#assign_as_best' do
    let(:question) { create(:question, :with_answers) }

    before { question.answers.last.assign_as_best }

    it 'answer set as best' do
      expect(question.reload.answers.first).to be_best
    end

    it 'best answer is only one' do
      best_answer = question.answers.select(&:best)
      expect(best_answer.count).to eq 1
    end
  end
end
