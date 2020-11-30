class EntriesController < ApplicationController

    def create

        #追加するユーザーの取得
        @add_user = User.find_by(public_uid: params[:user_id])
        #追加するルームの取得
        @room = Room.find_by(public_uid: params[:room_id])
        #取得したルームのエントリーがcurrent_userのものを取得
        current_user_entry = @room.entries.find_by(user_id: current_user.id)
        #取得したルームのエントリーにcurrent_userが存在するか？また取得したエントリーのステータスがオンラインであるか？
        if current_user_entry.present? && current_user_entry.room_status == true
            #追加するユーザーがcurrent_userのフレンドであるか？
            if current_user.friend?(@add_user)
                @room.entries.create(user_id: @add_user.id)
                @direct_messages = @room.direct_messages
                @room_member = @room.users
                @friends = current_user.followings & current_user.followers
                respond_to do |format|
                    format.html { redirect_to room_path(@room) }
                    format.js
                end
            else
                redirect_to root_path
            end
        else
            redirect_to root_path
        end

    end

    def update

        #エントリーの取得
        @current_entry = Entry.find_by(public_uid: params[:id])
        #取得したエントリーはcurrent_userが所有しているものか？
        if current_user.entries.include?(@current_entry)
            #もしエントリーのチェックがfalse(ルームメッセージ未読)の場合、既読にする
            if @current_entry.check == false
                @current_entry.update!(check: true)
            end
            redirect_to room_path(@current_entry.room)
        else
            redirect_to root_path
        end

    end

    def destroy

        #削除するエントリーを取得
        @entry = Entry.find_by(public_uid: params[:id])
        #取得したエントリーのルーム取得
        @room = @entry.room
        #取得したルームのエントリーがcurrent_userのものを取得
        current_user_entry = @room.entries.find_by(user_id: current_user.id)
        #取得したルームのエントリーにcurrent_userが存在するか？また取得したエントリーのステータスがオンラインであるか？
        if current_user_entry.present? && current_user_entry.room_status == true
            @entry.destroy
            #もし削除したエントリーがcurrent_userのものだった場合はルームから退出
            if current_user == @entry.user
                redirect_to root_path
            else
                @direct_messages = @room.direct_messages
                @room_member = @room.users
                @friends = current_user.followings & current_user.followers
                respond_to do |format|
                    format.html { redirect_to room_path(@room) }
                    format.js
                end
            end
        else
            redirect_to root_path
        end

    end
end
