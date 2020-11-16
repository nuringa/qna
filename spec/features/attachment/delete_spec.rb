require 'rails_helper'

feature 'Author can delete an attachment', "
  In order to correct mistakes
  As an authenticated user and author of a resource
  I'd like to be able to delete fiels attached to my answers or questions
" do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'An author of the resource', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can delete files attached to the question' do
      within '.question' do
        click_on 'Edit question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Question'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      within "#attachment_#{question.files.first.id}" do
        click_on 'Delete File'
        page.driver.browser.switch_to.alert.accept
      end

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'can delete files attached to the answer' do
      within '.answers' do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      within "#attachment_#{answer.files.first.id}" do
        click_on 'Delete File'
        page.driver.browser.switch_to.alert.accept
      end

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  describe 'Not an author of the resource', js: true do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'can not delete files attached to the question' do
      expect(page).to_not have_link 'Edit question'
      expect(page).to_not have_link 'Delete File'
    end

    scenario 'can not delete files attached to the answer' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete File'
    end
  end
end
