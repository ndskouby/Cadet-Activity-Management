require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  before(:each) do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "assigns all users as @users" do
      user = create(:user)
      get :index
      expect(assigns(:users)).to include(user)
    end

    context "with search parameter" do
      it "filters users by search query" do
        user1 = create(:user, first_name: "Apple")
        user2 = create(:user, last_name: "Doe")
        get :index, params: { search: "Apple" }
        expect(assigns(:users)).to eq([user1])
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested user as @user" do
      user = create(:user)
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET #new" do
    it "assigns a new user as @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new user" do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(admin_index_url)
      end
    end

    context "with invalid params" do
      it "does not save the new user" do
        expect {
          post :create, params: { user: attributes_for(:user, first_name: nil) }
        }.to_not change(User, :count)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user: attributes_for(:user, first_name: nil) }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }

    context "with valid params" do
      it "updates the requested user" do
        put :update, params: { id: user.to_param, user: { first_name: "New Name" } }
        user.reload
        expect(user.first_name).to eq("New Name")
      end

      it "redirects to the user" do
        put :update, params: { id: user.to_param, user: { first_name: "New Name" } }
        expect(response).to redirect_to(admin_index_url)
      end
    end

    context "with invalid params" do
      it "does not update the user" do
        put :update, params: { id: user.to_param, user: { first_name: nil } }
        user.reload
        expect(user.first_name).to_not eq(nil)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: user.to_param, user: { first_name: nil } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }

    it "destroys the requested user" do
      expect {
        delete :destroy, params: { id: user.to_param }
      }.to change(User, :count).by(-1)
    end

    it "redirects to the admin index" do
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(admin_index_url)
    end
  end

  describe "POST #import" do
    context "with valid file" do
      it "imports users" do
        valid_file = fixture_file_upload('demoCorpsRoster.csv', 'text/csv')
        post :import, params: { file: valid_file }
        expect(response).to redirect_to(admin_index_url)
        expect(flash[:notice]).to eq("Users Imported")
      end
    end

    context "with invalid file" do
      it "does not import users and redirects with alert" do
        invalid_file = fixture_file_upload('sample.txt', 'text/plain')
        post :import, params: { file: invalid_file }
        expect(response).to redirect_to(admin_index_url)
        expect(flash[:alert]).to eq("File not a CSV")
      end
    end

    context "with duplicate imports" do
      it "should show an alert" do 
        valid_file = fixture_file_upload('demoCorpsRoster.csv', 'text/csv')
        post :import, params: { file: valid_file }
        # Import twice for duplicates
        post :import, params: { file: valid_file }
        expect(flash[:alert]).to include("User with email a@a.com already exists.")
      end
    end
  end
end

