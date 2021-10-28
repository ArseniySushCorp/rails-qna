feature 'User can add reward to question', "
	In order to give reward to user who create best answer
	As an creator of question
	I'd like to be able add reward to question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'author of question choose your answer', :js do
    sign_in(user)
    visit rewards_path

    expect(page).not_to have_content reward.title

    visit question_path(question)
    click_on 'Best'
    visit rewards_path

    expect(page).to have_content reward.title
  end
end
