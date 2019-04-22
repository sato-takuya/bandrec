class RoomsController < ApplicationController
  before_action :authenticate_user!
  #before_action :prereg #事前登録が終わったら消す


  def prereg
    redirect_to :new_user_registration
  end

  def index #メッセージ一覧を表示する
    @currentEntries = current_user.entries #ログイン中のユーザーが入ることのできる部屋(room)の鍵情報たち
    myRoomIds = []
    @currentEntries.each do |entry|
    myRoomIds << entry.room.id #自分が入ることができる部屋(room)のid
  end

  @anotherEntries = Entry.where(room_id: myRoomIds).where('user_id != ?',current_user.id) #自分が入ることができる部屋(Room)かつuser_idが自分のidではない
  end

  def create #部屋(チャットルーム)を作る
    @room = Room.create
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    redirect_to "/rooms/#{@room.id}" #部屋へ
  end

  def show #すでにある部屋(チャットルーム)を表示する
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end
end