feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to_not have_content user.email
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit root_path

    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'

    expect(page).to_not have_content 'Sign out'
  end
end
