class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Sign out for anti CSRF weakness
  def handle_unverified_request
    sign_out
    super
  end
end
