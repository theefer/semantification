function initMaps(el, lat, lon) {
  var mapOptions = {
    zoom: 14,
    center: new google.maps.LatLng(lat, lon),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(el, mapOptions);
}
