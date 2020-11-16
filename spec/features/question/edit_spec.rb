require 'rails_helper'

feature 'User can edit question', %q{
  In order to correct mistakes
  As an author of a question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user and author of the question', js: true do
    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'can edit his question' do
      within '.question' do
        fill_in 'Body', with: 'edited question'
        click_on 'Update Question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Update Question'

        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'can edit his question and attach files' do
      within '.question' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Authenticated user, not author of the question' do
    scenario "tries to edit the question" do
      sign_in another_user
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  describe 'Not authenticated user' do
    scenario 'tries to edit a question', js: true do
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end
end
