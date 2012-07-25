class ApplicationController < ActionController::Base
  protect_from_forgery

  include UsersHelper

  $application_name = "soclbiz"
end
