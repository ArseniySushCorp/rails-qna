feature 'User can register', %(
  In order to get all permissions
  I'd like to be able to register
) do
  context 'when user tries to register' do
    background { visit new_user_registration_path }

    scenario 'with valid params' do
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'with invalid password confirmation' do
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '654321'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
