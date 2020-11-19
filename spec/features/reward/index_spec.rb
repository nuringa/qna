require 'rails_helper'

feature 'User can view list of received rewards', %q{
  In order to evaluate my knowledge and achievements
  As an authenticated user
  I'd like to be able to see a list of recieved awards
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:another_question) { create(:question, author: user) }
  given!(:reward) { create(:reward, question: question, user: user) }
  given!(:another_reward) { create(:reward, question: another_question, user: user) }

  scenario 'Authenticated user sees a list of his rewards' do
    sign_in(user)
    visit rewards_path

    expect(page).to have_content reward.title
    expect(page).to have_content reward.question.title
    expect(page).to have_css("img[src*='image.png']")
    expect(page).to have_content another_reward.title
    expect(page).to have_content another_reward.question.title
  end

  scenario 'Unauthenticated user sees a list of his rewards' do
    visit rewards_path

    expect(page).to_not have_content reward.title
    expect(page).to_not have_content reward.question.title
    expect(page).to_not have_css("img[src*='image.png']")
  end
end
