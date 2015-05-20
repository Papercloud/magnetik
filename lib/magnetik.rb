require "magnetik/engine"
require 'responders'

module Magnetik

  # Method to authenticate a user:
  mattr_accessor :authentication_method
  @@authentication_method = nil

  # Method to retrieve the current authenticated user:
  mattr_accessor :current_user_method
  @@current_user_method = nil

  private

  # Default way to setup Magnetik:
  def self.setup
    yield self
  end
end
