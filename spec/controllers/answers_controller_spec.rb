require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:another_user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to question answers in database' do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer to database' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        end.to_not change(Answer, :count)
      end

      it 're-renders question show with new answer form view ' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'Authenticated user, the author of the answer' do

      let!(:answer) { create(:answer, author: user, question: question) }

      it 'deletes the answer ' do
        expect { delete :destroy, params: { use_route: 'questions/answers/', id: answer.id } }.to change(Answer, :count).by(-1)
      end

      it 'gets question show page after deleting' do
        delete :destroy, params: { use_route: 'questions/answers/', id: answer.id }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'Authenticated user, not author of the answer' do
      before { login(another_user) }

      it 'can not delete the answer' do
        expect { delete :destroy, params: { use_route: 'questions/answers/', id: answer.id } }.to_not change(Question, :count)
      end

      it 'gets question show page after not deleting' do
        delete :destroy, params: { use_route: 'questions/answers/', id: answer.id }

        expect(response).to render_template 'questions/show'
      end
    end
  end
end
