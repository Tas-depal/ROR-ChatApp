# frozen_string_literal: true

# Logins controller
class LoginsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email], password_digest: params[:password_digest])
    if @user
      log_in(@user)
    else
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
