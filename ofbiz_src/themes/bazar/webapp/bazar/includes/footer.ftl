<script type="text/javascript">
jQuery(document).ready(function($){
		woo_update_total_compare_list = function(){ 
			var data = {
				action: 		"woocp_update_total_compare",
				security: 		"cbeeb5f326"
			};
			$.post( ajax_url, data, function(response) {
				total_compare = $.parseJSON( response );
				$("#total_compare_product").html("("+total_compare+")");
                $(".woo_compare_button_go").trigger("click");
			});
		};

	});
</script>
			
			
<!-- START COPYRIGHT -->
<div id="copyright">
	
	<div class="border borderstrong borderpadding container"></div>
	<div class="border container"></div>
	<div class="border container"></div>
	<div class="border container"></div>
	
    <div class="container">
        <div class="row">
            <div class="left span6">
        		<p>
        			<img src="/bazar/images/bazar-logo-footer.png" class="yit-image" width="104" height="21">
        			<br>
					copyright 2013 - Bazar Theme
				</p>
			</div>
	        <div class="right span6">
		        <p style="padding-top:2px;">
		        	<a href="http://www.olbius.com/">HOME</a>
		        	// <a href="http://www.olbius.com/?page_id=8">SERVICES</a>
		        	 // <a href="http://www.olbius.com/?page_id=28">FEATURES</a>
		        	  // <a href="http://www.olbius.com/?page_id=162">OUR WORKS</a>
		        	   // <a href="http://www.olbius.com/?page_id=19">PRICING</a> <span class="hidden-tablet">
		        	   // </span><a href="http://www.olbius.com/?page_id=2" class="hidden-tablet">ABOUT US</a><br>
					<a href="http://yithemes.com/">
						<img src="/bazar/images/footer_yith_grey.png" alt="Your Inspiration Themes" style="position:relative; top:4px; margin: -11px 5px 0 0;">
					</a> 
					Powered by 
					<a href="http://yithemes.com/" title="free themes wordpress">
						<strong>Your Inspiration Themes</strong>
					</a>
				</p>
	    	</div>
    	</div>
    </div>
</div>
<!-- END COPYRIGHT -->









<!--Footer Part Start-->
<#--  



  <div class="column">
    <h3>${uiLabelMap.BigshopInformation}</h3>
    <ul>
      <li><a href="<@ofbizUrl>aboutus</@ofbizUrl>">${uiLabelMap.BigshopAboutUs}</a></li>
      <li><a href="<@ofbizUrl>delivery</@ofbizUrl>">${uiLabelMap.BigshopDeliveryInformation}</a></li>
      <li><a href="<@ofbizUrl>policies</@ofbizUrl>">${uiLabelMap.BigshopPolicy}</a></li>
    </ul>
  </div>
  <div class="column">
    <h3>${uiLabelMap.BigshopCustomerService}</h3>
    <ul>
      <li><a href="<@ofbizUrl>/checkLogin/contactus</@ofbizUrl>">${uiLabelMap.BigshopContactUs}</a></li>
      <li><a href="<@ofbizUrl>sitemaps</@ofbizUrl>">${uiLabelMap.BigshopSiteMap}</a></li>
    </ul>
  </div>
  <div class="column">
    <h3>${uiLabelMap.BigshopOtherCategories}</h3>
    <ul>
      <li><a href="<@ofbizUrl>category/~category_id=CLOTHINGS_PROMOTIONS</@ofbizUrl>">${uiLabelMap.BigshopPromotion}</a></li>
      <li><a href="<@ofbizUrl>category/~category_id=Specials</@ofbizUrl>">${uiLabelMap.BigshopSpecial}</a></li>
      <li><a href="<@ofbizUrl>category/~category_id=WhatNew</@ofbizUrl>">${uiLabelMap.BigshopLatest}</a></li>
    </ul>
  </div>
  <div class="column">
    <h3>${uiLabelMap.BigshopAccount}</h3>
    <ul>
      <li><a href="<@ofbizUrl>viewprofile</@ofbizUrl>">${uiLabelMap.CommonProfile}</a></li>
      <li><a href="<@ofbizUrl>editShoppingList</@ofbizUrl>">${uiLabelMap.EcommerceShoppingLists}</a></li>
      <li><a href="<@ofbizUrl>orderhistory</@ofbizUrl>">${uiLabelMap.EcommerceOrderHistory}</a></li>
      <li><a href="<@ofbizUrl>ListQuotes</@ofbizUrl>">${uiLabelMap.OrderOrderQuotes}</a></li>
    </ul>
  </div>
  <div class="contact">
    <ul>
      <li class="address">Ha Noi ,VietNam.</li>
      <li class="mobile">&lt;demo&gt;84 912345678</li>
      <li class="email"><a href="mailto:contact@olbius.com">contact@olbius.com</a></li>
      <li class="fax">&lt;demo&gt;84 4 12345678</li>
    </ul>
  </div>
  <div class="social"> 
  	<a href="http://facebook.com/olbius " target="_blank">
  		<img src="/bigshop/images/facebook.png" alt="Facebook" title="Facebook">
	</a> 
  	<a style="display:none" href="https://twitter.com/#!/#" target="_blank">
  		<img src="/bigshop/images/twitter.png" alt="Twitter" title="Twitter">
  	</a> 
  	<a style="display:none" href="https://plus.google.com/u/0/#" target="_blank">
  		<img src="/bigshop/images/googleplus.png" alt="Google+" title="Google+">
	</a> 
	<a style="display:none" href="http://pinterest.com/#" target="_blank">
		<img src="/bigshop/images/pinterest.png" alt="Pinterest" title="Pinterest">
	</a> 
	<a style="display:none" href="#" target="_blank">
		<img src="/bigshop/images/rss.png" alt="RSS" title="RSS">
	</a> 
	<a style="display:none" href="http://www.vimeo.com/#" target="_blank">
		<img src="/bigshop/images/vimeo.png" alt="Vimeo" title="Vimeo">
	</a> 
	<a style="display:none" href="http://www.flickr.com/photos/#" target="_blank">
		<img src="/bigshop/images/flickr.png" alt="flickr" title="Flickr">
	</a> 
	<a style="display:none" href="http://www.youtube.com/#" target="_blank">
		<img src="/bigshop/images/youtube.png" alt="YouTube" title="YouTube">
	</a> 
	<a style="display:none" href="skype:#?call" target="_blank">
		<img src="/bigshop/images/skype.png" alt="skype" title="Skype">
	</a> 
	<a style="display:none" href="#" target="_blank">
		<img src="/bigshop/images/blogger.png" alt="Blogger" title="Blogger">
	</a> 
</div>
  <div class="clear"></div>
  <div id="powered">Bigshop <a href="#">Html Template </a> &copy; 2013 &nbsp;|&nbsp; Template By <a target="_blank" href="http://olbius.com">Olbius</a>
    <div class="payments_types"> 
    	<img src="/bigshop/images/payment_paypal.png" alt="paypal" title="PayPal"> 
		<img src="/bigshop/images/payment_american.png" alt="american-express" title="American Express"> 
		<img src="/bigshop/images/payment_2checkout.png" alt="2checkout" title="2checkout"> 
		<img src="/bigshop/images/payment_maestro.png" alt="maestro" title="Maestro"> 
		<img src="/bigshop/images/payment_discover.png" alt="discover" title="Discover"> 
		<img src="/bigshop/images/payment_mastercard.png" alt="mastercard" title="MasterCard"> 
		<img src="/bigshop/images/payment_visa.png" alt="visa" title="Visa"> 
		<img src="/bigshop/images/payment_sagepay.png" alt="sagepay" title="sagepay"> 
		<img src="/bigshop/images/payment_moneybookers.png" alt="moneybookers" title="Moneybookers"> 
	</div>
  </div>

<script src="/bigshop/js/jquery.cycle2.js">
</script>
<script src="/bigshop/js/jquery.cycle2.carousel.js"></script>
<script>$('.slideshow').cycle();</script>




  -->
  
  
  
  
  <!--Footer Part End-->