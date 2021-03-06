RSpec.describe QuestionSubscriptionMailer, type: :mailer do
  describe 'question_subscription' do
    let(:user) { create(:user) }
    let(:mail) { QuestionSubscriptionMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['qna@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('New answer!')
    end
  end
end