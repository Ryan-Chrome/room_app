class HomesController < ApplicationController
  def index
    #ログインしている場合
    if user_signed_in?
      #もしユーザーをIDで検索した場合
      if params[:search].present?
        @follow_user = User.find_by(public_uid: params[:search])
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
        end
        #もし申請中のユーザー欄を選択した場合
      elsif params[:request_user].present?
        @other_user = User.find_by(public_uid: params[:request_user])
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
        end
        #もし承認待ちのユーザー欄を選択した場合
      elsif params[:approval_user].present?
        @other_user = User.find_by(public_uid: params[:approval_user])
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
        end
        #もしフレンド欄から選択した場合
      elsif params[:friend_user].present?
        @other_user = User.find_by(public_uid: params[:friend_user])
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
        end
      else
        @entryRoom = current_user.entries.order(updated_at: "DESC")
        #pad, 携帯用サイズのサブヘッダーで通知を知らせるためのもの
        @entryRoom.each do |entry|
          if entry.check == false
            @room_no_check ||= "no_check"
          end
        end
        @friend = current_user.followings & current_user.followers
        @RequestUser = current_user.followings.where.not(id: current_user.followers.ids)
        @ApprovalUser = current_user.followers.where.not(id: current_user.followings.ids)
        @room = Room.new
      end
    end
  end
end
