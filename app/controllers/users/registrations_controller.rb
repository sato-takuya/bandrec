# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController


  def profile_edit
  end


  def profile_update
    current_user.assign_attributes(account_update_params)

    @arrays = Instrument.where(user_id: current_user.id)
    exs = []

    @arrays.each do |array|
      exs << array.part
    end

    exs = exs.to_s

    params[:gakki].each do | i1,i2 |
      if i2 == "0" && exs.include?(i1) == true#チェックなし、すでにあり→削除
        @inst = Instrument.where(user_id: current_user.id).find_by(part: i1)
        @inst.destroy
      elsif i2 == "1" && exs.include?(i1) == false#チェックあり、すでになし→追加
        @inst = Instrument.new(part: i1,user_id: current_user.id)
        @inst.save
      #next if i2 == "1" && exs.include?(i1) == true#チェックあり、すでにあり→パス
      #next if i2 == "0" && exs.include?(i1) == false#チェックなし、すでになし→パス
      end
    end

    if current_user.save
      flash[:notice] = "プロフィールを更新しました"
      redirect_to "/"
    else
      render "profile_edit"
    end
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_type])
    devise_parameter_sanitizer.permit(:account_update, keys: [:birthday])
    devise_parameter_sanitizer.permit(:account_update, keys: [:area])
    devise_parameter_sanitizer.permit(:account_update, keys: [:gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:job])
    devise_parameter_sanitizer.permit(:account_update, keys: [:future])
    devise_parameter_sanitizer.permit(:account_update, keys: [:info])
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_picture])
    devise_parameter_sanitizer.permit(:account_update, keys: [:sound_source])
    devise_parameter_sanitizer.permit(:account_update, keys: [:part])
    devise_parameter_sanitizer.permit(:account_update, keys: [:band_type])
    devise_parameter_sanitizer.permit(:account_update, keys: [:song_type])
  end

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
