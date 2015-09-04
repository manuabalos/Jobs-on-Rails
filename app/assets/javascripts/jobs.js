$(document).ready(function() {    
	$(".click-row-job").on("click", function() {
	    window.document.location = $(this).data("href");
	});
});