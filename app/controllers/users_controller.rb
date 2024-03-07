# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    if current_user
      @user = User.find(params[:id])
    else
      redirect_to home_path, alert: 'You must be logged in to access this section.'
    end
  end
end
