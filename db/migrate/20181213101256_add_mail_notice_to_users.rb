class AddMailNoticeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users,:mail_notice,:integer,default: 1
  end
end
