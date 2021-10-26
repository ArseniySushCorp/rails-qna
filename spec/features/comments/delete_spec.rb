feature 'User can remove the comment', "
	In order to cancel comment
	As an author of comment
	I'd like to be able remove a comment
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:comment) { create(:comment, user: user, commentable: question) }

  describe 'Authenticated user', js: true do
    scenario 'author tries to delete comment' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content 'TestComment'

      within '.comments' do
        click_on 'Delete'
      end

      expect(page).not_to have_content 'TestComment'
      expect(page).not_to have_content 'Answers body'
      expect(page).to have_content 'Comment successfully deleted'
    end

    scenario 'not a author tries to delete comment' do
      sign_in(create(:user))
      visit root_path

      expect(page).not_to have_content 'Delete'
    end
  end

  scenario 'unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete'
  end
end
