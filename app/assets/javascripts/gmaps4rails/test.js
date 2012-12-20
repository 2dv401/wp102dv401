function click() {
   var latitude = Gmaps.map.map.center.$a;
   var longitude = Gmaps.map.map.center.ab;
   
   var mapForm = document.forms['map_form'];
   
   mapForm.elements["latitude"].value = latitude;
   mapForm.elements["longitude"].value = longitude;
}

function testFunc(){
   var map = Gmaps.map.map;

   google.maps.event.addListener(map, 'rightclick', function(event) {
    var latLng = event.latLng;
    var lat = latLng.lat();
    var lng = latLng.lng();
    
    new google.maps.Marker({
            position: event.latLng,
            map: map,
            title: "HIHIHIHI"
        });
   })
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

window.onload = function () {
    var submit = document.getElementById("submit");
    var test = document.getElementById("navigation");
    var navigation = document.getElementById("geolocate_button");
    
    if(submit){
      submit.onclick = click;
    }
    
    if(navigation){
      navigation.onclick = useGeolocation;
    }
    
    if(test){
      test.onclick = testFunc;
    }
}