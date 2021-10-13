feature 'User can see question', %(
  In order to find needed answer
  I'd like to be able to see question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user can see question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Unauthenticated user can see question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
