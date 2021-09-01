feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do
  given(:new_user) { build(:user) }
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Password confirmation', with: new_user.password
    click_on 'Sign up', class: 'btn'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content new_user.email
  end

  scenario 'Registered user tries to sign up' do

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up', class: 'btn'

    expect(page).to have_content 'Email has already been taken'
  end
end
