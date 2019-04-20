# image_firstというmoduleを定義「画像優先モジュール」
module Common
  # ActiveSupportのConcernを取り込む
  extend ActiveSupport::Concern

  # includedに渡したブロックがmoduleのinclude先で利用出来るようにする
  included do
    # helper_methodにhugaを渡す
    helper_method :image_first
  end

  # image_firstメソッドを定義
  def image_first(array,all_id,user_id_A,user_id_B)
    array.each do |i|
      all_id << i.id
    end

    user_all = array.count
    count_up = 0

      user_all.times do
        x = User.find(all_id[count_up])
        if x.profile_picture.attached?
        user_id_A << x.id
        else
          user_id_B << x.id
        end
        count_up = count_up + 1
    end

    user_id_A.push(user_id_B)
    user_id_A.flatten!
  end
end