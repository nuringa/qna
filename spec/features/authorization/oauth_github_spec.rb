require 'rails_helper'

feature 'User can authorize via facebook', %q{
  As a new or registered user
  In order to login quickly
  I want to be able to authorize through github
} do

  background do
    visit new_user_session_path

    mock_auth_hash
  end

  scenario 'New user authorizes via Github' do
    click_on 'Sign in with GitHub'

    expect(page).to have_content('Successfully authenticated from Github account.')
    expect(page).to have_content('Sign out')
  end

  scenario 'User authorized by Github, tries to authorize via Github again' do
    click_on 'Sign in with GitHub'

    expect(page).to have_content('Successfully authenticated from Github account.')
    click_on 'Sign out'
    click_on 'Login'

    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content('Successfully authenticated from Github account.')
  end

  scenario 'User registered with email, tries to authorize via Github' do

    visit new_user_registration_path

    fill_in 'Email', with: 'mock_user@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')

    click_on 'Sign out'
    click_on 'Login'
    click_on 'Sign in with GitHub'

    expect(page).to have_content('Successfully authenticated from Github account.')
    click_on 'Sign out'
    click_on 'Login'
    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content('Successfully authenticated from Github account.')
  end
end
