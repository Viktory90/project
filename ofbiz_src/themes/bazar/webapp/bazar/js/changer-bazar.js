/* Style Changer */

jQuery(document).ready(function($){
	if($('body').hasClass('stretched')){
		$('#layout').val('stretched');
	} else {
		$('#layout').val('boxed');
	}
	
	$('.handler').click(function(){
		if ($(this).hasClass('closed')){
			$(this).next('.options').parent().animate({left:0}, 300, function(){
				$(this).find('.handler').removeClass('closed');
			});
		} else {
			$(this).parent().animate({left:'-194px'}, 300, function(){
				$(this).find('.handler').addClass('closed');
			});
		}
		return false;
	});
	
	$('.handler').parent().delay(1000).animate({left:'-194px'}, 300, function(){
		$(this).find('.handler').addClass('closed');
	});
	
	// layout
	if ( $('#layout').val() == 'stretched' )
	   $('#bgs').hide();
    var prev_bg = $( 'body' ).css( 'background' );
    var prev_shadow = $( '#menu-shadow' ).css( 'bottom' );
	$('#layout').change(function(){
		var layout = $(this).val();
		if( layout == 'stretched' ){
            $( 'body' ).removeClass( 'boxed' ).addClass( 'stretched' ).css( 'background', '#fff' );
			//yit_stretch_the_menu();
		} else if(layout == 'boxed') {
            $('#bgs').show();
			$( 'body' ).removeClass( 'stretched' ).addClass( 'boxed' ).css( 'background', prev_bg );
			if($( 'body' ).css( 'background-image' ) == "none") $( 'body' ).css( {'background-image':'url(' + $('.style-picker a.bgBody').attr('rel') + ')', "background-attachment":"fixed", "background-position":"top center", "background-repeat":"repeat"} );
		}
        
        $(window).trigger('resize');
        
	});
	
	// headings font
	$('#hfont').change(function(){
        var selectors = 'h1, h2, h3, h4, h5, h6, .special-font, #slogan h2, #slogan h3, .post-title, .post-title a, h1 a, h2 a, h3 a, h4 a, h5 a, h5 a, h6 a, #nav ul li, #nav ul li a, #nav .megamenu ul.sub-menu li.menu-item-custom-content p, #header-sidebar .widget.text-image, #header-sidebar .widget.text-image h3, #header-sidebar .widget.text-image p, #header-sidebar .widget.text-image a, #header-sidebar .widget_text.widget, #header-cart-search .cart-items, #header-cart-search .cart-subtotal, #header-cart-search .widget_shopping_cart .cart_control, #header-cart-search #search_mini, #topbar, #topbar p, #topbar a, #topbar li, #header-cart-search .cart_wrapper .cart_list li.empty, #header-cart-search .cart_wrapper ul.cart_list li a, #header-cart-search .widget_shopping_cart .cart_wrapper .total, #header-cart-search .widget_shopping_cart .cart_wrapper .total .amount, ' +
                        '#header-cart-search .widget_shopping_cart .cart_wrapper .buttons .button, ul.products li.product.grid.with-hover .product-actions .add_to_cart_button, ul.products li.product.grid.with-hover .product-actions .view-options, ul.products li.product.list .description .view-detail, div.product .single_add_to_cart_button, div.product .variations_form .yith-wcwl-add-to-wishlist a, .shop_table .product-add-to-cart a, .recent-posts-home .hentry-post .border .title a.title, .testimonial-widget li .name-testimonial, .sidebar .cta .newsletter-submit .submit-field, .yit_toggle_menu ul.menu li > a, .sidebar .widget.widget_shopping_cart li a, .sidebar .widget.widget_shopping_cart .total, .sidebar .widget.widget_shopping_cart .buttons .button, .widget.faq-filters .border ul li a, ul.products li.product .price, .tabs-container ul.tabs li h4 a, .recent-post .text > a, ' + 
                        '.section-services-bandw .service-wrapper .service a.read-more';
        var gFontVal = $("option:selected", this).val();
		var gFontName = gFontVal.split(':');
		if ($('head').find('link#gFontName').length < 1){
			$('head').append('<link id="gFontName" rel="stylesheet" type="text/css" href="" />');
		}
		if ($('head').find('style#gFontStyles').length < 1){
			$('head').append('<style id="gFontStyles" type="text/css"></style>');
		}
		$('link#gFontName').attr({href:'http://fonts.googleapis.com/css?family=' + gFontVal});
		$('style#gFontStyles').html(selectors + ' { font-family:"' + gFontName[0] + '", sans-serif !important; }');
	});
	
	// paragraph
	$('#pfont').change(function(){
		var selectors = '.call-to-action-two .incipit, .features-tab-container .features-tab-content, .recent-comments .the-post span, .recent-comments .the-post a, .not-btn.more-link, .not-btn.read-more, .contact-form li.submit-button input.sendmail, #footer a, #copyright a, #copyright div a, #copyright div p a, .last-tweets p, .last-tweets p a, #topbar_login a.topbar_login, p, li, address, dd, blockquote, td, th, .paragraph-links a, a.text-color, ul.filters li a, .menu-select select, .testimonial-widget li a, .testimonial-widget li p, .hentry-post .the-content p a, .hentry-post .meta p, .hentry-post .meta p a, #respond input, #respond textarea, #respond p label, #resppond a, .recent-posts-home .hentry-post .border .title, #respond a, #copyright, #copyright div p, #copyright p, #copyright a, #copyright p a, #copyright div p a, .sidebar p, .sidebar li, .sidebar div, ' +
                        '#nav ul li ul li a, #nav .megamenu ul.sub-menu li li a, a, p, li, address, dd, blockquote, td, th, .paragraph-links a, a.text-color, ul.filters li a, .menu-select select, .testimonial-widget li a, .testimonial-widget li p, #search_mini, .newsletter-input input, .newsletter-submit input, .features-tab-container .features-tab-labels li, .features-tab-content, .portfolio-libra .work-projects ul.pagination_nav li a, input#s';
        var pFontVal = $("option:selected", this).val();
		var pFontName = pFontVal.split(':');
		if ($('head').find('link#gFontName').length < 1){
			$('head').append('<link id="pFontName" rel="stylesheet" type="text/css" href="" />');
		}
		if ($('head').find('style#gFontStyles').length < 1){
			$('head').append('<style id="pFontStyles" type="text/css"></style>');
		}
		$('link#pFontName').attr({href:'http://fonts.googleapis.com/css?family=' + pFontVal});
		$('style#pFontStyles').html(selectors + ' { font-family:"' + pFontName[0] + '", sans-serif !important; }');
	});
	
	$('.style-picker .bgFooterTransparent').click(function(){
		$('#header, #footer, #copyright').css({backgroundColor:'transparent'});
	});
    
    // colorpicker header background      
	$('.style-picker #bgHeaderColor').parent('a').ColorPicker({
		onChange:function(hsb, hex, rgb){
			$('.style-picker').find('#bgHeaderColor').css({backgroundColor:'#' + hex});
			$('#header, #nav, #header, #topbar, #header-sidebar .widget_text .textwidget, #topbar_login a.topbar_login, #nav .current-menu-ancestor > a, #nav ul li a:hover, #nav ul li:hover a, #nav .current-menu-item > a, #nav .current_page_ancestor > a, #nav .current-menu-ancestor > a, div#nav ul .current_page_item > a, #nav ul li a:hover, #nav ul li:hover a, #nav ul.sub-menu, #nav ul.children').css({backgroundColor:'#' + hex});
		},
		onSubmit:function(hsb, hex, rgb, el){
			$(el).find('#bgHeaderColor').css({backgroundColor:'#' + hex});
			$(el).find('#bgHeaderColor').attr({title:hex});
			$('#header, #topbar, #header-sidebar .widget_text .textwidget, #topbar_login a.topbar_login, #nav .current-menu-ancestor > a, #nav ul li a:hover, #nav ul li:hover a, #nav .current-menu-item > a, #nav .current_page_ancestor > a, #nav .current-menu-ancestor > a, #nav ul li a:hover, #nav ul li:hover a, div#nav ul .current_page_item > a, #nav ul.sub-menu, #nav ul.children').css({backgroundColor:'#' + hex});
			$(el).ColorPickerHide();
		},
		onBeforeShow:function(){
		    var hex = $('.style-picker').find('#bgHeaderColor').attr('title');
			$(this).ColorPickerSetColor(hex); 
		}
	});
	
	// colorpicker footer background      
	$('.style-picker #bgFooterColor').parent('a').ColorPicker({
		onChange:function(hsb, hex, rgb){
			$('.style-picker').find('#bgFooterColor').css({backgroundColor:'#' + hex});
			$('#footer, #copyright').css({backgroundColor:'#' + hex});
		},
		onSubmit:function(hsb, hex, rgb, el){
			$(el).find('#bgFooterColor').css({backgroundColor:'#' + hex});
			$(el).find('#bgFooterColor').attr({title:hex});
			$('#footer, #copyright').css({backgroundColor:'#' + hex});
			$(el).ColorPickerHide();
		},
		onBeforeShow:function(){
		    var hex = $('.style-picker').find('#bgFooterColor').attr('title');
			$(this).ColorPickerSetColor(hex); 
		}
	});
	
	// colorpicker body background      
	$('.style-picker #bgColor').parent('a').ColorPicker({
		onChange:function(hsb, hex, rgb){
			$('.style-picker').find('#bgColor').css({backgroundColor:'#' + hex});
			$('body').css({'background':'#' + hex});
		},
		onSubmit:function(hsb, hex, rgb, el){
			$(el).find('#bgColor').css({backgroundColor:'#' + hex});
			$(el).find('#bgColor').attr({title:hex});
			$('body').css({'background':'#' + hex});
			$(el).ColorPickerHide();
		},
		onBeforeShow:function(){
		    var hex = $('.style-picker').find('#bgColor').attr('title');
			$(this).ColorPickerSetColor(hex); 
		}
	});
	
	// change body bg
	$('.style-picker a.bgBody').click(function(){
        var imgUrl = $(this).attr('rel');
        $('body').css({'background-image':"url('"+imgUrl+"')", "background-attachment":"fixed", "background-position":"top center", "background-attachment":"fixed", "background-repeat":"repeat"});
        return false;
    });
});