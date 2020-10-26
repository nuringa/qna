require 'rails_helper'

feature 'User can see list of questions', "
  In order to see all the questions asked by community
  As a visitor
  I'd like to be able to see the list of questions
" do

  describe 'With one or more questions already in data base' do
    given!(:questions) { create_list( :question, 3, :for_list) }

    scenario 'sees a list of questions' do
      visit questions_path
      expect(page).to have_content 'Questions'
      questions.each.with_index(1) do |_question, index|
        expect(page).to have_content "Question #{index}"
      end
    end
  end

  describe 'With no questions in data base' do
    scenario 'sees a message if there are no questions asked yet' do
      visit questions_path
      expect(page).to have_content 'No questions to show.'
    end
  end
end
