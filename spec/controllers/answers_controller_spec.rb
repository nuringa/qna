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
          post :create, params: { question_id: question.id, format: :js, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), format: :js, question_id: question.id }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), format: :js, question_id: question } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), format: :js, question_id: question }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: question.author) }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
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
