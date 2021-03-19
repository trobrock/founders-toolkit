# frozen_string_literal: true

module FoundersToolkit::Auth::Securable::Controller
  extend ActiveSupport::Concern

  included do
    before_action :redirect_if_set
    before_action :set_current_user
    before_action :authenticate
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  private

  def redirect_if_set
    return unless session[:redirect_to]

    path = session.delete(:redirect_to)
    redirect_to path
  end

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate
    return if Current.user.present?

    session[:redirect_to] = request.env['PATH_INFO']
    redirect_to new_session_path
  end
end
