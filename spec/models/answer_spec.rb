require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  describe 'scope sort_by_best' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, question: question) }

    it 'should return a list with best answers first' do
      answers << create(:answer, body: 'Best answer', question: question, best: true)
      answers.shuffle
      expect(question.answers.sort_by_best.first.body).to eq('Best answer')
    end
  end
end
