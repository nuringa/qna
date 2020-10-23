require 'rails_helper'

feature 'Author can delete his question', "
  In order to express one's opinion
  As an authenticated user and author of question
  I'd like to be able to delete my question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_user) { create(:user) }

  describe 'An author of the question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'deletes it' do
      expect(page).to have_content 'Simple question'
      expect(page).to have_content 'Body of the question'
      click_on 'Delete question'
      expect(page).to have_content 'Your question was deleted.'
    end
  end

  describe 'Not an author of the question' do
    background do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'cannot delete a question' do
      expect(page).to have_content 'Simple question'
      expect(page).to have_content 'Body of the question'
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user cannot delete question' do
    visit question_path(question)

    expect(page).to have_content 'Simple question'
    expect(page).to have_content 'Body of the question'
    expect(page).to_not have_content 'Delete'
  end
end
