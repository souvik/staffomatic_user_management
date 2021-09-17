require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  subject do
    described_class.new(
      user: FactoryBot.create(:user),
      performed_action: '/some/path',
      action_method: 'GET',
      payload: '{}'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without performed_action' do
    subject.performed_action = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without action_method' do
    subject.action_method = nil
    expect(subject).to_not be_valid
  end
end
