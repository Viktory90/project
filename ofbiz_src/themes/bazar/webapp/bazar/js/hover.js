/* Style Changer */

jQuery(document).ready(function($){
	$('.product-thumbnail').hover (
			function(){
				//hien loggedin_dropdown
				$(this).css('overflow', 'inherit');
			},
			function(){
				//an loggedin_dropdown
				$(this).css('overflow', 'hidden');
			}
		);
});