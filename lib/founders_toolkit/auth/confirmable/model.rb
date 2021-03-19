# frozen_string_literal: true

module FoundersToolkit::Auth::Confirmable::Model
  extend ActiveSupport::Concern

  included do
    include FoundersToolkit::Auth::Emailable::Model

    has_secure_token :confirmation_token
    after_create :send_confirmation_email
  end

  def self.confirm!(token)
    find_by(token: token)&.confirm!
  end

  def confirm!
    update(confirmed: true, confirmation_token: nil)
  end
end
