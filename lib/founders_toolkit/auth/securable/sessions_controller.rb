# frozen_string_literal: true

class FoundersToolkit::Auth::Securable::SessionsController < ApplicationController
  include FoundersToolkit::Auth::Securable::Controller

  skip_before_action :redirect_if_set
  before_action :authenticate, except: %i( new create )

  def new; end

  def create
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to after_login_path
    else
      redirect_to new_session_path, alert: 'We could not sign you in with those credentials.'
    end
  end

  def destroy
    reset_session
    redirect_to after_logout_path
  end

  private

  def after_login_path
    root_path
  end

  def after_logout_path
    root_path
  end
end
