// Put your application scripts here
$(function() {
  $.ajax({
    type: "POST",
    url: "/background/refresh",
    success: (function( data ) {
      alert( "Data Loaded: " + data );
    })
  });
});