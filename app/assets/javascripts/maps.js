// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {

    if ($('body').hasClass('maps') == false) {return;};

    // Körs när kartan är genererad
    Gmaps.map.callback = function() {
        // Sparar undan kartan i en variabel
        var map = Gmaps.map.map;

        // Sparar undan kartans zoom och centerposition i de gömda fälten i formuläret
        var updateMap = function( options ) {
            $( '#center-lat' ).val( options.lat );
            $( '#center-lng' ).val( options.lng );
            $( '#map-zoom' ).val( options.zoom );
        };

        // Sparar undan kartas typ i det gömda fältet i formuläret
        var updateMapType = function(type) {
            $( '#map-type' ).val( type.toUpperCase() );
        };

        // Lyssna på att när kartan har ändrats och uppdaterar då kartformulärets koordinatfält
        google.maps.event.addListener( map, 'idle', function() {

            // Hämtar kartans centerposition
            var center = this.getCenter();

            // Skapar ett objekt med informationen som ska uppdateras och skickar det till en funktion som uppdaterar informationen i formuläret
            updateMap({
                lat: center.lat(),
                lng: center.lng(),
                zoom: this.getZoom()
            });
        });
        // Lyssna på att när kartans typ ändras och uppdaterar då kartformuläret
        google.maps.event.addListener( map, 'maptypeid_changed', function() {
            updateMapType(this.getMapTypeId());
        });

        $("#map").ajaxComplete(function(event, request, settings) {
            var id = settings.url.split("/").pop();
            removeMarking(id);
        });

        function removeMarking(id){
            var marker = getMarker(id);
            var link = getMarkerLink(id);
            marker.serviceObject.setMap(null);
            $(link).fadeOut('slow');
        }

        /**
         *
         * Geolocation scripts
         *
         *
         */
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

        /**
         *
         * Marklink scripts
         *           $(".mark-link")
         */
        var markLinks = $(".mark-link");

        // Dölj "ta bort-länkarna"
        markLinks.parent().find("a.delete-mark").hide();

        // Döljer beskrivningarna
        markLinks.parent().find("p.mark-description").hide();

        // Visar "ta bort-länken" när man hovrar över listelementet
        markLinks.parent().hover(
            function() {
                var deleteLink = $(this).find("a.delete-mark");
                deleteLink.fadeIn(10);

                $(this).find("p.mark-description").slideDown(10);

                // Tar bort listelementet när markeringen tas bort.
                deleteLink.click(function(event) {
                    $(this).parent().fadeOut(100);
                });
            },
            function() {
                $(this).find("a.delete-mark").fadeOut(100);
                $(this).find("p.mark-description").slideUp(100);
            }
        );

        //Centrerar markeringen på kartan
        markLinks.click(function(event) {
            event.preventDefault();

            var marker = getMarker( $(this).attr("data-markid") );
            google.maps.event.trigger(marker.serviceObject, "click", null);

        });
        //Animering på merkeringslänkarna
        markLinks.hover(
            function() {

                // Hämtar den tillhörande markeringen och startar en bounceanimation.
                var marker = getMarker( $(this).attr("data-markid") );
                marker.serviceObject.setAnimation(google.maps.Animation.BOUNCE);


            },
            function() {

                // Hämtar den tillhörande markeringen och avbryter bounceanimationen
                var marker = getMarker( $(this).attr("data-markid") );
                marker.serviceObject.setAnimation(null);

                $(this).find("p.mark-description").slideUp('slow');
            }
        );

        var getMarker = function(id) {

            // Loopar igenom kartans markeringar och returnerar den rätta.
            for( var index in Gmaps.map.markers ) {
                if( Gmaps.map.markers[index].id == id ) {
                    return Gmaps.map.markers[index];
                }
            }
            return null;
        };

        var getMarkerLink = function(id) {
            var link = null;
            // Loopar igenom kartans markeringslänkar och returnerar den rätta.
            markLinks.each(function() {
                if( $(this).attr("data-markid") == id ) {
                    link = this;
                }
            });
            return link;
        };
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