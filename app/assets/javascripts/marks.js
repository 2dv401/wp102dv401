// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function() {
    if ($('body').hasClass('marks') == false) {return;};

    // Körs när kartan är genererad
    Gmaps.map.callback = function() {
        var that = this;

        // Referens till kartan
        var map = this.map;

        // Skapa ett koordinat-objekt med merkeringens position
        var defultPosition = new google.maps.LatLng($('#mark_location_attributes_latitude').val(), $('#mark_location_attributes_longitude').val())

        // En ny dragbar markering
        var newMark = new google.maps.Marker({
            position: defultPosition,
            map: map,
            options: {
                draggable: true
            }
        });

        // Kartan flyttar sig till markeringen
        map.panTo( newMark.getPosition() );

        updateLocationFields( newMark.getPosition() );

        function updateLocationFields(LatLngObj) {
            $('#mark_location_attributes_latitude').val( LatLngObj.lat() );
            $('#mark_location_attributes_longitude').val( LatLngObj.lng() );
        }
        /*
         Lyssnar på förflyttningar av markören
         Modifierar inputfälten för longitud och latitud när markören släpps
         */

        // Lyssna på när den nya markeringen har blivit flyttad.
        google.maps.event.addListener(newMark, 'dragend', function() {

            // Spara markerinens position
            var newPosition =  new google.maps.LatLng( this.position.lat(), this.position.lng() );

            map.setCenter(newPosition);
            updateLocationFields(newPosition);
        });


        // Följde delar av denna 'guide' när jag gjorde denna kod
        // http://rjshade.com/2012/03/27/Google-Maps-autocomplete-with-jQuery-UI/
        // Initierar google's geocoder
        var geocoder = new google.maps.Geocoder();


        $('#geolocate_button').click(function() {
            navigator.geolocation.getCurrentPosition(function(position){

                var newPosition = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

                updateLocationFields( newPosition );

                newMark.setPosition(newPosition);
            });
        })

        $('#map_center_button').click(function() {
            newMark.setPosition(map.getCenter());
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
                updateLocationFields( location );

                // Centrerar kartan över stället
                map.setCenter( location );

                // Flyttar dit markeringen
                newMark.setPosition( location );
            }
        });

        $('.showCords').click(function(e) {
            e.preventDefault();
            $('.fieldCords').slideToggle();
            var lngField = $('#mark_location_attributes_longitude');
            var latField = $('#mark_location_attributes_latitude');

            lngField.keyup(function(event) {
                fieldeventHandler(this, event);
            });
            latField.keyup(function(event) {
                fieldeventHandler(this, event);

            });
            var fieldeventHandler = function(target, event) {
                console.log(event.keyCode);
                var targetValue = target.value;
                var zoom = map.getZoom() + 1;
                var zoomAdapter = zoom * ( zoom * 10 );
                // if up
                if(event.keyCode == 38) {
                    console.log( zoom );
                    target.value = parseFloat(targetValue) + 5 / zoomAdapter ;
                }
                // if down
                if(event.keyCode == 40) {
                    target.value = parseFloat(targetValue) - 5 / zoomAdapter;
                }
                if( latLngValidation(target, event) ) {

                    var newPosition =  new google.maps.LatLng( latField.val(), lngField.val() );

                    // Flyttar markeringen till den nya positionen
                    newMark.setPosition( newPosition );
                    // Centrerar kartan över stället
                    map.setCenter( newPosition );
                }
            };

            var latLngValidation = function(target, event) {
                if (event.keyCode > 47 && event.keyCode < 58) {
                     return true;
                }
                else if(
                        // Removing number
                        event.keyCode == 8 ||
                        // up
                        event.keyCode == 38 ||
                        // down
                        event.keyCode == 40 ) {
                    return true;
                }
                return false;
            }
        });

    }
});
