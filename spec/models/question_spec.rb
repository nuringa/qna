require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for(:links).allow_destroy(true) }

  it { should validate_presence_of :title}
  it { should validate_presence_of :body}

  it 'can have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#reward_for_best_answer?' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:another_answer) { create(:answer, question: question, author: user) }
    let!(:reward) { create(:reward, user: user) }

    it 'should return a reward for the best answer of the question' do
      answer.update!(best: true)
      reward.update!(question: question)

      expect(question.reward_for_best_answer).to eq reward
    end

    it 'should return nil if there is no best answer yet' do
      expect(question.reward_for_best_answer).to eq nil
    end

    it 'should return nil if question has no reward for best answer' do
      expect(question.reward_for_best_answer).to eq nil
    end
  end
end
