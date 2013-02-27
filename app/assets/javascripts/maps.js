// Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {
    if ($('body').hasClass('maps') == false) {return};
    // Körs när kartan är genererad
    Gmaps.map.callback = function() {

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