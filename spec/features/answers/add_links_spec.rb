feature 'User can add links to answer', %(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/ArseniySushCorp/5a0a3945f2412b21af906b6ff326679d' }
  given(:google_url) { 'https://google.ru' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'User adds several links when answer question', js: true do
      fill_in 'Your answer', with: 'Question answer'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'add link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'google'
        fill_in 'Url', with: google_url
      end

      click_on 'Answer'

      visit current_path

      expect(page).to have_content 'test gist for qna'
      expect(page).to have_content 'test-guru-question.txt'
      expect(page).to have_content 'gist'

      expect(page).to have_link 'google', href: google_url
    end
  end
end
