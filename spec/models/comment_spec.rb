require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :author }

  it { should validate_presence_of :body }

  describe '#commentable' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:comment) { question.comments.create(author: user) }

    it 'return commented object' do
      expect(comment.commentable).to eq question
    end
  end
end
