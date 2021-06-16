class RoomsController < ApplicationController
  def show
    #ルームの取得
    @room = Room.find_by(public_uid: params[:id])
    #ルームにエントリーしているユーザーの取得
    @entryRoom = current_user.entries.order(updated_at: "DESC")
    #ルームにエントリーしているのか確認
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @direct_messages = @room.direct_messages.order(created_at: "DESC").page(params[:page]).per(15).reverse
      @page_count = @room.direct_messages.order(created_at: "DESC").page(params[:page]).per(15).total_pages.to_i
      @room_member = @room.users
      @friends = current_user.followings & current_user.followers
    else
      redirect_to root_path
    end
  end

  def create
    #ルーム作成
    @room = Room.new(params_room)
    #成功したら
    if @room.save
      #current_userのエントリー作成
      @entry = Entry.create(room_id: @room.id, user_id: current_user.id)
      redirect_to room_path(@room)
    else
      redirect_to root_path
    end
  end

  def destroy
    #ルームの取得
    @room = Room.find_by(public_uid: params[:id])
    #ルームを削除しようとしているユーザーのエントリーを取得
    @entry = @room.entries.find_by(user_id: current_user)
    #エントリーが存在かつルームに入室中の場合のみ
    if @entry && @entry.room_status == true
      @room.destroy
      flash[:notice] = "#{@room.name}を削除しました"
      redirect_to root_path
    else
      flash[:notice] = "ルームの削除に失敗しました"
      redirect_to root_path
    end
  end

  private

  def params_room
    params.require(:room).permit(:name)
  end
end
