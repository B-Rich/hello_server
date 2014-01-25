// Put your application scripts here
function getIntervalServices() {
  $.ajax({
    type: "POST",
    url: "/background/refresh",
    success: (function (data) {
      $("#services").effect("highlight", {}, 2000);
    })
  }).done(function () {
      console.log("Refreshed");
      setTimeout(getIntervalServices, 8000);
    });
}
