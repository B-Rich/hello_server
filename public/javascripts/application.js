// Put your application scripts here
function getIntervalServices() {
  var _interval = $("input[name='refresh_interval']").val();

  $.ajax({
    type: "POST",
    url: "/background/refresh",
    success: (function (data) {
      $("#services").effect("highlight", {}, 800);
    })
  }).done(function () {
      console.log("Refreshing in " + _interval);
      setTimeout(getIntervalServices, _interval);
    });
}
