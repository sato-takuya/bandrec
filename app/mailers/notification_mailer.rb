class NotificationMailer < ApplicationMailer
  # デフォルトでの送信元のアドレス

  def hello(name)
    @name = name
    mail(
      # TOは単体のメールアドレスでもArrayのメールアドレスでも大丈夫
      to:      'stakuya6@gmail.com',
      subject: 'Mail from Message',
    ) do |format|
      format.html
    end
  end
end