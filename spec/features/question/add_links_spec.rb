require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:google_url) {'https://www.google.com/'}
  given(:yandex_url) {'https://www.yandex.ru/'}

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Link to google'
    fill_in 'Url', with: google_url

    click_on 'Ask'

    expect(page).to have_link 'Link to google', href: google_url
  end

  scenario 'User adds multiple links to his question', js: true do
    sign_in(user)
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

end
