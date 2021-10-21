feature 'Author can edit own answers', %(
  In order to control own activity
  As an authenticated user
  I'd like to be able to edit own answers
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_files, question: question, user: user) }
  given(:answer_foreign) { create(:answer) }
  given(:delete_btn) { page.all('p.delete-attach') }

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

    scenario 'when attach file to own answer' do
      within '.answers' do
        attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]

        click_on 'Attach'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "when tries to attach file to another user's answer" do
      visit question_path(answer_foreign.question)

      within '.answers' do
        expect(page).not_to have_link 'Attach'
      end
    end

    scenario "when deletes own question's file" do
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        delete_btn.last.click

        sleep 1

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end

    scenario "when tries to delete another user's question file" do
      visit question_path(answer_foreign.question)

      within '.answer' do
        expect(page).not_to have_link 'Detach'
      end
    end
  end

  scenario 'Unauthenticated user cannot edit answers' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end