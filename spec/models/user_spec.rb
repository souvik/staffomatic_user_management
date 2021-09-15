require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      email: 'daniel@example.com',
      password: 'someweiredpassword',
      password_confirmation: 'someweiredpassword',
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'is not be valid without matching password' do
    subject.password = 'someweiredpassword!!'
    subject.password_confirmation = 'someweiredpassword'
    expect(subject).to_not be_valid
  end

  describe '#update_status_by_action' do
    let(:logged_in_user){ FactoryBot.create(:user) }

    it 'raises error during self update' do
      expect {
        logged_in_user.update_status_by_action('archive', logged_in_user)
      }.to raise_error(SUM::SelfStatusUpdateError)
    end

    context 'while archiving' do
      it 'raises error if user is not in active state' do
        expect {
          FactoryBot.create(:archived_user).update_status_by_action('archive', logged_in_user)
        }.to raise_error(SUM::DesireStatusError)
      end

      it 'updates status from active to archived' do
        user = FactoryBot.create(:active_user)
        expect {
          user.update_status_by_action('archive', logged_in_user)
        }.to change(user, :status).from('active').to('archived')
      end
    end

    context 'while unarchiving' do
      it 'raises error if user is not in archived state' do
        expect {
          FactoryBot.create(:deleted_user).update_status_by_action('unarchive', logged_in_user)
        }.to raise_error(SUM::DesireStatusError)
      end

      it 'updates status from active to archived' do
        user = FactoryBot.create(:archived_user)
        expect {
          user.update_status_by_action('unarchive', logged_in_user)
        }.to change(user, :status).from('archived').to('active')
      end
    end

    context 'while deleting' do
      it 'raises error if user is in deleted state' do
        expect {
          FactoryBot.create(:deleted_user).update_status_by_action('destroy', logged_in_user)
        }.to raise_error(SUM::DesireStatusError)
      end

      it 'updates status from active to deleted' do
        user = FactoryBot.create(:active_user)
        expect {
          user.update_status_by_action('destroy', logged_in_user)
        }.to change(user, :status).from('active').to('deleted')
      end

      it 'updates status from archived to deleted' do
        user = FactoryBot.create(:archived_user)
        expect {
          user.update_status_by_action('destroy', logged_in_user)
        }.to change(user, :status).from('archived').to('deleted')
      end
    end
  end
end
