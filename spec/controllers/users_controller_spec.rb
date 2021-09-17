require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'PUT /archive' do
    let(:user){ FactoryBot.create(:user) }

    context 'with unauthorized user' do
      it 'returns unauthorized response' do
        request.headers['Authentication'] = "Bearer UNKOWN_TOKEN"
        put :archive, params: { id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authorized user' do
      let(:active_user){ FactoryBot.create(:active_user) }

      before :each do
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'raise error on self update' do
        allow(User).to receive(:find).and_return(user)
        bypass_rescue
        expect {
          put :archive, params: { id: user }
        }.to raise_error(SUM::SelfStatusUpdateError)
      end

      it 'logs the activity' do
        allow(User).to receive(:find).and_return(active_user)
        expect(controller).to receive(:log_activity)
        put :archive, params: { id: active_user }
      end
    end
  end
end
