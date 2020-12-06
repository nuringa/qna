require 'rails_helper'

feature 'Authenticated user can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    context 'with no mistakes' do
      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      scenario 'asks a question' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'asks a question with attached files' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'asks a question with a reward for best answer assigned' do
        fill_in 'Reward title', with: 'Reward'
        attach_file 'Reward Image', "#{Rails.root}/spec/support/files/image.png"

        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
      end

      scenario 'asks a question with an reward with mistakes' do
        fill_in 'Reward title', with: 'Reward'

        click_on 'Ask'

        expect(page).to_not have_content 'Your question was successfully created.'
        expect(page).to have_content "Reward file can't be blank"
      end
    end

    context 'with errors' do
      scenario 'asks a question with errors' do
        click_on 'Ask'

        expect(page).to have_content "Title can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions', :cable do
    background do
      Capybara.using_session('author') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end
    end

    scenario 'other users see new question in real-time', js: true do
      Capybara.using_session('author') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end

    scenario 'Question with errors does not appear on another user page', js: true do
      Capybara.using_session('author') do
        click_on 'Ask question'

        fill_in 'Body', with: 'Test question'
        click_on 'Ask'

        expect(page).to have_content "Title can't be blank"
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_content 'Test question'
      end
    end
  end
end
