feature 'Author can destroy own answers', %(
  In order to control own activity
  As an authenticated user
  I'd like to be able to destroy own answers
) do
  given(:answer_own) { create(:answer) }
  given(:answer_foreign) { create(:answer) }

  context 'Authenticated user tries to destroy' do
    background { sign_in(answer_own.user) }

    scenario 'own answer' do
      visit question_path(answer_own.question)

      expect(page).to have_content answer_own.body

      click_on 'Delete answer'

      expect(page).to have_content 'Answer was successfully deleted.'
      expect(page).not_to have_content answer_own.body
    end

    scenario 'another answer' do
      visit question_path(answer_foreign.question)

      expect(page).to have_content answer_foreign.body

      click_on 'Delete answer'

      expect(page).to have_content "You can't delete this answer, because you are not an author."
      expect(page).to have_content answer_foreign.body
    end
  end

  scenario 'Unuthenticated user can not delete answer' do
    visit question_path(answer_foreign.question)

    expect(page).not_to have_link 'Delete answer'
  end
end
