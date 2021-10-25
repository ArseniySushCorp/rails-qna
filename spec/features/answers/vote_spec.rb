feature 'User can vote for answer', "
	In order to identify a best answer
	As an authenticated user
	I'd like to be vote for answer
" do
	given(:user) { create(:user) }
	given(:question) { create(:question, user: user) }

	background do
		sign_in(user)
		create(:answer, question: question)
		visit question_path(question)
	end

	scenario 'User voted for a liked answer', :js do
		expect(page).not_to have_content 'Cancel vote'

		click_on 'Like'

		expect(page).to have_content 'Cancel vote'
	end

	scenario 'User voted for a disliked answer', :js do
		expect(page).not_to have_content 'Cancel vote'

		click_on 'Dislike'

		expect(page).to have_content 'Cancel vote'
	end

	scenario 'User canceled vote', :js do
		click_on 'Like'
		click_on 'Cancel vote'

		expect(page).to have_content 'Like'
		expect(page).to have_content 'Dislike'
	end
end