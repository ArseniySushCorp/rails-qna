feature 'Author can edit own answers', %(
  In order to control own activity
  As an authenticated user
  I'd like to be able to edit own answers
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:answer_foreign) { create(:answer) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end
    scenario 'when edit own answers' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'when edit own answers with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "when tries to edit other users's answers" do
      visit question_path(answer_foreign.question)

      expect(page).to have_content answer_foreign.body
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user cannot edit answers' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end