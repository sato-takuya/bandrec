class ApplicationController < ActionController::Base
  before_action :configure_account_update_params, only:[:profile_update]
  before_action :configure_permitted_parameters,if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_out_path_for(resource)
    '/users/sign_in' # サインアウト後のリダイレクト先URL
  end


  def configure_permitted_parameters#パラメーター許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:area])
  end
end
