<script type="text/javascript">
//<![CDATA[
function removeSelected_2(item_index){
	var cform = document.getElementById('cartform');
    document.getElementById('removeSelected').value = true;
    var checkbox = document.getElementById('cartItemDisplayCheckBox_' + item_index);
    checkbox.checked = true;
    cform.submit();
}
//]]>
</script>

<#--
cform.removeSelected.value = true;
 -->

<!-- START BG SHADOW -->
<div class="bg-shadow">
    
	<!-- START WRAPPER -->
    <div id="wrapper" class="container group">
		
		<!-- START TOP BAR -->
		<div id="topbar" class="hidden-phone">
			<div class="container">
				<div class="row">
					<div class="span12">
						<div id="topbar-left"></div>
						<div id="topbar-right">
							
								
							
							
							<#-- Here -->
							<div class="topbar_login widget ">
							<#if userLogin?has_content && userLogin.userLoginId != "anonymous">
								<span class="welcome_username">${uiLabelMap.CommonWelcome}, ${sessionAttributes.autoName?html}</span>
								<span> / </span>
								<a href="<@ofbizUrl>viewprofile</@ofbizUrl>">My Account</a>
								<span>/</span>
								<a href="<@ofbizUrl>logout</@ofbizUrl>">${uiLabelMap.CommonLogout}</a>
							<#else>
								<a href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>">${uiLabelMap.CommonLogin}</a>
								<span> / </span>
								<a href="<@ofbizUrl>newcustomer</@ofbizUrl>">${uiLabelMap.EcommerceRegister}</a>
							</#if>
							</div>
							<script type="text/javascript">
									function opencompare(){
										var params = [
									    'height='+screen.height,
									    'width='+screen.width,
									    'fullscreen=yes' // only works in IE, but here for completeness
										].join(',');
										     // and any other options from
										     // https://developer.mozilla.org/en/DOM/window.open
										
										var popup = window.open('<@ofbizUrl>compareProducts</@ofbizUrl>', 'compareProducts', params); 
										popup.moveTo(0,0);
									}
								</script>
							
							
							
							
							<div class="hide-topbar " style="display: inline;">
    							<div id="icl_lang_sel_widget" class="widget-1 widget-first widget icl_languages_selector">
    								<div id="lang_sel">
    									<ul>
        									<li><#include "language.ftl"></li>
										</ul>    
									</div>
								</div>
								<div id="nav_menu-2" class="widget-2 widget-last widget widget_nav_menu">
									<div class="menu-top-menu-container">
										<ul id="menu-top-menu" class="menu">
											<#--
											<li id="menu-item-577" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-577">
												<a href="http://demo.yithemes.com/bazar/wishlist/">
													MY WISHLIST
												</a>
											</li>
											-->
											<li class="menu-item menu-item-type-custom menu-item-object-custom">
												<a href="#" onclick="opencompare();">
													COMPARE
												</a>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="border"></div>
				<div class="border"></div>
				<div class="border"></div>
				<div class="border borderstrong"></div>
			</div>
		</div>
		<!-- END TOP BAR -->
		
		
		<!-- START HEADER -->
        <div id="header" class="group margin-bottom"> 
			<div class="group container">               
    			<div class="row" id="logo-headersidebar-container">            
        			<!-- START LOGO -->
    				<div id="logo" class="group">
    	    			<a id="textual" href="http://localhost:8080/bazarstore" title="Bazar [SHOP]">
    						Bazar <span class="title-highlight">SHOP</span>
    					</a>
						<p id="tagline">usable and clean e-commerce theme</p> 
    				</div> <!-- END LOGO -->
    				
    				
    				<div id="header-cart-search">
    					<#assign shoppingCart = sessionAttributes.shoppingCart?if_exists>
						<#if shoppingCart?has_content>
						    <#assign shoppingCartSize = shoppingCart.size()>
						<#else>
						    <#assign shoppingCartSize = 0>
						</#if>
        				<div class="cart-row group">
				            <div class="cart-items cart-items-icon">
				                <span class="cart-items-number">${shoppingCart.getTotalQuantity()}</span>
				                <span class="cart-items-label">
									<#if shoppingCart.getTotalQuantity() == 1>
				        				${uiLabelMap.BigshopOrderItems}
				        			<#else>
				        				${uiLabelMap.BigshopOrderItems}
				        			</#if>
								</span>
				            </div>

	            			<div class="cart-subtotal" style="text-transform:none !important; font-size:14pt !important;">
	            				<#assign cartGrant = shoppingCart.getDisplayGrandTotal()>
	            				<#assign cartInteger = cartGrant?floor>
	            				<#assign cartDecimal = 0>
	            				<#if cartInteger == 0>
	            					<#assign cartDecimal = (cartGrant*100)?ceiling>
	            				<#else>
	            					<#assign cartDecimal = ((cartGrant - cartInteger)?number * 100)?ceiling>
	            				</#if>
	                            <span class="cart-subtotal-currency">${shoppingCart.getCurrency()}</span>
	                            <span class="cart-subtotal-integer">${cartInteger}</span>
	            				<span class="cart-subtotal-decimal">${cartDecimal}</span>
	                        </div>



                        	
                        	
                        	<div class="widget woocommerce widget_shopping_cart">
                        		<div class="border-1 border">
                        			<div class="border-2 border">
                        				<h2 class="widgettitle">Cart</h2>				
	                        			<#if shoppingCartSize == 0>
											<a href="<@ofbizUrl>showcart</@ofbizUrl>" class="cart_control" style="display: none;">
		                        				View Cart
		                        			</a>
		            						<a class="cart_control cart_control_empty">Empty Cart</a>
											<div class="cart_wrapper" style="display: none;">
												<div class="widget_shopping_cart_content">
													<ul class="cart_list product_list_widget ">
														<li class="empty">No products in the cart.</li>
				
														<div class="empty-buttons">
															<a href="http://demo.yithemes.com/bazar/shop/" class="button">Go to the shop</a>
														</div>
													</ul>
												</div>			
											</div>
										<#else>
											
											<form method="post" action="<@ofbizUrl>modifycart</@ofbizUrl>" name="cartform" id="cartform" style="right:-140px">
        										<input type="hidden" id="removeSelected" name="removeSelected" value="false" />
        										<a href="<@ofbizUrl>showcart</@ofbizUrl>" class="cart_control">
							        				View Cart
							        			</a>
												<div class="cart_wrapper" style="display: none;">
													<div class="widget_shopping_cart_content">
														<ul class="cart_list product_list_widget ">
															<#assign itemsFromList = false />
													        <#assign promoItems = false />
													        <#list shoppingCart.items() as cartLine>
														        <#assign cartLineIndex = shoppingCart.getItemIndex(cartLine) />
																<#assign lineOptionalFeatures = cartLine.getOptionalProductFeatures() />
															<li>
																<a href="http://demo.yithemes.com/bazar/shop/bag/">
																	<#assign smallImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher)?if_exists />
									                    			<#if !smallImageUrl?string?has_content>
									                    				<#assign smallImageUrl = "/images/defaultImage.jpg" />
									                    			</#if>
									                    			<#if smallImageUrl?string?has_content>
									                        			<img width="100" height="80" src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" class="attachment-shop_thumbnail wp-post-image" />
									                    			</#if>
																</a>
																<a href="http://demo.yithemes.com/bazar/shop/bag/" class="name">
																	<#if cartLine.getProductId()?exists>
																		<#assign itemName = cartLine.getName()>
																		<#if itemName?length &gt; 15>
																			<#assign itemName = itemName?substring(0, 14) + " ...">
																		</#if>
										                      			<#if cartLine.getParentProductId()?exists>
										                          			<a href="<@ofbizCatalogAltUrl productId=cartLine.getParentProductId()/>" class="invarseColor" title="${cartLine.getName()}">${itemName}</a>
										                      			<#else>
										                          			<a href="<@ofbizCatalogAltUrl productId=cartLine.getProductId()/>" class="invarseColor"  title="${cartLine.getName()}">${itemName}</a>
										                      			</#if>
										                  			<#else>
										                    			<strong>${cartLine.getItemTypeDescription()?if_exists}</strong>
										                  			</#if>
										                  			<#if cartLine.getIsPromo()><br/><strong>${uiLabelMap.BigshopPromo}<strong></#if>
																</a>
																<#if !cartLine.getIsPromo()>
											            			<a id="cartItemDisplayRemove_${cartLineIndex}" onclick="removeSelected_2(${cartLineIndex});" style="cursor:pointer" class="remove_item" title="Remove this item">
																		remove
																	</a>
											            			<div class="total" style="display:none"><input id="cartItemDisplayCheckBox_${cartLineIndex}" type="checkbox" name="selectedItem" value="${cartLineIndex}" /></div>
										            			<#else>
										            				&nbsp;
										            			</#if>
																<span class="quantity">
																	${cartLine.getQuantity()?string.number} × 
																	<span class="amount">
																	 	<@ofbizCurrency amount=cartLine.getBasePrice() isoCode=shoppingCart.getCurrency()/>
																	 </span>
																 </span>
																
																<div class="border clear"></div>
															</li>
															</#list>
														</ul>
														
														<p class="total">${uiLabelMap.EcommerceCartTotal}: 
															<span class="amount">
																<@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/>
															</span>
														</p>
														<p class="buttons">
															<a href="<@ofbizUrl>showcart</@ofbizUrl>" class="button">${uiLabelMap.OrderViewCart}</a>
															<a href="<@ofbizUrl>checkoutoptions</@ofbizUrl>" class="button">${uiLabelMap.OrderCheckout}</a>
														</p>
													</div>
												</div>
        									</form>
										</#if>
			
										<script type="text/javascript">
											jQuery(document).ready(function($){
												$(document).on('click', '.cart_control', function(e){
													//e.preventDefault();
												});
												
												$(document).on('hover', '.cart_control', function(){
													$(this).next('.cart_wrapper').slideDown();
												}).on('mouseleave', '.cart_control', function(){
													$(this).next('.cart_wrapper').delay(500).slideUp();
												});
												
												
											    $(document).on('mouseenter', '.cart_wrapper', function(){ $(this).stop(true,true).show() })
								                $(document).on('mouseleave', '.cart_wrapper', function(){ $(this).delay(500).slideUp() });
											});
										</script>
									</div>
								</div>
							</div>  
                        	
                        	                        
						</div>
    
        			<div class="widget widget_search_mini">
						<form  name="keywordsearchform" method="post" action="<@ofbizUrl>keywordsearch</@ofbizUrl>" class="search_mini">
							<input type="hidden" name="VIEW_SIZE" value="10" />
							<input type="hidden" name="PAGING" value="Y" />
							<#if productCategory?exists>
								<input type="hidden" name="SEARCH_CATEGORY_ID" value="${productCategory.productCategoryId?if_exists}" />
								
							</#if>
							<button type="submit" class="button-search" style="visibility:hidden"></button>
							<input type="text" value="" id="search_mini" name="SEARCH_STRING" placeholder="search for products">
						</form>
					</div>    
				</div>
				
				
				<!-- START HEADER SIDEBAR -->
				<div id="header-sidebar" class="group hidden-phone">                                                     
					<div id="text-image-2" class="widget-1 widget-first widget text-image" style="width:196px">
						<div class="text-image" style="text-align:left;">
							<img src="/bazar/images/widget1.png" alt="" width="36" height="43">
						</div>
						<h3>ANOTHER WIDGET</h3>
						<p>ADD ICON AND TEXT</p>
					</div>
					<div id="text-image-3" class="widget-2 widget text-image">
						<div class="text-image" style="text-align:left">
							<img src="/bazar/images/widget221.png" alt="" width="16" height="43">
						</div>
						<h3>CUSTOMER SUPPORT</h3>
						<p>+ 39 097 372659</p>
					</div>
					<div id="text-2" class="widget-3 widget-last widget widget_text">
						<div class="textwidget">
							LOVE IS SHARING &nbsp; &nbsp; &nbsp;
							<div class="socials-default-small facebook-small default">
								<a href="http://dev.olbius.com/bazastore/" class="socials-default-small default facebook">facebook</a>
							</div>
							<div class="socials-default-small rss-small default">
								<a href="http://dev.olbius.com/bazastore/" class="socials-default-small default rss">rss</a>
							</div>

							<div class="socials-default-small twitter-small default">
								<a href="http://dev.olbius.com/bazastore/" class="socials-default-small default twitter">twitter</a>
							</div>

							<div class="socials-default-small google-small default">
								<a href="http://dev.olbius.com/bazastore/" class="socials-default-small default google">google</a>
							</div>

							<div class="socials-default-small linkedin-small default">
								<a href="http://dev.olbius.com/bazastore/" class="socials-default-small default linkedin">linkedin</a>
							</div>

							<div class="socials-default-small pinterest-small default">
								<a href="http://dev.olbius.com/bazastore/" class="socials-default-small default pinterest">pinterest</a>
							</div>
						</div>
					</div>	
				</div> 
    		</div>
		</div>       
    	
    <div class="border container" style="margin-top:-4px"></div>
    	<!-- NAV -->
        <!-- END HEADER -->
  	</div>
</div>

  <#include "headerCssFooter.ftl">
</div>