require 'ingest_roster_file'

class AdminController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]
    def index
        @users = User.all
    end

    def show
    end

    def new 
        @user = User.new
    end

    def destroy 
        @user.destroy
        redirect_to admin_url, notice: 'User was sucessfully deleted'
    end

    def update 
        if @user.update(user_params)
            redirect_to @user, notice: "User was successfully updated"
        else 
            render :edit
        end 
    end

    def edit
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|
            if @user.save
              handle_successful_save(format)
            else
              handle_failed_save(format)
            end
        end
    end

    def set_user 
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :unit_id)
    end
end
