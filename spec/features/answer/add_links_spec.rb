require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:google_url) {'https://www.google.com/'}
  given(:yandex_url) {'https://www.yandex.ru/'}
  given(:gist_url) { 'https://gist.github.com/nuringa/6afe26f1d6c0236787a6ee9d002378af' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds multiple links when he answers a question', js: true do
    fill_in 'Body', with: 'My answer'
    fill_in 'Link name', with: 'Link to google'
    fill_in 'Url', with: google_url

    click_on 'Add Link'
    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Link to yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Link to google', href: google_url
      expect(page).to have_link 'Link to yandex', href: yandex_url
    end
  end

  scenario 'User adds links when editing a question', js: true do
    click_on 'Edit'

    within "#answer-#{answer.id}" do
      click_on 'Add Link'
      fill_in 'Link name', with: 'Link to google'
      fill_in 'Url', with: google_url

      click_on 'Add Link'
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Link to yandex'
        fill_in 'Url', with: yandex_url
      end
    end

    click_on 'Save'

    expect(page).to have_link 'Link to google', href: google_url
    expect(page).to have_link 'Link to yandex', href: yandex_url
  end

  scenario 'User adds and views a gist in his answer', js: true do
    fill_in 'Body', with: 'My answer'
    fill_in 'Link name', with: 'Gist link'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_content 'hello'
      expect(page).to have_content 'gistfile1.txt hosted with'
    end
  end
end
