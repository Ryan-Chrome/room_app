import consumer from "./consumer"

$(document).on("turbolinks:load", function() {
  const chatChannel = consumer.subscriptions.create({ channel: "RoomChannel", room: $("#direct_messages").data("room_id") }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      // Called when there's incoming data on the websocket for this channel
      $("#direct_messages").append(data["direct_message"]);
      var element = document.getElementById("direct_messages");
      element.scrollTop = element.scrollHeight;
    },
  
    speak: function(direct_message) {
      return this.perform("speak", {
        direct_message: direct_message
      });
    }
  });

  const document_width = document.body.clientWidth;
  if(document_width >= 1025){
    $(document).on("keypress", "[data-behavior~=room_speaker]", function(event) {
      if(event.keyCode === 13) {
        chatChannel.speak(event.target.value);
        event.target.value = "";
        return event.preventDefault();
      }
    });
  }

  if(document_width <= 1024) {
    const chat_btn = document.getElementById("chat-btn");
    if(chat_btn){
      chat_btn.onclick = function(){
        const room_form = document.getElementById("room_form");
        chatChannel.speak(room_form.value);
        room_form.value = "";
      }
    }
  };
});