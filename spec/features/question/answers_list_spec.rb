require 'rails_helper'

feature 'Visitor can see a list of answers to a question', %q{
  In order to find out all available answers to the question
  As an unauthenticated user
  I'd like to see the answers on the question page
} do

  given!(:question) { create( :question) }

  describe 'With existing list of answers' do
    given!(:answers) { create_list(:answer, 3, :for_list, question: question) }

    before { visit question_path(question) }

    scenario 'sees all answers to a question' do
      expect(page).to have_content 'Answers'
      answers.each.with_index(1) do |_answer, index|
        expect(page).to have_content "Body of the answer #{index}"
      end
    end
  end

  describe 'With no answers to the question' do
    scenario 'sees a message that there are no answers given yet' do
      visit question_path(question)
      expect(page).to have_content 'No answers to show.'
    end
  end
end
