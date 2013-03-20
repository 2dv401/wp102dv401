$(function() {
	// Simple toogle for statusupdates on mobile
	$('.show-content').click( function() {
		var parent = $(this).parent();
		$(".content", parent).toggle(400);
		return false;
	});
	
	$('#sidebarButton').click( function() {
		$('body').toggleClass('active');
	});
	
	$("#kartr-slideshow").orbit({
		captions: true,
		animationSpeed: 800,
	});
});