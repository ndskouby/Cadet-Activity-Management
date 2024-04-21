require 'rails_helper'

RSpec.describe TrainingActivitiesMailer, type: :mailer do
  describe 'pending_approval_notification' do
    let(:user) { FactoryBot.create(:user) }
    let(:training_activity) { FactoryBot.create(:training_activity, user:) }
    let(:mail) { described_class.pending_approval_notification(training_activity, user).deliver_now }

    it 'renders the headers' do
      expect(mail.subject).to eq('Training Activity Pending Your Approval')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(training_activity.name)
    end
  end

  describe 'revision_notification' do
    let(:training_activity) { FactoryBot.create(:training_activity) }
    let(:mail) { described_class.revision_notification(training_activity).deliver_now }

    it 'renders the headers' do
      expect(mail.subject).to eq('Training Activity Needs Your Revision')
      expect(mail.to).to eq([training_activity.user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('requires revision')
    end
  end

  describe 'rejected_notification' do
    let(:training_activity) { FactoryBot.create(:training_activity) }
    let(:mail) { described_class.rejected_notification(training_activity).deliver_now }

    it 'renders the headers' do
      expect(mail.subject).to eq('Training Activity Rejected')
      expect(mail.to).to eq([training_activity.user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('has been rejected')
    end
  end
end
