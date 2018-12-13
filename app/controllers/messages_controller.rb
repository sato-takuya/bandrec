class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      @send_entry = Entry.where(room_id: @message.room_id).where.not(user_id: current_user.id)
      @send_id = @send_entry.first.user_id #メールを送る相手のユーザーid
      @send_user = User.find(@send_id) #送る相手のインスタンス

      send_ok = @send_user.mail_notice.to_i

      if send_ok == 1 #送付相手のメール通知許可の数値
          ArrivalMailer.send_when_create(@send_user).deliver
      end

      redirect_to "/rooms/#{@message.room_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end
end