# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authorize

  protected

  def authorize
    if not User.find_by(id: session[:user_id])
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
