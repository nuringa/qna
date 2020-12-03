
require 'rails_helper'

feature 'Add comment to answer', %q{
  As an authenticated user
  To provide information or opinion
  I want to be able to leave a comment to answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for an answer with valid attributes' do
      within '.answer-comments' do
        fill_in 'Comment', with: 'New Comment'
        click_on 'Add comment'
      end

      expect(page).to have_content 'New Comment'
    end

    scenario 'creates comment for answer with invalid attributes' do
      within '.answer-comments' do
        click_on 'Add comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  context "Unauthenticated user" do
    scenario 'tries to create comment for answer' do
      visit question_path(question)

      within '.answer-comments' do
        expect(page).not_to have_content 'Add Comment'
      end
    end
  end
end
