require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user, author of the answer' do
    background do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
      end
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end
  end

  describe 'Authenticated user, not author of the answer' do
    scenario "tries to edit the answer" do
      sign_in another_user
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit answer' do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
