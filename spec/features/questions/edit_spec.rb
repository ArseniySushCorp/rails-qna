feature 'Author can edit own questions', %(
  In order to control own activity
  As an authenticated user
  I'd like to be able to edit own questions
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }
  given(:question_foreign) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end
    given(:delete_btn) { page.all('p.delete-attach') }

    scenario 'when edit own question' do
      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: 'Edited question'
        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).to have_content 'Edited question'
        expect(page).not_to have_selector '#question_title'
        expect(page).not_to have_selector '#question_body'
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

    scenario 'when attach file to own question' do
      within '.question' do
        attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]

        click_on 'Attach'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "when tries to attach file to another user's question" do
      visit question_path(question_foreign)

      within '.question' do
        expect(page).not_to have_link 'Attach'
      end
    end

    scenario "when deletes own question's file" do
      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        delete_btn.first.click

        sleep 1

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end

    scenario "when tries to delete another user's question file" do
      visit question_path(question_foreign)

      within '.question' do
        expect(page).not_to have_link 'Detach'
      end
    end
  end

  scenario 'Unauthenticated user cannot edit questions' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end