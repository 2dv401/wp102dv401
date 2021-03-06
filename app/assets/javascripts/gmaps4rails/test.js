/*
var temporaryMarker = null;

function click() {
  var latitude = Gmaps.map.map.center.$a;
  var longitude = Gmaps.map.map.center.ab;

  var mapForm = document.forms['map_form'];

  mapForm.elements["latitude"].value = latitude;
  mapForm.elements["longitude"].value = longitude;
}

function activateLocationAdd() {

  if(Gmaps.map.map) {

    var mapContainer = $(".map_container");
    mapContainer.unbind('mouseover');

    var map = Gmaps.map.map;

    google.maps.event.addListener(map, 'rightclick', function(event) {
      var latLng = event.latLng;
      var lat = latLng.lat();
      var lng = latLng.lng();
      */
/*if($("#markingInfo").length == 0){
      var marker = new google.maps.Marker({ map: map });
      temporaryMarker = marker;
      marker.setPosition(latLng);
      x = event.pixel.x;
      y = event.pixel.y;
      showMarkingCreationBox(lat,lng,mapContainer);
      //fryser kartan
      map.setOptions({draggable: false, zoomControl: false, scrollwheel: false, disableDoubleClickZoom: true});
    }*//*


      setFormLocation(lat, lng);
    })
  }
}

function removeMarking(id){
  for(var marker in Gmaps.map.markers){
    if(Gmaps.map.markers[marker].id == id){
      Gmaps.map.markers[marker].serviceObject.setMap(null)
    }
  }
}

function showMarkingCreationBox(latitude, longitude, container) {
  //Hämta map-id ur URL
  var a = $(location).attr('href').split("//");
  var b = a[1].split("/");
  var id = "";
  if($.isNumeric(b[2])) {
    id = b[2].toString();
  }
  
  Gmaps.map.map.setCenter(new google.maps.LatLng(latitude, longitude));
  var markingBox = $('<div id="markingInfo"><form name="marking_form" method="post" action="/locations" id="marking_form"><input name="authenticity_token" type="hidden" value="' + AUTH_TOKEN + '"/><span style="background-color:white; color: black">Platsnamn:</span><input type="text" name="titel" id="titel" /><span style="background-color:white; color: black">Beskrivning:</span><textarea name="description" id="desc"></textarea><input type="submit" id="submitMarking" value="Skapa"/><input name="cancelButton" id="cancelButton" type="button" value="Avbryt" /><input id="longitude" name="longitude" type="hidden" value="' + longitude + '" /><input id="latitude" name="latitude" type="hidden" value="' + latitude + '" /><input id="id" name="id" type="hidden" value="' + id + '" /></form></div>');
  markingBox.css({
    left: (container.width() / 2),
    top: (container.height() / 2) + 110,
    position: 'absolute',
    color: '#FFFFFF'
  });
  container.append(markingBox);

  $("#cancelButton").click(function() {
    closeMarkingCreationBox();
  });

}

function closeMarkingCreationBox() {
  $("#markingInfo").remove();

  if(Gmaps.map) {
    var map = Gmaps.map.map;

    map.setOptions({
      draggable: true,
      zoomControl: true,
      scrollwheel: true,
      disableDoubleClickZoom: false
    });

    if(temporaryMarker) {
      temporaryMarker.setMap(null);
    }
  }
}

function saveMarking(longitude, latitude, name, description) {
  var marker = new google.maps.Marker({
    map: map
  });
  marker.setPosition(LatLng(latitude, longitude));
}


function setFormLocation(lat, lng) {
  $("#mark_location_attributes_longitude").val(lng);
  $("#mark_location_attributes_latitude").val(lat);

  $("#longitude").val(lng);
  $("#latitude").val(lat);
}

function saveMapButtonClick() {
  var latitude = Gmaps.map.map.center.$a;
  var longitude = Gmaps.map.map.center.ab;

  setFormLocation(latitude, longitude);
}

function searchFieldSelect(event, ui) {
  var longitude = ui.item.value.ab;
  var latitude = ui.item.value.$a;

  Gmaps.map.map.setCenter(new google.maps.LatLng(latitude, longitude));

  $('#latitude').val(latitude);
  $('#longitude').val(longitude);

  return false;
}

function isMarkingLink(url) {
  return true;
}

function useGeolocation() {
  navigator.geolocation.getCurrentPosition(move_map);
}

function move_map(position) {
  var latitude = position.coords.latitude;
  var longitude = position.coords.longitude;

  Gmaps.map.map.setCenter(new google.maps.LatLng(latitude, longitude));
  Gmaps.map.map.setZoom(30);

  $('#latitude').val(latitude);
  $('#longitude').val(longitude);
}

window.onready = function() {
  var submit = document.getElementById("submit");
  var test = document.getElementById("navigation");
  var navigation = document.getElementById("geolocate_button");
  var searchField = document.getElementById("locationTextField");
  var map = $("#map");
  var mapCreation = $("#mapCreation");


  if(submit) {
    submit.onclick = click;
  }

  if($("#saveMapButton")) {
    $("#saveMapButton").click(function() {
      saveMapButtonClick();
    });
  }

  if(navigation) {
    navigation.onclick = useGeolocation;
  }


  if(map.is('*') && mapCreation.length < 1) {
    map.mouseover(activateLocationAdd);
  }

  $('.showCords').click(function(e) {
    e.preventDefault();
    console.log('hello');
    $('.fieldCords').slideToggle();
  });

  $(document).keyup(function(e) {
    if(e.keyCode == 27) {
      closeMarkingCreationBox();
    }
  });

  $("#map").ajaxComplete(function(event, request, settings) {
    if(isMarkingLink(settings.url)) {
      var id = settings.url.split("/").pop();
      removeMarking(id);
    }
  });
}*/
