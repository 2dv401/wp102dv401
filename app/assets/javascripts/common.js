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
});