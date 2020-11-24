require 'rails_helper'

feature "User can vote for other's questions", %(
  In order to indicate whether the question is useful or not
  As an authenticated user
  I'd like to be able to vote for questions
), js: true do

  given(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe "Authenticated user - not question's author" do
    background do
      sign_in(another_user)
    end

    scenario "votes for other user's question" do
      visit question_path(question)
      click_on 'Vote up'

      expect(page).to have_content '1'
    end

    scenario 'changes his vote' do
      visit question_path(question)
      click_on 'Vote up'
      click_on 'Vote down'

      expect(page).to have_content '-1'
    end

    scenario "can change rating the same way only once" do
      visit question_path(question)
      click_on 'Vote up'
      click_on 'Vote up'

      expect(page).not_to have_content '2'
      expect(page).to have_content '1'
    end
  end

  describe "Authenticated user - question's author" do
    background do
      sign_in(user)
    end

    scenario "can't vote for his own question" do
      visit question_path(question)

      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end

  describe 'Unauthenticated user' do
    scenario "can't vote for any question" do
      visit question_path(question)

      expect(page).not_to have_content 'Vote up'
      expect(page).not_to have_content 'Vote down'
    end
  end
end
