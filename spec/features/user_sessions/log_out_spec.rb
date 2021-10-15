feature 'User can log out', %(
  In order to end session
  As an authenticated user
  I'd like to be able to log out
) do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenticated user can log out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
