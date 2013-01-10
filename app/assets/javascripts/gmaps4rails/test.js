function click() {
   var latitude = Gmaps.map.map.center.$a;
   var longitude = Gmaps.map.map.center.ab;
   
   var mapForm = document.forms['map_form'];
   
   mapForm.elements["latitude"].value = latitude;
   mapForm.elements["longitude"].value = longitude;
}

function activateLocationAdd(){

	if(Gmaps.map.map){

	var mapContainer = $("#viewMapContainter");
	mapContainer.unbind('mouseover');
	
	var map = Gmaps.map.map;

   google.maps.event.addListener(map, 'rightclick', function(event) {
		var latLng = event.latLng;
		var lat = latLng.lat();
		var lng = latLng.lng();
	 
		x = event.pixel.x;
		y = event.pixel.y;
	
		showMarkingCreationBox(lat,lng,mapContainer);
	})
	}
}

function showMarkingCreationBox(latitude,longitude,container){
	if($("#markingInfo").length == 0){
		Gmaps.map.map.setCenter(new google.maps.LatLng(latitude,longitude));
	
		var markingBox = $('<div id="markingInfo">Visa box med textfält, lås allt annat, o.s.v.</div>')
		markingBox.css({left:(container.width() /2),top:(container.height() /2) +60,position:'absolute'});
		
		container.append(markingBox);
	}
}

function saveMarking(longitude,latitude,name,description){
	new google.maps.Marker({
            position: event.latLng,
            map: map,
            title: "name"
        });
}

function searchFieldAutoComplete(){
	var searchField = document.getElementById("locationTextField");
	
	var resultPlaces = [];
	
	geocoder = new google.maps.Geocoder();
	
	geocoder.geocode( { 'address': searchField.value}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
			for (var p = 0; p < results.length; p++) {
				
				label = results[p].address_components[0].long_name;
				value = results[p].geometry.location;
			
				resultPlaces.push({ label: label, value: value });
			}
		  
      }
		else{
			//alert(status);
		}
    });
	
	$("#locationTextField").autocomplete( { source: resultPlaces,
														select: searchFieldSelect});
}

function searchFieldSelect(event, ui){
	var longitude = ui.item.value.ab;
	var latitude = ui.item.value.$a;
	
	Gmaps.map.map.setCenter(new google.maps.LatLng(latitude,longitude));
   Gmaps.map.map.setZoom(30);
	
	return false;
}

function useGeolocation(){
   navigator.geolocation.getCurrentPosition(move_map);
   
   
}
function move_map(position){  
            var latitude = position.coords.latitude;
            var longitude = position.coords.longitude;
            
            Gmaps.map.map.setCenter(new google.maps.LatLng(latitude,longitude));
            Gmaps.map.map.setZoom(30);
        }  

window.onready = function () {
    var submit = document.getElementById("submit");
    var test = document.getElementById("navigation");
    var navigation = document.getElementById("geolocate_button");
	 var searchField = document.getElementById("locationTextField");
	 var map = $("#viewMapContainter");
	 
    if(submit){
      submit.onclick = click;
    }
    
    if(navigation){
      navigation.onclick = useGeolocation;
    }
	 
	 if(searchField){
		searchField.onkeyup = searchFieldAutoComplete;
    }
	 
	 if(map){
		map.mouseover(activateLocationAdd);
    }
}