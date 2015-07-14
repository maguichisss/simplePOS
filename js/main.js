$( document ).ready(function() {
	
	var title = "a[id='"+document.title+"']";
	
	$( title ).parent().toggleClass('active');

	//previene dar enter antes de enviar el formulario
	$('.noEnterSubmit').keypress(function(e){
	    if ( e.which == 13 ) return false;
	});


});
