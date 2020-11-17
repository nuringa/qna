require 'rails_helper'

feature 'User can delete links in his answer', %q{
  In order to remove not needed information
  As an authenticated user and author of the answer
  I'd like to be able to delete links attached to my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user' do
    scenario 'tries to delete a link in his answer', js: true do
      sign_in(user)
      visit questions_path
      click_on question.title

      within '.answers' do
        click_on 'Edit'

        within '.nested-fields' do
          click_on 'Remove Link'
        end

        click_on 'Save'
      end

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Link to google', href: 'http://www.google.com'
    end
  end
end
