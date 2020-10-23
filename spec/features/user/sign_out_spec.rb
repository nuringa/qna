require 'rails_helper'

feature 'Authenticated user can sign out', %q{
  In order to finish my session
  As an authenticated user
  I can sign out
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit root_path
  end

  scenario 'Authenticated user tries to sign out' do
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end