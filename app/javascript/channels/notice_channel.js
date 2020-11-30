import consumer from "./consumer"

$(document).on("turbolinks:load", function() {
  const noticeChannel = consumer.subscriptions.create({ channel: "NoticeChannel", room: $("#direct_messages").data("room_id") }, {
    connected() {

    },
    desconnected() {

    },

    received(data) {
      const screen_width = document.body.clientWidth;
      if(screen_width >= 1025) {
        anime({
          targets: `#group-${data["room_id"]} .room-link`,
          opacity: [1,0],
          duration: 1500,
          direction: "alternate",
          easing: "linear",
          loop: true
        });
      }
      if(screen_width <= 1024){
        anime({
          targets: `#group-${data['room_id']} .new-light`,
          color: "rgb(100, 230, 139)"
        });
        anime({
          targets: "#sub-menu-room .new-light",
          color: "rgb(100, 230, 139)"
        });
      }
    }

  });    
});