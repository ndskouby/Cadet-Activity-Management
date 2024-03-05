require 'rails_helper'

RSpec.describe AuditActivitiesController, type: :controller do
  before(:each) do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'POST #approve' do
    context 'when status is pending_minor_unit_approval' do
      it 'approves the activity and redirects' do
        @training_activity = create(:training_activity, status: :pending_minor_unit_approval)
        post :approve, params: { id: @training_activity.id }
        @training_activity.reload
        expect(@training_activity).to be_pending_major_unit_approval
        expect(response).to redirect_to(audit_activity_path(@training_activity))
        expect(flash[:notice]).to eq('Training Activity Approved.')
      end
    end
  end
end
