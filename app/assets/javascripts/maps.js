// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {
    if ($('body').hasClass('maps') == false) {return;};

    // Körs när kartan är genererad
    Gmaps.map.callback = function() {
        // TODO: Ta bort alla console.log i filen
        console.log( 'Enter Gmaps.map.callback' );
        console.log(this.map.getMapTypeId());

        var map = Gmaps.map.map;

        console.log( map );

        var updateMap = function(options) {
            console.log( 'Dragging to...lat: ' + options.lat+ ', lng: ' +  options.lng );
            $( '#center-lat' ).val( options.lat );
            $( '#center-lng' ).val( options.lng );
            console.log( 'Zooming to...' + options.zoom );
            $( '#map-zoom' ).val( options.zoom );


        };

        var updateMapType = function(type) {
            console.log( 'Change map to...' + type + ' type');
            $( '#map-type' ).val( type.toUpperCase() );
        };

        // Lyssna på att när kartan har ändrats och uppdaterar då kartformulärets koordinatfält
        google.maps.event.addListener( map, 'idle', function() {

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