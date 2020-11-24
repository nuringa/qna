require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:model) { create(described_class.to_s.downcase.to_sym) }
  let(:votable) { create(model.to_s.underscore.to_sym, author: user) }

  it { should have_many(:votes).dependent(:destroy) }

  context '#vote_up' do
    it 'not as an author of resource' do
      model.vote_up(user)
      model.reload

      expect(model.rating).to eq(1)
    end

    it 'as an author of resource' do
      model.vote_up(model.author)
      model.reload

      expect(model.rating).to eq(0)
    end
  end

  context '#vote_down' do
    it 'not as an author of resource' do
      model.vote_down(user)
      model.reload

      expect(model.rating).to eq(-1)
    end

    it 'as an author of resource' do
      model.vote_down(model.author)
      model.reload

      expect(model.rating).to eq(0)
    end
  end

  context '#cancel_vote' do
    it 'sets rate to 0' do
      model.vote_up(user)
      model.reload
      model.cancel_vote(user)
      model.reload

      expect(model.rating).to eq(0)
    end
  end

  context 'calculates multiple rates' do
    it '#rating' do
      model.vote_up(user)
      model.vote_up(another_user)
      model.reload

      expect(model.rating).to eq(2)
    end
  end
end
