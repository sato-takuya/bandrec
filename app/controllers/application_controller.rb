class ApplicationController < ActionController::Base
  http_basic_authenticate_with :name => "takuya", :password => "takuya4645" if Rails.env == "production"
  before_action :configure_account_update_params, only:[:profile_update]
  before_action :configure_permitted_parameters,if: :devise_controller?


  def after_sign_out_path_for(resource)
    '/users/sign_in' # サインアウト後のリダイレクト先URL
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:birthday])
  end

end
