RSpec.describe DailyDigest, type: :service do
  let(:users) { create_list(:user, 3) }

  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    described_class.send_digest
  end
end