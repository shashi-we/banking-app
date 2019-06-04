class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  include DeviseWhitelist

  private 

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end  
end
