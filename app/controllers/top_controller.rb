class TopController < ApplicationController
  #before_action :authenticate_user!,only: [:searchcondition]
  before_action :searchval,only: [:search]
  #before_action :prereg ,only: [:show,:searchcondition]

  before_action :authenticate,except:[:about]

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

  def privacy_policy
  end

  def inquiry
  end

  def index
    if current_user
      @users = User.with_attached_profile_picture.where.not(id: current_user.id).where.not(user_type: 3).order(created_at: "DESC").page(params[:page]).per(12)
    else
      #@users = User.where.not(user_type: 3).order(created_at: "DESC").page(params[:page]).per(12)
      @array = User.with_attached_profile_picture.where.not(user_type: 3).order(created_at: "DESC")

      all_id=[]

      @array.each do |i|
        all_id << i.id
      end

      user_id_A =[]
      user_id_B =[]

      user_all = @array.count
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
      @users = User.with_attached_profile_picture.where(id: user_id_A).order_as_specified(id: user_id_A).page(params[:page]).per(12)



    end
  end


def show
    @user = User.find(params[:id])
    #以下、メッセージ用
    if current_user
    @currentUserEntry=Entry.where(user_id: current_user.id)#ログイン中のユーザーのエントリーのインスタンス
    @userEntry=Entry.where(user_id: @user.id)#クリックしたユーザーのエントリーのインスタンス

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

  def searchcondition
  end

  def searchval#検索バリデーション
    if params[:user_type] == nil
      flash[:notice] = "「加入希望」「メンバー募集」のどちらかにチェックを入れてください"
      redirect_to :action => "searchcondition"
    end
    if params[:candidate] == nil
      flash[:notice] = "楽器パートは1つ以上チェックを入れてください"
      redirect_to :action => "searchcondition"
    end

    if params[:user_type].to_s  == "1"
      if params[:job] == nil
        flash[:notice] = "職業は1つ以上チェックを入れてください"
        redirect_to :action => "searchcondition"
      end
      if params[:future] == nil
        flash[:notice] = "方向性は1つ以上チェックを入れてください"
        redirect_to :action => "searchcondition"
      end
      if params[:gender] == nil
        flash[:notice] = "性別は1つ以上チェックを入れてください"
        redirect_to :action => "searchcondition"
      end
    end
  end

  def search
    k = []#一時的カウント用配列
    kk = []#楽器が該当するuserのidを格納する配列


if params[:band_type] != nil
  array_band = params[:band_type][:id].map(&:to_i)
end

if params[:song_type] != nil
  array_song = params[:song_type][:id].map(&:to_i)
end

if params[:gender] != nil
  array_gender = params[:gender][:id].map(&:to_i)
end

if params[:job] != nil
  array_job = params[:job][:id].map(&:to_i)
end
    array_inst = params[:candidate][:id].map(&:to_i)
    array_future = params[:future][:id].map(&:to_i)


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

if params[:user_type].to_s == "1" #加入希望を探す

      if current_user
      if params[:order].to_s == "1"
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).job(array_job).future(array_future).age(array_age).info(params[:info]).where.not(id: current_user.id).order(current_sign_in_at: :desc).page(params[:page])
      else
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).job(array_job).future(array_future).age(array_age).info(params[:info]).where.not(id: current_user.id).order(created_at: :desc).page(params[:page])
    end
  else
    if params[:order].to_s == "1"
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).job(array_job).future(array_future).age(array_age).info(params[:info]).order(current_sign_in_at: :desc).page(params[:page])
      else
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).gender(array_gender).job(array_job).future(array_future).age(array_age).info(params[:info]).order(created_at: :desc).page(params[:page])
    end
  end
end

if params[:user_type].to_s == "2" #メンバー募集を探す
  if current_user
      if params[:order].to_s == "1"
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).future(array_future).band_type(array_band).song_type(array_song).info(params[:info]).where.not(id: current_user.id).order(current_sign_in_at: :desc).page(params[:page])
      else
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).future(array_future).band_type(array_band).song_type(array_song).info(params[:info]).where.not(id: current_user.id).order(created_at: :desc).page(params[:page])
    end
  else
    if params[:order].to_s == "1"
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).future(array_future).band_type(array_band).song_type(array_song).info(params[:info]).order(current_sign_in_at: :desc).page(params[:page])
      else
        @users = User.with_attached_profile_picture.user_type(params[:user_type]).inst(kk).area(params[:area]).future(array_future).band_type(array_band).song_type(array_song).info(params[:info]).order(created_at: :desc).page(params[:page])
    end
  end
end





  end
end
