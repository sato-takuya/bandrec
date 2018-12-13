class ArrivalMailer < ApplicationMailer
  def send_when_create(user)
    @user = user #メールの文面用のインスタンス変数
    mail to:      user.email,
          subject: '【anzujam】新着メッセージがあります'
  end
end
