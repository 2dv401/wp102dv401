// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function() {
    if ($('body').hasClass('marks') == false) {return;};

    // Körs när kartan är genererad
    Gmaps.map.callback = function() {
        var LAT = {
            id: 'mark_location_attributes_latitude',
            max: 85,
            min: -85,
            regexp: /^(-?[1-8]?\d(?:\.\d{1,18})?|90(?:\.0{1,18})?)$/
        };
        var LNG = {
            id: 'mark_location_attributes_longitude',
            max: 180,
            min: -180,
            regexp: /^(-?(?:1[0-7]|[1-9])?\d(?:\.\d{1,18})?|180(?:\.0{1,18})?)$/
        };

        // Referens till kartan
        var map = this.map;

        // Skapa ett koordinat-objekt med markeringens position
        var defultPosition = new google.maps.LatLng( $( '#' + LAT.id ).val(), $( '#' + LNG.id ).val())

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
            $( '#' + LAT.id ).val( LatLngObj.lat() );
            $( '#' + LNG.id ).val( LatLngObj.lng() );
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
            var latField = $( '#' + LAT.id );
            var lngField = $( '#' + LNG.id );

            lngField.keyup(function(event) {
                fieldEventHandler(this, event);
            });

            latField.keyup(function(event) {
                fieldEventHandler(this, event);

            });

            var fieldEventHandler = function(target, event) {
                var targetValue = parseFloat( target.value );
                var newValue = 0;
                var zoom = map.getZoom() + 1;
                // adaptern är beroende av zoomen:
                var zoomAdapter = zoom < 7 ? zoom : // under 7: :zoom
                    zoom < 10 ? zoom * 5 : // under 10: :zoom * 5
                        zoom < 13 ? zoom * 50 : // under 13: :zoom * 50
                            zoom < 16 ? zoom * 100 : // under 16: :zoom * 100
                                zoom < 19 ? zoom * 500 : zoom * 1000; // under 19: :zoom * 500, över 19: :zoom * 1000
                // Sätter min och max-värden för koordinaten beroende på vilket fält som ändras
                var max = target.id === LAT.id ? LAT.max : LNG.max;
                var min = target.id === LAT.id ? LAT.min : LNG.min;

                // om upp-pilen trycks ner
                if(event.keyCode == 38) {
                    newValue = targetValue + (3 / zoomAdapter);

                    if ( newValue > max ) {
                        // om värdet är högre än "max" och det inte är latitudfältet som ändras går den över till min och tar bort mellanskillnaden.
                        // Detta görs då man vid vågrät(longitud) förflyttning utöver 0-punkten även har gränsen mellan -180 och 180 att tänka på.
                        target.value = target.id === LAT.id ? max : min + ( newValue - max );
                    }
                    else {
                        target.value = newValue;
                    }
                }
                // om ner-pilen trycks ner
                if(event.keyCode == 40) {
                    newValue = targetValue - (3 / zoomAdapter);
                    if ( newValue < min ) {
                        // om värdet är mindre än "min" och det inte är latitudfältet som ändras går den över till max och tar bort mellanskillnaden
                        // Detta görs då man vid vågrät förflyttning(longitud) utöver 0-punkten även har gränsen mellan -180 och 180 att tänka på.
                        target.value = target.id === LAT.id ? min : max + ( newValue + max );
                    }
                    else {
                        target.value = newValue;
                    }
                }
                if( latLngValidation(target) ) {
                    // Tar bort eventuell error class som lagts till vid fel inmatning
                    $( '#' + target.id ).removeClass('error');

                    var newPosition =  new google.maps.LatLng( latField.val(), lngField.val() );

                    // Flyttar markeringen till den nya positionen
                    newMark.setPosition( newPosition );
                    // Centrerar kartan över stället
                    map.setCenter( newPosition );
                }
                else {
                    // Lägger till en error-class om valideringen inte går igenom
                    $( '#' + target.id ).addClass('error');
                }
            };

            var latLngValidation = function(target) {

                // Kollar först vilket fält som skall valideras och validerar sedan mot ett förbestämt regex.
                // Returnerar boolean
                return target.id === LAT.id ? LAT.regexp.test( target.value ) : LNG.regexp.test( target.value );
            }
        });

    }
});
