require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    let(:valid_params) { { question_id: question.id, format: :js, answer: attributes_for(:answer) } }

    context 'with valid attributes' do
      it 'saves a new answer to question answers' do
        expect { post :create, params: valid_params }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: valid_params
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { { question_id: question.id, format: :js, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the answer to database' do
        expect { post :create, params: invalid_params }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: invalid_params
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, author: question.author) }

    context 'with valid attributes' do
      let(:valid_params) { { id: answer, answer: { body: 'new body' }, format: :js } }

      it 'changes answer attributes' do
        patch :update, params: valid_params
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view after save' do
        patch :update, params: valid_params
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { { id: answer, answer: attributes_for(:answer, :invalid) , format: :js } }

      it 'does not change answer attributes' do
        expect { patch :update, params: invalid_params }.to_not change(answer, :body)
      end

      it 'renders update view after saving attempt' do
        patch :update, params: invalid_params
        expect(response).to render_template :update
      end
    end

    context 'not author of the answer tries to update it' do
      before { login(another_user) }

      let(:valid_params) { { id: answer, answer: { body: 'new body' }, format: :js } }

      it 'does not change answer attributes' do
        expect { patch :update, params: valid_params }.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: valid_params
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, author: user, question: question) }
    let(:valid_params) { { id: answer, format: :js } }

    context 'Authenticated user, the author of the answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: valid_params }.to change(Answer, :count).by(-1)
      end

      it 'creates a destroy flash message' do
        delete :destroy, params: valid_params
        expect(flash[:danger]).to include('Your answer was deleted.')
      end

      it 'renders destroy view after deleting', js: true do
        delete :destroy, params: valid_params
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated user, not author of the answer' do
      before { login(another_user) }

      it 'can not delete the answer' do
        expect { delete :destroy, params: valid_params }.to_not change(Question, :count)
      end

      it 'returns forbidden status response' do
        delete :destroy, params: valid_params
        expect(flash[:danger]).to include('Action not allowed')
      end
    end
  end
end
