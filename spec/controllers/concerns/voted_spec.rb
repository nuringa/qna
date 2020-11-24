require 'rails_helper'

shared_examples_for 'voted' do
  let(:user) { create :user }
  let(:another_user) { create :user }

  describe 'PATCH #vote_up' do
    it 'sends json response' do
      login(another_user)
      patch :vote_up, params: { id: model, format: :json }

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)['rating']).to eq(model.reload.rating)
    end

    it 'user can vote up' do
      login(another_user)

      expect do
        patch :vote_up, params: { id: model }, format: :json
      end.to change(Vote, :count).by 1
      expect(model.rating).to eq(1)
    end

    it "author's vote up for his own resource is not counted" do
      login(model.author)

      expect do
        patch :vote_up, params: { id: model }, format: :json
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end
  end

  describe 'PATCH #vote_down' do
    it 'sends json response' do
      login(another_user)
      patch :vote_down, params: { id: model, format: :json }

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)['rating']).to eq(model.reload.rating)
    end

    it 'user can vote down' do
      login(another_user)

      expect do
        patch :vote_down, params: { id: model }, format: :json
      end.to change(Vote, :count).by 1
      expect(model.rating).to eq(-1)
    end

    it "author's vote down for his own resource is not counted" do
      login(model.author)

      expect do
        patch :vote_down, params: { id: model }, format: :json
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end
  end

  describe 'PATCH #cancel_vote' do
    it 'sends json response' do
      login(another_user)
      patch :cancel_vote, params: { id: model, format: :json }

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)['rating']).to eq(model.reload.rating)
    end

    it 'user can cancel his up vote' do
      login(another_user)
      patch :vote_up, params: { id: model }, format: :json

      expect do
        (patch :cancel_vote, params: { id: model }, format: :json)
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end

    it 'author of resource can not cancel the vote' do
      login(model.author)
      patch :vote_up, params: { id: model }, format: :json

      expect do
        (patch :cancel_vote, params: { id: model }, format: :json)
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end
  end
end
