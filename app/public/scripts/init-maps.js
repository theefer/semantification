function initMaps(el, lat, lon, zoom) {
  var mapOptions = {
    zoom: zoom,
    center: new google.maps.LatLng(lat, lon),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(el, mapOptions);
}
