class ApplicationController < ActionController::Base

  before_action :configure_account_update_params, only:[:profile_update]
  before_action :configure_permitted_parameters,if: :devise_controller?
  protect_from_forgery with: :exception


  #herokuapp.comから独自ドメインへリダイレクト
  before_filter :ensure_domain
  FQDN = 'www.anzujam.net'

  # redirect correct server from herokuapp domain for SEO
  def ensure_domain
   return unless /\.bandrec.net/ =~ request.host

   # 主にlocalテスト用の対策80と443以外でアクセスされた場合ポート番号をURLに含める
   port = ":#{request.port}" unless [80, 443].include?(request.port)
   redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end





  def after_sign_out_path_for(resource)
    '/users/sign_in' # サインアウト後のリダイレクト先URL
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:area])
  end

end
