# frozen_string_literal: true

module FoundersToolkit::Auth::Securable::Model
  extend ActiveSupport::Concern

  included do
    include FoundersToolkit::Auth::Emailable::Model

    has_secure_password
  end
end
