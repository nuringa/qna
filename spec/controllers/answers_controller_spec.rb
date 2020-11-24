require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  it_behaves_like 'voted' do
    let(:model) { create :answer, author: user }
  end

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

    context 'with valid attributes' do
      let(:valid_params) { { id: answer.id, answer: { body: 'new body' }, format: :js } }

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

      it 'returns a forbidden flash message' do
        patch :update, params: valid_params
        expect(flash[:danger]).to include('Action not allowed')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

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

      it 'returns a forbidden flash message' do
        delete :destroy, params: valid_params
        expect(flash[:danger]).to include('Action not allowed')
      end
    end
  end

  describe 'PATCH #best' do
    let!(:another_question) { create(:question, author: another_user) }
    let(:another_answer) { create(:answer, question: another_question, author: another_user) }

    before { login(user) }

    it 'assigns answer to @answer' do
      patch :best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    context 'Authenticated user author of the question' do
      it 'selects the best question' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context 'Not author of the question' do
      before { patch :best, params: { id: another_answer }, format: :js}

      it "unable to select best answer" do
        expect(another_answer.best).to be false
      end

      it "gets a forbidden flash message" do
        expect(flash[:danger]).to eq 'Action not allowed'
      end
    end
  end
end
