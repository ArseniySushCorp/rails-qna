feature 'User can see questions list', %(
  In order to find needed answer
  I'd like to be able to see questions list
) do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'Authenticated user can see questions list' do
    sign_in(user)
    visit root_path

    expect(page).to have_content('MyString', count: 3)
  end

  scenario 'Unauthenticated user can see questions list' do
    visit root_path

    expect(page).to have_content('MyString', count: 3)
  end
end
