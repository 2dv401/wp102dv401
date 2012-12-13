function click() {
   var latitude = Gmaps.map.map.center.$a;
   var longitude = Gmaps.map.map.center.ab;
   
   //alert("Latitude: " + latitude + " Longitude: " + longitude);
   
   var mapForm = document.forms['map_form'];
   
   mapForm.elements["latitude"].value = latitude;
   mapForm.elements["longitude"].value = longitude;
}

window.onload = function () {
    var submit = document.getElementById("submit");
    
    if(submit){
      submit.onclick = click;
    }
}