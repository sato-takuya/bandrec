class TopController < ApplicationController
    before_action :searchval,only: [:search] #検索に「検索バリデーション」を実行する
    include Common

  def authenticate
    redirect_to new_user_registration_url unless user_signed_in?
  end

  def prereg
    if current_user
      render "top/prereg"
    else
    redirect_to :new_user_registration
    end
  end

  def privacy_policy #プライバシーポリシーへ
  end

  def inquiry #お問い合わせ画面へ
  end

  def index
    all_id = []
    user_id_A =[]
    user_id_B =[]
    if current_user #ユーザーがログインしている場合
      if current_user.user_type != nil #ユーザータイプがnilでない場合
        #自分と非表示設定の人以外を登録が新しい順に取得して、配列 @array へ
        @array = User.with_attached_profile_picture.where.not(id: current_user.id).where.not(user_type: 3).order(created_at: "DESC")

        image_first(@array,all_id,user_id_A,user_id_B) #画像優先モジュール
        @users = User.with_attached_profile_picture.where(id: user_id_A).order_as_specified(id: user_id_A).page(params[:page]).per(6)
        #メモ：.order_as_specified は、whereで検索した際に、指定の順番通りにデータを取得する
      else #ユーザータイプがnilの場合は、プロフィール編集画面へ(ユーザータイプを登録してくださいね！)
        redirect_to profile_edit_path
      end
    else #ユーザーがログインしていない場合(初見の人)
      #非表示設定の人以外全てを登録が新しい順に取得して、配列 @array へ
      @array = User.with_attached_profile_picture.where.not(user_type: 3).order(created_at: "DESC")
      image_first(@array,all_id,user_id_A,user_id_B) #画像優先モジュール
      @users = User.with_attached_profile_picture.where(id: user_id_A).order_as_specified(id: user_id_A).page(params[:page]).per(6)
    end
  end

  def show
      @user = User.find(params[:id])
      #以下、メッセージ用
      if current_user
        @currentUserEntry=Entry.where(user_id: current_user.id)#ログイン中のユーザーのエントリーのインスタンス
        @userEntry=Entry.where(user_id: @user.id)#クリックしたユーザー(相手)のエントリーのインスタンス

        @currentUserEntry.each do |cu|#ログイン中のユーザーのエントリーのインスタンスを一つずつcuに
          @userEntry.each do |u|#クリックしたユーザーのエントリーのインスタンスを一つずつuに
            if cu.room_id == u.room_id then#同じルームに入っていたら
              @isRoom = true #isRoomをtrueに
              @roomId = cu.room_id #roomIDはログイン中のユーザーのエントリーのroom_id
            end
          end
      end
      if @isRoom #同じルームに入っていたら飛ばす
      else #同じルームに入っていなかったら(初めて)、ルームインスタンスとエントリーインスタンスを作る
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

    def searchcondition#検索条件
      if current_user
        if current_user.user_type == nil
          redirect_to profile_edit_path
        end
      else
        redirect_to :new_user_registration
      end
    end

  def searchval #検索バリデーション
    if params[:user_type] == nil
      flash[:notice] = "「加入希望の人を探す」「メンバーを募集している人を探す」のどちらかにチェックを入れてください"
      redirect_to :action => "searchcondition"
    end
    if params[:candidate] == nil
      flash[:notice] = "楽器パートは1つ以上チェックを入れてください"
      redirect_to :action => "searchcondition"
    end

    #if params[:user_type].to_s  == "1"
     # if params[:job] == nil
      #  flash[:notice] = "職業は1つ以上チェックを入れてください"
       # redirect_to :action => "searchcondition"
      #end
      #if params[:future] == nil
      #  flash[:notice] = "方向性は1つ以上チェックを入れてください"
      #  redirect_to :action => "searchcondition"
      #end
      if params[:gender] == nil
        flash[:notice] = "性別は1つ以上チェックを入れてください"
        redirect_to :action => "searchcondition"
      end
    #end
  end

  def search
    k = []#一時的カウント用配列
    kk = []#楽器が該当するuserのidを格納する配列


    #if params[:band_type] != nil
    #  array_band = params[:band_type][:id].map(&:to_i)
    #end

    #if params[:song_type] != nil
    #  array_song = params[:song_type][:id].map(&:to_i)
    #end

    if params[:gender] != nil
      array_gender = params[:gender][:id].map(&:to_i)
    end

    #if params[:job] != nil
    #  array_job = params[:job][:id].map(&:to_i)
    #end

    array_inst = params[:candidate][:id].map(&:to_i)
    #array_future = params[:future][:id].map(&:to_i)


    insts = Instrument.where(part: array_inst)#選ばれた楽器のオブジェクトを配列に

    insts.each do |inst|
      k << inst.user_id
    end

    kk = k.uniq#重複を消す

    #年齢
    array_age =[]
    as = params[:age_start].to_i
    ae = params[:age_end].to_i


    bi = User.with_attached_profile_picture.all

    bi.each do |i|
      date_format = "%Y%m%d"
      if i.birthday != nil
        x  = (Date.today.strftime(date_format).to_i - i.birthday.strftime(date_format).to_i) / 10000
        if x >= as and x <= ae
          array_age << i.birthday
        end
      end
    end

    if params[:user_type].to_s == "1" #加入希望を探す場合

    #削減のためバンドタイプなどを削除しました
    if current_user
        if params[:order].to_s == "1"
          @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).age(array_age).info(params[:info]).where.not(id: current_user.id).order(current_sign_in_at: :desc).page(params[:page])
        else
          @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).age(array_age).info(params[:info]).where.not(id: current_user.id).order(created_at: :desc).page(params[:page])
        end
      else
        if params[:order].to_s == "1"
          @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).age(array_age).info(params[:info]).order(current_sign_in_at: :desc).page(params[:page])
        else
          @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).age(array_age).info(params[:info]).order(created_at: :desc).page(params[:page])
        end
      end
    end

    if params[:user_type].to_s == "2" #メンバー募集を探す場合
      if current_user
          if params[:order].to_s == "1"
            @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).info(params[:info]).where.not(id: current_user.id).order(current_sign_in_at: :desc).page(params[:page])
          else
            @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).info(params[:info]).where.not(id: current_user.id).order(created_at: :desc).page(params[:page])
        end
      else
        if params[:order].to_s == "1"
            @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).info(params[:info]).order(current_sign_in_at: :desc).page(params[:page])
          else
            @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).info(params[:info]).order(created_at: :desc).page(params[:page])
        end
      end
    end
  end
end
