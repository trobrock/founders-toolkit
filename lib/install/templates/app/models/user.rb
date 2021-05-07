# frozen_string_literal: true

class User < ApplicationRecord
  include FoundersToolkit::Auth::Securable::Model
  include FoundersToolkit::Auth::Recoverable::Model
end
