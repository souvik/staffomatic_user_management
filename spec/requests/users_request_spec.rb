require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) do
    User.create(
      email: 'danie@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
    )
  end

  describe 'GET /index' do
    it 'returns http success' do
      auth_token = authenticate_user(user)
      get users_path, headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT /archive' do
    let(:auth_token) { authenticate_user(user) }

    context 'with unauthorized requester' do
      it 'returns unauthorized response' do
        put archive_user_path(user), headers: { 'Authentication': "Bearer UNKOWN_TOKEN" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'while self-archiving' do
      it 'returns http error' do
        put archive_user_path(user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        put archive_user_path(user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response.body).to include('Cannot archive/unarchive yourself')
      end
    end

    context 'with non-exists user' do
      it 'returns http error' do
        put archive_user_path('unknown-id'), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with existing active user' do
      let(:random_user) { FactoryBot.create(:random_user) }

      it 'returns http success' do
        put archive_user_path(random_user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:success)
      end

      it 'change user status' do
        expect{
          put archive_user_path(random_user), headers: { "Authentication" => "Bearer #{auth_token}" }
          random_user.reload
        }.to change(random_user, :status).from('active').to('archived')
      end
    end

    context 'with archived user' do
      let(:archived_user){ FactoryBot.create(:archived_user) }

      it 'returns http error' do
        put archive_user_path(archived_user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'rerurns error message' do
        put archive_user_path(archived_user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response.body).to include('Provided user is not in active state')
      end
    end
  end

  describe 'PUT /unarchive' do
    let(:auth_token) { authenticate_user(user) }

    context 'with unauthorized requester' do
      it 'returns unauthorized response' do
        put unarchive_user_path(user), headers: { 'Authentication': "Bearer UNKOWN_TOKEN" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'while self-unarchiving' do
      it 'returns http error' do
        put unarchive_user_path(user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        put archive_user_path(user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response.body).to include('Cannot archive/unarchive yourself')
      end
    end

    context 'with non-exists user' do
      it 'returns http error' do
        put unarchive_user_path('unknown-id'), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with existing archived user' do
      let(:archived_user) { FactoryBot.create(:archived_user) }

      it 'returns http success' do
        put unarchive_user_path(archived_user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:success)
      end

      it 'change user status' do
        expect{
          put unarchive_user_path(archived_user), headers: { "Authentication" => "Bearer #{auth_token}" }
          archived_user.reload
        }.to change(archived_user, :status).from('archived').to('active')
      end
    end

    context 'with active user' do
      let(:active_user){ FactoryBot.create(:active_user) }

      it 'returns http error' do
        put unarchive_user_path(active_user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'rerurns error message' do
        put unarchive_user_path(active_user), headers: { "Authentication" => "Bearer #{auth_token}" }
        expect(response.body).to include('Provided user is not in archived state')
      end
    end
  end
end
