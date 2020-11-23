require 'rails_helper'

feature 'User can delete links in his question', %q{
  In order to remove not needed information
  As an authenticated user and author of the question
  I'd like to be able to delete links attached to my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user' do
    scenario 'tries to delete a link in his question', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit question'

      within('.question') do
        click_on 'Remove Link'
        click_on 'Update Question'
      end

      expect(page).to have_content question.body
      expect(page).to_not have_link 'Link to google', href: 'http://www.google.com'
    end
  end
end
