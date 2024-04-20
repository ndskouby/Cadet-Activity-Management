class AdminController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]

    def index
      @users = User.all
      
      # Search functionality
      if params[:search]
        @users = @users.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
      end
    end
  
    def show
    end
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_index_url, notice: 'User was successfully created'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @user.update(user_params)
        redirect_to admin_index_url, notice: 'User was successfully updated'
      else
        render :edit
      end
    end
  
    def destroy
      @user.destroy
      redirect_to admin_index_url, notice: 'User was successfully deleted'
    end
    
    def import 
      file = params[:file]
      return redirect_to admin_index_path, alert: "No file uploaded" if file == nil
      return redirect_to admin_index_path, alert: "File not a CSV" unless file.content_type == "text/csv" 
      errors = IngestRosterFile.new.ingest_roster_file(file)
      if not errors.empty?
        redirect_to admin_index_path, notice: "Users Imported", alert: errors
      else
        redirect_to admin_index_path, notice: "Users Imported"
      end
    end
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      # Set teh default provider to google
      params[:user][:provider] ||= "google_oauth2"
      params.require(:user).permit(:first_name, :last_name, :email, :unit_id, :provider)
    end
  end
  