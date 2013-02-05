// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function() {

  // Körs när kartan är genererad
  Gmaps.map.callback = function() {
    var newMark = new google.maps.Marker({
      position: new google.maps.LatLng(59, 18),
      map: this.map,
      options: {
        draggable: true
      }
    });

    var updateLocationFields = function(latitude, longitude) {
      $('#mark_location_attributes_longitude').val(longitude);
      $('#mark_location_attributes_latitude').val(latitude);
    }
    /*
    Lyssnar på förflyttningar av markören
    Modifierar inputfälten för longitud och latitud när markören släpps

    TODO: REFACTOR
    */
    google.maps.event.addListener(newMark, 'dragend', function() {

      //updateLocations('Dragging...');
      console.log(this.position.lat());

      updateLocationFields(this.position.lat(), this.position.lng());
    });


    // Följde delar av denna 'guide' när jag gjorde denna kod
    // http://rjshade.com/2012/03/27/Google-Maps-autocomplete-with-jQuery-UI/
    // Initierar google's geocoder
    var geocoder = new google.maps.Geocoder();


    $('#geolocate_button').click(function() {
      navigator.geolocation.getCurrentPosition(function(position){
        updateLocationFields(position.coords.latitude, position.coords.longitude);

        newMark.setPosition(new google.maps.LatLng(position.coords.latitude, position.coords.longitude));
      });
    })



    // jQuery UI Autocomplete funktion
    $("#locationTextField").autocomplete({
      // Autocomplete uppdateras när man skrivit x antal tecken
      minLength: 3,

      source: function(request, response) {
        // Hämtar det man skrivit i fältet
        var address = request.term;

        // Utför sökningen mot google
        geocoder.geocode({
          address: address
        }, function(results, status) {
          response($.map(results, function(item) {
            return {
              label: item.formatted_address,
              value: item.formatted_address,
              geocode: item
            }
          }));
        })
      },

      select: function(event, ui) {
        // Hämtar location-objektet från argumentet
        var location = ui.item.geocode.geometry.location;

        // Sätter Lat/Lng-fälten i formuläret
        // TODO: REFACTOR
        updateLocationFields(location.lat(), location.lng());

        // Centrerar kartan över stället
        Gmaps.map.map.setCenter(location);

        // Flyttar dit markeringen
        newMark.setPosition(location);
      }
    });
  }
});


$(function() {
  
})