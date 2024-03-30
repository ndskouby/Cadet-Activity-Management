# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    return unless logged_in?

    redirect_to dashboard_path
  end
end
