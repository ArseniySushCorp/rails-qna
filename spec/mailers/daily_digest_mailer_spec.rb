RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { described_class.digest(user) }
    let!(:questions) { create_list(:question, 2) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['qna@example.com'])
    end
  end
end