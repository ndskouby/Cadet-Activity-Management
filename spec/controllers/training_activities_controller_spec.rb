require 'rails_helper'

RSpec.describe TrainingActivitiesController, type: :controller do
  before(:each) do
    @user = create(:user)
    session[:user_id] = @user.id
  end
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      training_activity = create(:training_activity)
      get :show, params: { id: training_activity.id }
      expect(response).to be_successful
    end

    it 'renders the show template' do
      training_activity = create(:training_activity)
      get :show, params: { id: training_activity.id }
      expect(response).to render_template('show')
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      training_activity = create(:training_activity)
      get :edit, params: { id: training_activity.id }
      expect(response).to be_successful
    end

    it 'renders the edit template' do
      training_activity = create(:training_activity)
      get :edit, params: { id: training_activity.id }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new training activity' do
        expect do
          post :create, params: { training_activity: attributes_for(:training_activity) }
        end.to change(TrainingActivity, :count).by(1)
      end

      it 'redirects to the created training activity' do
        post :create, params: { training_activity: attributes_for(:training_activity) }
        expect(response).to redirect_to(TrainingActivity.last)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { name: nil } }

      it 'does not create a new training activity' do
        expect do
          post :create, params: { training_activity: attributes_for(:training_activity, name: nil) }
        end.to_not change(TrainingActivity, :count)
      end

      it 're-renders the new template with errors' do
        post :create, params: { training_activity: attributes_for(:training_activity, name: nil) }
        expect(response).to render_template('new')
        expect(assigns(:training_activity).errors).to_not be_empty
        expect(assigns(:training_activity).errors.full_messages).to include("Name Activity Name can't be blank.")
      end

      it 'attempts to set competency_ids and filters out blank values' do
        competencies = [
          create(:competency),
          create(:competency)
        ]
        competency_ids = competencies.map(&:id) << ''
        expect do
          post :create,
               params: { training_activity: attributes_for(:training_activity, name: nil,
                                                                               competency_ids:) }

          training_activity = assigns(:training_activity)
          expect(training_activity.competency_ids).to match_array(competencies.map(&:id))
        end
      end
    end

    describe 'PATCH #update' do
      before(:each) do
        @training_activity = create(:training_activity)
      end
      context 'with valid attributes' do
        it 'updates the requested training activity' do
          patch :update,
                params: { id: @training_activity.id,
                          training_activity: attributes_for(:training_activity, name: 'New Name') }
          @training_activity.reload
          expect(@training_activity.name).to eq('New Name')
        end

        it 'redirects to the training activity' do
          patch :update,
                params: { id: @training_activity.id, training_activity: attributes_for(:training_activity) }
          expect(response).to redirect_to(@training_activity)
        end
      end

      context 'with invalid attributes' do
        it 'does not update the training activity' do
          patch :update,
                params: { id: @training_activity.id,
                          training_activity: attributes_for(:training_activity, name: nil) }
          @training_activity.reload
          expect(@training_activity.name).to_not eq(nil)
        end

        it 're-renders the edit method' do
          patch :update,
                params: { id: @training_activity.id,
                          training_activity: attributes_for(:training_activity, name: nil) }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested training activity' do
        training_activity = create(:training_activity)
        expect do
          delete :destroy, params: { id: training_activity.id }
        end.to change(TrainingActivity, :count).by(-1)
      end

      it 'redirects to the training activities list' do
        training_activity = create(:training_activity)
        delete :destroy, params: { id: training_activity.id }
        expect(response).to redirect_to(training_activities_url)
      end
    end
  end
end
