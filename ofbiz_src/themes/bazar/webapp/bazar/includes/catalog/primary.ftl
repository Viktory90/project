${virtualJavaScript?if_exists}
<#if product?exists>
    <#-- variable setup -->
    <#if backendPath?default("N") == "Y">
        <#assign productUrl><@ofbizCatalogUrl productId=product.productId productCategoryId=categoryId/></#assign>
    <#else>
        <#assign productUrl><@ofbizCatalogAltUrl productId=product.productId productCategoryId=categoryId/></#assign>
    </#if>

    <#if requestAttributes.productCategoryMember?exists>
        <#assign prodCatMem = requestAttributes.productCategoryMember>
    </#if>
    
    <#assign mediumImageUrl = productContentWrapper.get("MEDIUM_IMAGE_URL")?if_exists>
    <#if !mediumImageUrl?string?has_content><#assign mediumImageUrl = "/images/defaultImage.jpg"></#if>
    <#-- end variable setup -->
    <#assign productInfoLinkId = "productInfoLink">
    <#assign productInfoLinkId = productInfoLinkId + product.productId/>
    <#assign productDetailId = "productDetailId"/>
    <#assign productDetailId = productDetailId + product.productId/>
    <#assign productName = ""/>
    
    	<div class="product-thumbnail group">     
				<div class="thumbnail-wrapper">
					<#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
						<img src="/bazar/images/icons/sale.png" alt="On sale!" class="onsale yit-image" width="71" height="68">
					</#if> 
		    		
		    		<a href="${productUrl}" class="thumb">
		                <span id="${productInfoLinkId}" class="popup_link" style="width:auto; height:auto; min-width:50px; min-height:53px;">
		                	<img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${mediumImageUrl}</@ofbizContentUrl>" class="attachment-shop_catalog wp-post-image" alt="Small Image" id="product-id"/>
	                	</span>
		            </a>
		        </div>
				<div class="product-meta">
						<h3 class="upper" style="height:37px; margin-top:10px; margin-bottom:5px">
							<#assign productName = productContentWrapper.get("PRODUCT_NAME")?if_exists/>
							<a href="${productUrl}" title="${productName}">
									<#if productName?length &lt; 55>
										${productName}
									<#else>
										${productName?substring(0, 54)} ...
									</#if>
							</a>
						</h3>
						<div class="description">
							${productContentWrapper.get("DESCRIPTION")?if_exists}  
						</div>
						<span class="price">
							<#if totalPrice?exists>
			                  	<div>
			                  		${uiLabelMap.ProductAggregatedPrice}: 
			                  		<span class='basePrice'>
			                  			<@ofbizCurrency amount=totalPrice isoCode=totalPrice.currencyUsed/>
			                  		</span>
			                  	</div>
			                <#else>
				                <#if price.competitivePrice?exists && price.price?exists && price.price?double < price.competitivePrice?double>
				                  	${uiLabelMap.ProductCompareAtPrice}: 
				                  	<span class='basePrice'>
				                  		<@ofbizCurrency amount=price.competitivePrice isoCode=price.currencyUsed/>
			                  		</span>
				                </#if>
				                
				                <#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
				                  	<del><span class="amount"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/></span></del>
				                </#if>
				                
			                	<ins><span class="amount">
					                  <#if price.isSale?exists && price.isSale>
					                    <#assign priceStyle = "salePrice">
					                  <#else>
					                    <#assign priceStyle = "regularPrice">
					                  </#if>
					                  
		                  			  <#if (price.price?default(0) > 0 && product.requireAmount?default("N") == "N")>
			                    			<#if "Y" = product.isVirtual?if_exists> 
			                    				${uiLabelMap.CommonFrom} 
			                    			</#if>
			                    			<span class="${priceStyle}">
			                    				<@ofbizCurrency amount=price.price isoCode=price.currencyUsed/>
			                    			</span>
		                  			  </#if>
			                  	</span></ins>
			                  
				                <#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
				                  	<#assign priceSaved = price.listPrice?double - price.price?double>
				                  	<#assign percentSaved = (priceSaved?double / price.listPrice?double) * 100>
				                    <span>(${percentSaved?int}%)</span>
				                </#if>
		                	</#if>
		                	
			                <#-- show price details ("showPriceDetails" field can be set in the screen definition) -->
			                <#if (showPriceDetails?exists && showPriceDetails?default("N") == "Y")>
			                    <#if price.orderItemPriceInfos?exists>
			                        <#list price.orderItemPriceInfos as orderItemPriceInfo>
			                            <div>${orderItemPriceInfo.description?if_exists}</div>
			                        </#list>
			                    </#if>
			                </#if>
						</span>
						
						<!-- start rating -->
						<div class="rating" style="height:17px">
							<#if averageRating?exists && (averageRating?double > 0) && numRatings?exists && (numRatings?long > 1)>
						          <#if (averageRating?double < 0.5)>
						            <img src="/bazar/images/basic/stars-0.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
						          <#elseif (averageRating?double >= 0.5 && averageRating?double < 1.5)>
						        	<img src="/bazar/images/basic/stars-1.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
						          <#elseif (averageRating?double >= 1.5 && averageRating?double < 2.5)>
						            <img src="/bazar/images/basic/stars-2.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
						          <#elseif (averageRating?double >= 2.5 && averageRating?double < 3.5)>
						            <img src="/bazar/images/basic/stars-3.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
						          <#elseif (averageRating?double >= 3.5 && averageRating?double < 4.5)>
						            <img src="/bazar/images/basic/stars-4.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
						          <#else>
						            <img src="/bazar/images/basic/stars-5.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">   
						          </#if>
				        	</#if>
				        </div> <!-- end rating -->
				</div> <!-- end product meta -->
				
				<!-- start wapper -->
				<div class="product-actions-wrapper">
					  <#-- check to see if introductionDate hasn't passed yet -->
			          <#if product.introductionDate?exists && nowTimestamp.before(product.introductionDate)>
			            <div style="color: red;">${uiLabelMap.ProductNotYetAvailable}</div>
			          <#-- check to see if salesDiscontinuationDate has passed -->
			          <#elseif product.salesDiscontinuationDate?exists && nowTimestamp.after(product.salesDiscontinuationDate)>
			            <div style="color: red;">${uiLabelMap.ProductNoLongerAvailable}</div>
			          <#-- check to see if it is a rental item; will enter parameters on the detail screen-->
			          <#elseif product.productTypeId?if_exists == "ASSET_USAGE">
			            <div class="cart">
			          	<a href="${productUrl}" class="button">${uiLabelMap.OrderMakeBooking}...</a>
			          	</div>
			          <#-- check to see if it is an aggregated or configurable product; will enter parameters on the detail screen-->
			          <#elseif product.productTypeId?if_exists == "AGGREGATED" || product.productTypeId?if_exists == "AGGREGATED_SERVICE">
			            <div class="cart">
			            <a href="${productUrl}" class="button">${uiLabelMap.BigshopOrderConfigure}...</a>
			            </div>
			          <#-- check to see if the product is a virtual product -->
			          <#elseif product.isVirtual?exists && product.isVirtual == "Y">
				            <div class="product-actions">   
								<div class="cart">
									<a href="${productUrl}" class="button">
						              	 ${uiLabelMap.BigshopOrderChooseVariations}... <!-- Choose Vari... -->
						            </a>
				        		</div> <!-- end cart -->
				        		  
        						<div class="buttons buttons_4 group"> 
									<!-- Button 1 DETAILS-->
									<a href="${productUrl}" rel="nofollow" title="Details" class="details" style="margin-left:40px; border-left:0">
										Details
									</a>
									
									<!-- Button 2 WISH LIST-->
									<div class="yith-wcwl-add-to-wishlist">
										<div class="yith-wcwl-add-button">
											<#--
											<a href="http://demo.yithemes.com/bazar/wp-content/themes/bazar/theme/plugins/yith_wishlist/yith-wcwl-ajax.php?action=add_to_wishlist&add_to_wishlist=552" data-product-id="552" data-product-type="simple" class="add_to_wishlist">
												Wishlist
											</a>
											-->
											<img src="/bazar/images/icons/wpspin_light.gif" class="ajax-loading" id="add-items-ajax-loading" alt="" style="visibility:hidden" width="16" height="16">
										</div>
										<div class="yith-wcwl-wishlistaddedbrowse" style="display:none;">
											<span class="feedback">Product added!</span> 
											<a href="http://demo.yithemes.com/bazar/?page_id=387">View Wishlist</a>
										</div>
										<div class="yith-wcwl-wishlistexistsbrowse" style="display:none">
											<span class="feedback">The product is already in the wishlist!</span> 
											<a href="http://demo.yithemes.com/bazar/?page_id=387">View Wishlist</a>
										</div>
										<div style="clear:both"></div>
										<div class="yith-wcwl-wishlistaddresponse"></div>
									</div>   
									
									<!-- Button 3 COMPARE -->
									<div class="woocommerce product compare-button">
										<div>
						              		<#if prodCatMem?exists && prodCatMem.quantity?exists && 0.00 < prodCatMem.quantity?double>
								                <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform" style="margin: 0;">
								                  <input type="hidden" name="add_product_id" value="${prodCatMem.productId?if_exists}"/>
								                  <input type="hidden" name="quantity" value="${prodCatMem.quantity?if_exists}"/>
								                  <input type="hidden" name="clearSearch" value="N"/>
								                  <input type="hidden" name="mainSubmitted" value="Y"/>
								                  <div class="cart">
								            		<input type="button" value="${uiLabelMap.CommonAddDefault}(${prodCatMem.quantity?string.number}) ${uiLabelMap.OrderToCart}" onclick="javascript:document.the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform.submit()" class="button">
								          	  	  </div>
								                </form>
						                		<#assign productCategory = delegator.findOne("ProductCategory", Static["org.ofbiz.base.util.UtilMisc"].toMap("productCategoryId", prodCatMem.productCategoryId), false)/>
						                		<#if productCategory.productCategoryTypeId != "BEST_SELL_CATEGORY">
								                    <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform" style="margin: 0;">
								                      <input type="hidden" name="add_product_id" value="${prodCatMem.productId?if_exists}"/>
								                      <input type="hidden" name="quantity" value="${prodCatMem.quantity?if_exists}"/>
								                      <input type="hidden" name="clearSearch" value="N"/>
								                      <input type="hidden" name="mainSubmitted" value="Y"/>
								                      <a href="javascript:document.the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform.submit()" class="buttontext">${uiLabelMap.CommonAddDefault}(${prodCatMem.quantity?string.number}) ${uiLabelMap.OrderToCart}</a>
								                    </form>
						                		</#if>
						              		</#if>
						              		
						              		<div class="wishlist" style="margin-top:-21px">
									          	<a data-product_id="${product.productId}" style="display:none;" class="compare" href="#" onclick="document.addToCompare${requestAttributes.listIndex?if_exists}form.submit();">
									          		${uiLabelMap.BigshopAddCompare}
									          	</a>
								            </div>
						              		
						              		<div class="compare">
									          	  <a href="#" class="compare" onclick="document.addToCompare${requestAttributes.listIndex?if_exists}form.submit();">
									          	  	${uiLabelMap.BigshopAddCompare}
									          	  </a>
										          <form method="post" action="<@ofbizUrl secure="${request.isSecure()?string}">addToCompare</@ofbizUrl>" name="addToCompare${requestAttributes.listIndex?if_exists}form">
										          	<input type="hidden" name="productId" value="${product.productId}"/>
										          	<input type="hidden" name="mainSubmitted" value="Y"/>	          	
										      	  </form>
									      	</div>
									    </div>
									</div> <!-- end compare-button -->
									
									<!-- Button 4 Share -->
									<a href="#" class="yit_share share">
										Share
									</a>
								</div> <!-- end 4 button -->
							</div> <!-- end product-action -->	
			          <#-- check to see if the product requires an amount -->
			          <#elseif product.requireAmount?exists && product.requireAmount == "Y">
			            <div class="cart">
			            <a href="${productUrl}" class="button">${uiLabelMap.OrderChooseAmount}...</a>
			            </div>
			          <#elseif product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
			            <div class="cart">
			            <a href="${productUrl}" class="button">${uiLabelMap.OrderRent}...</a>
			            </div>
			          <#else>		
							<div class="product-actions">   
								<div class="cart">
				        			<form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" id="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form" style="margin: 0;">
						              	<input type="hidden" name="add_product_id" value="${product.productId}"/>
						              	<input type="hidden" name="quantity" value="1"/>
						              	<input type="hidden" name="clearSearch" value="N"/>
						              	<input type="hidden" name="mainSubmitted" value="Y"/>
				              
				            			<input type="button" value="${uiLabelMap.OrderAddToCart}" onclick="javascript:document.getElementById('the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form').submit();" class="button add_to_cart_button button product_type_simple">
				          	  
							            <#if mainProducts?has_content>
							                <input type="hidden" name="product_id" value=""/>
							                <select name="productVariantId" onchange="javascript:displayProductVirtualId(this.value, '${product.productId}', this.form);">
							                    <option value="">Select Unit Of Measure</option>
							                    <#list mainProducts as mainProduct>
							                        <option value="${mainProduct.productId}">${mainProduct.uomDesc} : ${mainProduct.piecesIncluded}</option>
							                    </#list>
							                </select>
							                <div style="display: inline-block;">
							                    <strong><span id="product_id_display"> </span></strong>
							                    <strong><span id="variant_price_display"> </span></strong>
							                </div>
							            </#if>
				            		</form>
				        		</div> <!-- end cart -->
				        		
				        		<div class="buttons buttons_4 group"> 
									<!-- Button 1 DETAILS-->
									<a href="${productUrl}" rel="nofollow" title="Details" class="details" style="margin-left:40px; border-left:0">
										Details
									</a>
									
									<!-- Button 2 WISH LIST-->
									<div class="yith-wcwl-add-to-wishlist">
										<div class="yith-wcwl-add-button">
											<#--
											<a href="http://demo.yithemes.com/bazar/wp-content/themes/bazar/theme/plugins/yith_wishlist/yith-wcwl-ajax.php?action=add_to_wishlist&add_to_wishlist=552" data-product-id="552" data-product-type="simple" class="add_to_wishlist">
												Wishlist
											</a>
											-->
											<img src="/bazar/images/icons/wpspin_light.gif" class="ajax-loading" id="add-items-ajax-loading" alt="" style="visibility:hidden" width="16" height="16">
										</div>
										<div class="yith-wcwl-wishlistaddedbrowse" style="display:none;">
											<span class="feedback">Product added!</span> 
											<a href="http://demo.yithemes.com/bazar/?page_id=387">View Wishlist</a>
										</div>
										<div class="yith-wcwl-wishlistexistsbrowse" style="display:none">
											<span class="feedback">The product is already in the wishlist!</span> 
											<a href="http://demo.yithemes.com/bazar/?page_id=387">View Wishlist</a>
										</div>
										<div style="clear:both"></div>
										<div class="yith-wcwl-wishlistaddresponse"></div>
									</div>
									
									
									<!-- Button 3 COMPARE -->
									<div class="woocommerce product compare-button">
										<div>
						              		<div class="wishlist" style="margin-top: -21px;">
									          	<a data-product_id="${product.productId}" style="display:none;" class="compare" href="#" onclick="document.addToCompare${requestAttributes.listIndex?if_exists}form.submit();">
									          		${uiLabelMap.BigshopAddCompare}
									          	</a>
								            </div>
						              		
						              		<div class="compare">
									          	  <a href="#" class="compare" onclick="document.getElementById('addToCompare${requestAttributes.listIndex?if_exists}form').submit();">
									          	  	${uiLabelMap.BigshopAddCompare}
									          	  </a>
										          <form method="post" action="<@ofbizUrl secure="${request.isSecure()?string}">addToCompare</@ofbizUrl>" id="addToCompare${requestAttributes.listIndex?if_exists}form" name="addToCompare${requestAttributes.listIndex?if_exists}form">
										          	<input type="hidden" name="productId" value="${product.productId}"/>
										          	<input type="hidden" name="mainSubmitted" value="Y"/>	          	
										      	  </form>
									      	</div>
									    </div>
									</div> <!-- end compare-button -->
									
									<!-- Button 4 Share -->
									<a href="#" class="yit_share share">
										Share
									</a>
								</div> <!-- end 4 button -->
							</div> <!-- end product-action -->				
		          	 </#if>	
				</div> <!-- end wapper -->
				
				<div class="product-share">
					<div class="socials">
						<h2>Share on: </h2>
						<div class="socials-default-small facebook-small default">
							<a href="https://www.facebook.com/sharer.php?u=http%3F%2F%2Fdev.olbius.com${productUrl}" class="socials-default-small default facebook" target="_blank">
								facebook
							</a>
						</div>
						<div class="socials-default-small twitter-small default">
							<a href="https://twitter.com/share?url=http%3A%2F%2Fdev.olbius.com${productUrl}" class="socials-default-small default twitter" target="_blank">
								twitter
							</a>
						</div>
						<div class="socials-default-small google-small default">
							<a href="https://plusone.google.com/_/+1/confirm?hl=en&url=http%3A%2F%2Fdev.olbius.com${productUrl}" class="socials-default-small default google" target="_blank">
								google
							</a>
						</div>
						<div class="socials-default-small pinterest-small default">
							<a href="http://pinterest.com/pin/create/button/?url=http%3A%2F%2Fdev.olbius.com${productUrl}" class="socials-default-small default pinterest" target="_blank">
								pinterest
							</a>
						</div>
					</div>
				</div>
				
		</div> <!-- end product-thumbnail -->

    
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br />
</#if>