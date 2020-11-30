class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    room = Room.find_by(public_uid: params["room"])
    if current_user.rooms.include?(room)
      stream_from "room_channel_#{params['room']}"
      entry = room.entries.find_by(user_id: current_user.id)
      entry.update! room_status: true
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    if params["room"] != nil
      room = Room.find_by(public_uid: params["room"])
      entry = room.entries.find_by(user_id: current_user.id)
      entry.update! room_status: false
    end
  end

  def speak(data)
    room = Room.find_by(public_uid: params["room"])
    entry = Entry.find_by(user_id: current_user.id, room_id: room.id)
    if entry.present? && entry.room_status == true
      DirectMessage.create! content: data["direct_message"], user_id: current_user.id, room_id: room.id
      room.update! updated_at: Time.now
      room.entries.each do |entry|
        if entry.room_status == false && entry.check == true
          entry.update! check: false
        end
      end
    end
  end
end
