require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:comments).with_foreign_key('author_id').dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user_author) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: user_author) }
    let(:answer) { create(:answer, author: user_author) }

    it 'should return true if user is author of the question' do
      expect(user_author.author_of?(question)).to be true
    end

    it 'should return true if user is author of the answer' do
      expect(user_author.author_of?(answer)).to be true
    end

    it 'should return false if user is not author of the question' do
      expect(another_user.author_of?(question)).to be false
    end

    it 'should return false if user is not author of the answer' do
      expect(another_user.author_of?(answer)).to be false
    end
  end
end
