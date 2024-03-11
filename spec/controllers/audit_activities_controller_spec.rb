require 'rails_helper'

RSpec.describe AuditActivitiesController, type: :controller do
  before(:each) do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "assigns all training activities to @training_activities" do
      training_activity1 = create(:training_activity)
      training_activity2 = create(:training_activity)
      get :index
      expect(assigns(:training_activities)).to match_array([training_activity1, training_activity2])
    end
  end

  describe "GET #show" do
    it "assigns the requested training activity to @training_activity" do
      training_activity = create(:training_activity)
      get :show, params: { id: training_activity.id }
      expect(assigns(:training_activity)).to eq(training_activity)
    end

    it "orders the activity histories of the training activity by created_at in descending order" do
      training_activity = create(:training_activity)
      older_history = training_activity.activity_histories.create!(created_at: 1.day.ago, user: @user)
      newer_history = training_activity.activity_histories.create!(created_at: 1.hour.ago, user: @user)
      get :show, params: { id: training_activity.id }
      expect(assigns(:activity_histories)).to eq([newer_history, older_history])
    end
  end

  describe 'POST #approve' do
    let(:training_activity) { create(:training_activity, status: initial_status) }
    subject { post :approve, params: { id: training_activity.id }; training_activity.reload }

    context 'when status is pending_minor_unit_approval' do
      let(:initial_status) { 'pending_minor_unit_approval' }

      it 'approves the activity and redirects to major unit approval' do
        subject
        expect(training_activity.status).to eq 'pending_major_unit_approval'
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Approved.')
      end
    end

    context 'when status is pending_major_unit_approval' do
      let(:initial_status) { 'pending_major_unit_approval' }

      it 'approves the activity and redirects to commandant approval' do
        subject
        expect(training_activity.status).to eq 'pending_commandant_approval'
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Approved.')
      end
    end

    context 'when status is pending_commandant_approval' do
      let(:initial_status) { 'pending_commandant_approval' }

      it 'approves the activity and marks it as approved' do
        subject
        expect(training_activity.status).to eq 'approved'
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Approved.')
      end
    end
  end

  describe 'POST #improve' do
    let(:training_activity) { create(:training_activity, status: initial_status) }

    subject { post :improve, params: { id: training_activity.id }; training_activity.reload }

    context 'when status is pending_minor_unit_approval' do
      let(:initial_status) { 'pending_minor_unit_approval' }

      it 'requests submitter revision and redirects with notice' do
        subject
        expect(training_activity.status).to eq 'revision_required_by_submitter'
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Requested Revision for Training Activity.')
      end
    end

    context 'when status is pending_major_unit_approval' do
      let(:initial_status) { 'pending_major_unit_approval' }

      it 'requests minor unit revision and redirects with notice' do
        subject
        expect(training_activity.status).to eq 'revision_required_by_minor_unit'
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Requested Revision for Training Activity.')
      end
    end

    context 'when status is pending_commandant_approval' do
      let(:initial_status) { 'pending_commandant_approval' }

      it 'requests major unit revision and redirects with notice' do
        subject
        expect(training_activity.status).to eq 'revision_required_by_major_unit' # Assuming this is the intended status
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Requested Revision for Training Activity.')
      end
    end
  end

  describe 'POST #reject' do
    let!(:training_activity) { create(:training_activity, status: 'pending_minor_unit_approval') }
    subject { post :reject, params: { id: training_activity.id }; training_activity.reload }

    context 'when rejection is successful' do
      before do
        allow(training_activity).to receive(:reject!).and_return(true)
      end

      it 'rejects the activity and redirects with notice' do
        subject
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Rejected.')
      end
    end
  end

  describe 'POST #resubmit' do
    let(:training_activity) { create(:training_activity, status: initial_status, current_user: @user) }
    subject { post :resubmit, params: { id: training_activity.id } }

    context 'when status is revision_required_by_submitter' do
      let(:initial_status) { 'revision_required_by_submitter' }

      it 'resubmits for minor unit approval and redirects with notice' do
        subject
        expect(training_activity.reload.status).to eq('pending_minor_unit_approval')
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Resubmitted.')
      end
    end

    context 'when status is revision_required_by_minor_unit' do
      let(:initial_status) { 'revision_required_by_minor_unit' }

      it 'resubmits for major unit approval from minor unit revision and redirects with notice' do
        subject
        expect(training_activity.reload.status).to eq('pending_major_unit_approval')
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Resubmitted.')
      end
    end

    context 'when status is revision_required_by_major_unit' do
      let(:initial_status) { 'revision_required_by_major_unit' }

      it 'resubmits for commandant approval from major unit revision and redirects with notice' do
        subject
        expect(training_activity.reload.status).to eq('pending_commandant_approval')
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Resubmitted.')
      end
    end

    context 'when resubmission fails' do
      before do
        allow_any_instance_of(TrainingActivity).to receive(:submit_for_minor_unit_approval!).and_return(false)
      end
      let(:initial_status) { 'revision_required_by_submitter' }

      it 'fails to resubmit the activity and redirects with alert' do
        subject
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:alert]).to eq('Failed to resubmit Training Activity.')
      end
    end
  end

  describe 'POST #cancel' do
    let!(:training_activity) { create(:training_activity, status: 'pending_minor_unit_approval') }
    subject { post :cancel, params: { id: training_activity.id }; training_activity.reload }

    context 'when cancellation is successful' do
      before do
        allow(training_activity).to receive(:cancel!).and_return(true)
      end

      it 'cancels the activity and redirects with notice' do
        subject
        expect(response).to redirect_to(audit_activity_path(training_activity))
        expect(flash[:notice]).to eq('Training Activity Cancelled.')
      end
    end
  end

end
