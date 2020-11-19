require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:another_question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }
  let!(:reward) { create(:reward, question: question, user: user) }
  let!(:another_reward) { create(:reward, question: another_question, user: user) }

  describe '#GET index' do
    context 'Authenticated user' do
      before do
        login(user)
        get :index
      end

      it 'assigns rewards to an array of rewards' do
        expect(assigns(:rewards).should match_array(user.rewards))
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Unauthenticated user cannot view rewards' do
      before { get :index }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end
end
