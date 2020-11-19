require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for(:links).allow_destroy(true) }

  it { should validate_presence_of :body }

  describe 'scope sort_by_best' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, question: question) }

    it 'should return a list with best answers first' do
      answers << create(:answer, body: 'Best answer', question: question, best: true)
      answers.shuffle
      expect(question.answers.sort_by_best.first.body).to eq('Best answer')
    end
  end

  it 'can have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#select_best!' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 3, :for_list, question: question) }
    let(:another_answer) { create(:answer, question: question, body: 'Best answer') }

    it 'should change best attribute of the answer to true' do
      answers << another_answer
      another_answer.select_best!

      expect(question.answers.detect { |answer| answer.best }.body).to eq('Best answer')
    end

    it "should set just one best answer for the question" do
      answers.first.update!(best: true)
      another_answer.select_best!

      expect(question.answers.detect { |answer| answer.best }.body).to eq('Best answer')
    end

    it "gives reward to the best answer's author" do
      reward = create(:reward, question: question)
      another_answer.select_best!

      expect(another_answer.author.rewards.first).to eq(reward)
    end
  end
end
