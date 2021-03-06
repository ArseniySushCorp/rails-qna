RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigest') }

  before do
    allow(DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls DailyDigest#send_digest' do
    expect(service).to receive(:send_digest)
    described_class.perform_now
  end
end