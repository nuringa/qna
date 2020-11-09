require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { login(user) }

  describe 'DELETE #destroy' do
    describe 'question' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'test-file.txt')
      end

      context 'Authenticated user an author of the question' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Authenticated user not an author of the question' do
        before { login(another_user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.not_to change(question.files, :count)
        end

        it 'gets a forbidden status response' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response.status).to eq(403)
        end
      end
    end

    describe 'answer' do
      let(:answer) { create(:answer, question: question, author: user) }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'test-file.txt')
      end

      context 'Authenticated user an author of the answer' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Authenticated user not an author of the answer' do
        before { login(another_user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.not_to change(answer.files, :count)
        end

        it 'gets a forbidden status response' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response.status).to eq(403)
        end
      end
    end
  end
end
