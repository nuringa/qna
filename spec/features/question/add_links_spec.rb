require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://www.yandex.ru/' }
  given(:gist_url) { 'https://gist.github.com/nuringa/6afe26f1d6c0236787a6ee9d002378af' }
  given(:question) { create(:question, author: user) }

  background { sign_in(user) }

  scenario 'User adds multiple links to a new question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Link to google'
    fill_in 'Url', with: google_url

    click_on 'Add Link'
    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Link to yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Ask'

    expect(page).to have_link 'Link to google', href: google_url
    expect(page).to have_link 'Link to yandex', href: yandex_url
  end

  scenario 'User adds links when editing a question', js: true do
    visit question_path(question)
    click_on 'Edit question'

    within "#edit-question-#{question.id}" do
      click_on 'Add Link'
      fill_in 'Link name', with: 'Link to google'
      fill_in 'Url', with: google_url

      click_on 'Add Link'
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Link to yandex'
        fill_in 'Url', with: yandex_url
      end
    end

    click_on 'Update Question'

    expect(page).to have_link 'Link to google', href: google_url
    expect(page).to have_link 'Link to yandex', href: yandex_url
  end

  scenario 'User adds and views a gist in his question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'
    expect(page).to have_content 'hello'
    expect(page).to have_content 'gistfile1.txt hosted with'
    expect(page).to_not have_link 'My gist', href: gist_url
  end
end
