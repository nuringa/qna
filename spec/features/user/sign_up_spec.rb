require 'rails_helper'

feature 'Visitor can sign up', "
  In order to be able to log in to the site
  As an unregistered user
  I'd like to be able to sign up
" do

  describe 'Registration with valid data' do

    given(:user) { create(:user) }

    scenario 'Unregistered user enters valid data' do
      visit new_user_registration_path
      fill_in 'Email', with: 'email@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content "Welcome! You have signed up successfully."
    end

    scenario 'Registered user enters valid data' do
      visit new_user_registration_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Sign up'

      expect(page).to have_content "Email has already been taken"
    end
  end

  describe 'Registration with invalid' do
    scenario 'empty data' do
      visit new_user_registration_path
      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank Password can't be blank"
    end

    scenario 'wrong password' do
      visit new_user_registration_path
      fill_in 'Email', with: 'email@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
