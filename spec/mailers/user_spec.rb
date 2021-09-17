require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "status_change_notifier" do
    let(:mail){ UserMailer.with(user: FactoryBot.build(:archived_user)).status_change_notifier }

    it "renders the headers" do
      expect(mail.subject).to eq("Your profile status has been changed.")
      expect(mail.from).to eq(["noreply@staffomatic.com"])
    end
  end
end
