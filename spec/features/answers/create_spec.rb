feature 'User can create answer', %(
  In order to answer a question
  As an authenticated user
  I'd like to be able to create answer
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:uniq_question, 3) }

  context 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(questions.first)
    end

    scenario 'answer a question and see question and answers' do
      fill_in 'Body', with: 'Question answer'
      click_on 'Answer'

      expect(page).to have_content questions.first.title
      expect(page).to have_content questions.first.body
      expect(page).to have_content 'Answers:'
      expect(page).to have_content 'Question answer'
    end

    scenario 'try to post empty answer' do
      click_on 'Answer'

      expect(page.find_all('p.answer').count).to eq 0
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(questions.first)

    fill_in 'Body', with: 'Question answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
