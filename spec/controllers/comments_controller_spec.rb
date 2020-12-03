require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:comment) { create(:comment, commentable: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment for question in the database' do
        expect { post :create, params: {question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(question.comments, :count).by(1)
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(user.comments, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js }.not_to change(question.comments, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
