feature 'Author can edit own questions', %(
  In order to control own activity
  As an authenticated user
  I'd like to be able to edit own questions
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:question_foreign) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end
    scenario 'when edit own question' do
      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: 'Edited question'
        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).to have_content 'Edited question'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'when edit own questions with errors' do
      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "when tries to edit other users's questions" do
      visit question_path(question_foreign)

      expect(page).to have_content question_foreign.body
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user cannot edit questions' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end