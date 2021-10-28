feature 'User can create question', %(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    context 'when asks a question' do
      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      scenario 'with attached files' do
        attach_file 'File', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]

        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'without attached files' do
        click_on 'Ask'

        expect(page).to have_content 'Question was successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'multiple sessions' do
    scenario 'question appears on another users page', :js do
      Capybara.using_session('user') do
        sign_in(user)

        visit new_question_path
      end

      Capybara.using_session('guest') do
        visit root_path

        expect(page).not_to have_content 'Test question'
      end

      Capybara.using_session('user') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test test'

        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test test'
      end

      Capybara.using_session('guest') do
        visit root_path

        expect(page).to have_content 'Test question'
      end
    end
  end
end
