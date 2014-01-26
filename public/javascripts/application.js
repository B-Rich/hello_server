// Put your application scripts here
function getIntervalNotifications() {
  var _interval = $("input[name='refresh_interval']").val();

  $.ajax({
    type: "POST",
    url: "/background/refresh",
    success: (function (data) {
      $("#notifications").effect("highlight", {}, 800);
    })
  }).done(function () {
      console.log("Refreshing in " + _interval);
      setTimeout(getIntervalNotifications, _interval);
    });
}
