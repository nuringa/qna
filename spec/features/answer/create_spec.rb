require 'rails_helper'

feature 'Authenticated user can answer a question', %q{
  In order to help to find a correct answer
  As an authenticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers a question', js: true do
      fill_in 'Body', with: 'Test answer to the question'
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'Test answer to the question'
      end
    end

    scenario 'answers a question with attached files', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Test answer to the question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Answer'
      end

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'answers a a question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to answer a question' do
      visit question_path(question)
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'multiple sessions', :cable do
    given(:another_user) { create(:user) }
    given(:another_question) { create(:question) }

    background do
      Capybara.using_session('author') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end
    end

    scenario 'other users and guests see new answer published in real-time', js: true do
      Capybara.using_session('author') do
        fill_in 'Body', with: 'Test answer'
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        fill_in 'Link name', with: 'Link to google'
        fill_in 'Url', with: 'https://www.google.com'

        click_on 'Answer'

        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'Link to google', href: 'https://www.google.com'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'Link to google', href: 'https://www.google.com'
        expect(page).to have_link 'Vote up'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
        expect(page).to have_no_link 'rails_helper.rb'
        expect(page).to have_no_link 'Link to google', href: 'https://www.google.com'
        expect(page).to have_no_link 'Vote up'
      end
    end

    scenario 'answer appears only on its question page', js: true do
      Capybara.using_session('another_user') do
        visit question_path(another_question)
      end

      Capybara.using_session('author') do
        fill_in 'Body', with: 'Test answer'

        click_on 'Answer'

        expect(page).to have_content 'Test answer'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_no_content 'Test question'
      end
    end
  end
end
