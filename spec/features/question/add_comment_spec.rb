require 'rails_helper'

feature 'Add comment to question', %q{
  As an authenticated user
  To provide information or opinion
  I want to be able to leave a comment to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for question with valid attributes' do
      within '.question-comments' do
        fill_in 'Comment', with: 'My comment'
        click_on 'Add comment'
        expect(page).to have_content 'My comment'
      end
    end

    scenario 'creates comment for question with invalid attributes' do
      within '.question-comments' do
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'Unauthenticated user' do
    scenario 'tries to leave a comment for question' do
      visit question_path(question)

      within '.question-comments' do
        expect(page).not_to have_content 'Add Comment'
      end
    end
  end

  context 'Multiple sessions' do
    scenario "saved comment appears on another user's page in real time", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-comments' do
          fill_in 'Comment', with: 'Question Comment'
          click_on 'Add comment'
          expect(page).to have_content 'Question Comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'Question Comment'
        end
      end
    end
  end
end
