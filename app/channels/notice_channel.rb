class NoticeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    rooms = current_user.rooms
    rooms.each do |room|
      if room.public_uid != params["room"]
        stream_from "notice_channel_#{room.public_uid}"
      end
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
