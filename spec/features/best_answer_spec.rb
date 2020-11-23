require 'rails_helper'

feature 'Select best answer', %q{
  In order to distinguish correct answer
  As an author of the question
  I'd like to be able to select the best answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:another_answer) { create(:answer, body: 'Another answer', question: question, author: user) }
  given!(:reward) { create(:reward, question: question) }

  describe 'Authenticated user', js: true do
    context 'Author of the question' do
      background do
        sign_in user
        visit question_path(question)
      end

      scenario 'can select the best answer' do
        within "#answer-#{answer.id}" do
          click_on 'Choose best'
        end

        within '.best-bg' do
          expect(page).to have_content answer.body
        end
      end

      scenario 'can select another best answer' do
        within "#answer-#{answer.id}" do
          click_on 'Choose best'
        end

        within "#answer-#{another_answer.id}" do
          click_on 'Choose best'
        end

        within '.best-bg' do
          expect(page).to_not have_content answer.body
          expect(page).to have_content another_answer.body
        end
      end

      scenario 'can select the best answer and see a reward icon assigned to it' do
        within "#answer-#{answer.id}" do
          click_on 'Choose best'
        end

        expect(page).to have_css("img[src*='image.png']", count: 1)
        within '.best-bg' do
          expect(page).to have_content answer.body
        end
      end
    end

    context 'User not author of the question' do
      background do
        sign_in another_user
        visit question_path(question)
      end

      scenario 'can not select best answer' do
        expect(page).to_not have_link 'Choose best'
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not select best answer' do
      expect(page).to_not have_link 'Choose best'
    end
  end
end
