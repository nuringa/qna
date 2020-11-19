require 'rails_helper'

feature 'Visitor can see a question and a list of answers to a question', %q{
  In order to find out all available answers to the question
  As an unauthenticated user
  I'd like to see the question and its answers on the same page
} do

  given!(:question) { create( :question) }

  scenario 'Visitor can see a question' do
    visit question_path(question)
    expect(page).to have_content 'Simple question'
    expect(page).to have_content 'Body of the question'
  end

  describe 'With existing list of answers visitor' do
    given!(:answers) { create_list(:answer, 3, :for_list, question: question) }

    scenario 'sees all answers to a question' do
      visit question_path(question)

      expect(page).to have_content 'Answers'
      answers.each.with_index(1) do |_answer, index|
        expect(page).to have_content "Body of the answer #{index}"
      end
    end

    scenario 'sees a reward for the best answer if it was given' do
      create(:reward, title: 'Show reward', question: question)
      answer = create(:answer, question: question)
      answer.select_best!

      visit question_path(question)

      expect(page).to have_content "Show reward"
      expect(page).to have_css("img[src*='image.png']")
    end
  end
end
