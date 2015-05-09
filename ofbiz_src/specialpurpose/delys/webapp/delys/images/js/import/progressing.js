$('body').ajaxStart(function() {
					disAll();
		            $(this).css({'cursor':'progress'});
		            $(".jqx-widget").css({'cursor':'progress'});
		            $(".btn").css({'cursor':'progress'});
		            
		        }).ajaxStop(function() {
		        	openAll();
		            $(this).css({'cursor':'default'});
		            $(".jqx-widget").css({'cursor':'default'});
		            $(".btn").css({'cursor':'default'});
		        }).ajaxError(function() {
			        	alert('ajaxError');
			        	openAll();
			            $(this).css({'cursor':'default'});
			            $(".jqx-widget").css({'cursor':'default'});
			            $(".btn").css({'cursor':'default'});
				});

function disAll() {
	var all = $('input[type="submit"], button');
	for ( var x in all) {
		all[x].disabled = true;
	}
	$("form a").prop("disabled", true);
}
function openAll() {
	var all = $('input[type="submit"], button');
	for ( var x in all) {
		all[x].disabled = false;
	}
	$("form a").prop("disabled", false);
}
