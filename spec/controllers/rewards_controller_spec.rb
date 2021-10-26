RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:reward) { create(:reward, user: user) }

    before do
      login(user)
      get :index
    end

    it 'assigns a new reward to @rewards' do
      expect(assigns(:rewards)).to match_array(user.rewards)
    end
  end
end
