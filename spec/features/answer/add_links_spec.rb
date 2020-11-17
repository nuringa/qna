require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  given(:google_url) {'https://www.google.com/'}
  given(:yandex_url) {'https://www.yandex.ru/'}

  scenario 'User adds link when he answers a question', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'Link to google'
    fill_in 'Url', with: google_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Link to google', href: google_url
    end
  end

  scenario 'User adds multiple links when he answers a question', js: true do
    sign_in(user)

    visit question_path(question)

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
end
