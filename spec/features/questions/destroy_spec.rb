feature 'Author can destroy own questions', %(
  In order to control own activity
  As an authenticated user
  I'd like to be able to destroy own questions
) do
  given!(:question_own) { create(:question) }
  given!(:question_foreign) { create(:question) }

  describe 'Authenticated user tries to destroy' do
    background { sign_in(question_own.user) }

    scenario 'own question' do
      visit question_path(question_own)

      expect(page).to have_content question_own.body

      click_on 'Delete'

      expect(page).to have_content 'Question was successfully deleted.'
      expect(page).not_to have_content question_own.body
    end

    scenario 'another question' do
      visit question_path(question_foreign)

      expect(page).to have_content question_foreign.title
      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'Unuthenticated user can not delete question' do
    expect(page).not_to have_link 'Delete'
  end
end
