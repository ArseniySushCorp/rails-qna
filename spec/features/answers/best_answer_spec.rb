feature 'User can set the best answer', %(
  In order to make more focus on good answer
  As an authenticated user
  I'd like to be able to set the best answer
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_answers, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    given(:best_btn) { page.all("input[value='Best']") }

    scenario "when set own question's best answer. Answer becomes first in answers list" do
      best_btn.last.click
      sleep 1

      expect(page.all('ul.answers li').first).to have_content question.answers.first.body
      expect(page.all('ul.answers li').last).not_to have_content question.answers.first.body
    end

    scenario "when tries to set other users's question best answer" do
      expect(page).not_to have_link 'Best'
    end
  end

  scenario 'Unauthenticated user cannot set the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Best'
  end
end
