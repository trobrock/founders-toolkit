# frozen_string_literal: true

module FoundersToolkit::Auth::Recoverable::Model
  extend ActiveSupport::Concern

  included do
    before_save :clear_reset_password_token, if: :password_digest_changed?
  end

  def generate_reset_password_token!
    update(reset_password_token: self.class.generate_unique_secure_token)
  end

  def clear_reset_password_token
    self.reset_password_token = nil
  end
end
