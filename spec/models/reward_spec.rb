RSpec.describe Reward, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :image }

  it 'have one attached reward image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
