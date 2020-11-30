class DirectMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(direct_message)
    ActionCable.server.broadcast "room_channel_#{direct_message.room.public_uid}", direct_message: render_direct_message(direct_message)
    ActionCable.server.broadcast "notice_channel_#{direct_message.room.public_uid}", room_id: "#{direct_message.room.public_uid}"
  end

  private
    def render_direct_message(direct_message)
      ApplicationController.renderer.render partial: 'direct_messages/direct_message', locals: { direct_message: direct_message }
    end
end
