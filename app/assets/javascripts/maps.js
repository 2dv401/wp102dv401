// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {

    // Körs när kartan är genererad
    Gmaps.map.callback = function() {

        var geoLocationZoom = 8;

        console.log( 'Enter Gmaps.map.callback' );

        var map = Gmaps.map.map;

        console.log( map );

        var updateMapCenter = function( center ) {
            $( '#latitude' ).val( center.lat() );
            $( '#longitude' ).val( center.lng() );
        };

        var updateMapZoom = function( zoom ) {
            $( '#map_zoom' ).val( zoom );
        };

        google.maps.event.addListener( map, 'center_change', function() {
            console.log('center change');
        });
        // Lyssna på att när kartan har flyttats färdigt och uppdaterar då kartformulärets koordinatfält
        google.maps.event.addListener( map, 'dragend', function() {

            var center = this.getCenter();

            // uppdaterar kartans koordinatfält
            console.log( 'Dragging to...lat: ' + center.lat()+ ', lng: ' +  center.lng() );
            updateMapCenter( center );

        });

        // Lyssna på när kartans zoom ändras och uppdatera kartformulärets zoom-fält
        google.maps.event.addListener( map, 'zoom_changed', function() {

            var zoom = this.getZoom();

            // uppdaterar kartans zoom-fält
            console.log( 'Zooming to...' + zoom );
            updateMapZoom( zoom );
        });


        $('#geolocate_button').click(function() {
            // Hämtar position
          navigator.geolocation.getCurrentPosition(function(position){
            // Spara undan locationen
            var latLngLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            
            map.panTo(latLngLocation);
            map.setZoom(geoLocationZoom);
            updateMapZoom(geoLocationZoom);
            updateMapCenter(latLngLocation);
        });
      });
        var geocoder = new google.maps.Geocoder();
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

        var latLngLocation = new google.maps.LatLng(location.lat(), location.lng());
        map.panTo(latLngLocation);
        map.setZoom(geoLocationZoom);
        updateMapZoom(geoLocationZoom);
        updateMapCenter(latLngLocation);

      }
    });

    };
});

// Tagit Jquery plugin
// https://github.com/aehlke/tag-it/blob/master/README.markdown
$(function() {
  $("#myTags").tagit({
    singleField: true,
    singleFieldNode: $('#map_tag_list'), // Sätter inputfältet
    caseSensitive: true,
    allowDuplicates: false,
    tagLimit: 5 // 'validering'
});
})