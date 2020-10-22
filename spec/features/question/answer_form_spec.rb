require 'rails_helper'

feature 'User can answer a question', %q{
  In order to help answer the question
  As an authenticated user
  I'd like to post my answer on the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenitcated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'My answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'My answer'
    end

    scenario 'gives answer with invalid params' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthorized user' do
    background do
      visit question_path(question)
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'My answer'
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
