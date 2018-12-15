class ArrivalMailer < ApplicationMailer
  def send_when_create(user)
    @user = user #メールの文面用のインスタンス変数
    mail to:      user.email,
          subject: '【and’s jam】新着メッセージがあります'
  end
end
