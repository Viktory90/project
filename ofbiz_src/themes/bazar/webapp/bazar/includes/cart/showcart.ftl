<#assign fixedAssetExist = shoppingCart.containAnyWorkEffortCartItems() /> <#-- change display format when rental items exist in the shoppingcart -->


<#if (shoppingCartSize > 0)>
	<!--  -->
<#else>
	<!--  -->
</#if>


<style type="text/css">
	.product-name{
		max-width:520px;
	}
	.product-remove{
		min-width:25px;
	}
	.product-thumbnail{
		min-width:45px !important;
	}
	input.checkout-button, a.checkout-button{
		background-color: #4f4f4f !important;
		background-position: left center !important;
		padding-left: 40px !important;
	}
	
	a.checkout-button {
		padding-left:0px;
	}
	
	input.checkout-button:hover, a.checkout-button:hover{
		background-color: #868686 !important;
	}
	
	.shop_table.cart .coupon #coupon_code {
		height: 30px;
		width: 150px !important;
		box-shadow: none !important;
	}
</style>


<div id="primary" class="sidebar-no">
	<div class="container group">
		<div class="row">
			<!-- START CONTENT -->
			<div id="content-page" class="span12 content group">
				<div id="post-389"
					class="post-389 page type-page status-publish hentry group instock">
					<div class="woocommerce">
<a href="<@ofbizUrl>main</@ofbizUrl>" class="button">${uiLabelMap.EcommerceContinueShopping}</a>
<br /><br/>
<#if (shoppingCartSize > 0)>
    					<form id="cartform" method="post" action="<@ofbizUrl>modifycart</@ofbizUrl>" name="cartform">
    
							<table class="shop_table cart" cellspacing="0">
								<thead>
									<tr>
										<th class="product-remove">&nbsp;</th>
										<th class="product-thumbnail">&nbsp;</th>
										<th class="product-name">${uiLabelMap.OrderProduct}</th>
										
									  <#if asslGiftWraps?has_content && productStore.showCheckoutGiftOptions?if_exists != "N">>
						                <th scope="row">
						                  <select class="selectBox" name="GWALL" onchange="javascript:gwAll(this);">
						                    <option value="">${uiLabelMap.EcommerceGiftWrapAllItems}</option>
						                    <option value="NO^">${uiLabelMap.EcommerceNoGiftWrap}</option>
						                    <#list allgiftWraps as option>
						                      <option value="${option.productFeatureId}">${option.description} : ${option.defaultAmount?default(0)}</option>
						                    </#list>
						                  </select>
						                 </th>
						              <#else>
						                <th scope="row">&nbsp;</th>
						              </#if>			
										
										<th class="product-price">${uiLabelMap.EcommerceUnitPrice}</th>
										<th class="product-price">${uiLabelMap.EcommerceAdjustments}</th>
										<th class="product-quantity">
											<#if fixedAssetExist == true>
								                    <table>
								                        <tr>
								                            <td>- ${uiLabelMap.EcommerceStartDate} -</td>
								                            <td>- ${uiLabelMap.EcommerceNbrOfDays} -</td>
								                        </tr>
								                        <tr>
								                            <td >- ${uiLabelMap.EcommerceNbrOfPersons} -</td>
								                            <td >- ${uiLabelMap.CommonQuantity} -</td>
								                        </tr>
								                    </table>
								              <#else>
								                	${uiLabelMap.CommonQuantity}
								              </#if>
										</th>
										<th class="product-subtotal">${uiLabelMap.EcommerceItemTotal}</th>
									</tr>
								</thead>
								<tbody>

		<#assign itemsFromList = false />
        <#assign promoItems = false />
        <#list shoppingCart.items() as cartLine>

          <#assign cartLineIndex = shoppingCart.getItemIndex(cartLine) />
          <#assign lineOptionalFeatures = cartLine.getOptionalProductFeatures() />
          <#-- show adjustment info -->
          <#list cartLine.getAdjustments() as cartLineAdjustment>
            <!-- cart line ${cartLineIndex} adjustment: ${cartLineAdjustment} -->
          </#list>
          
          
				<tr class="cart_table_item" id="cartItemDisplayRow_${cartLineIndex}">
					<!-- Remove from cart link -->
					<td class="product-remove">
						<input type="hidden" id="removeSelected" name="removeSelected" value="false" />
						<a id="cartItemDisplayRemove_${cartLineIndex}" onclick="removeSelected_2(${cartLineIndex});" style="cursor:pointer" class="remove" title="Remove this item">
							×
						</a>
					</td>

					<!-- The thumbnail -->
					<#if cartLine.getProductId()?exists>
	                    <#-- product item -->
	                    <#-- start code to display a small image of the product -->
	                    <#if cartLine.getParentProductId()?exists>
	                      <#assign parentProductId = cartLine.getParentProductId() />
	                    <#else>
	                      <#assign parentProductId = cartLine.getProductId() />
	                    </#if>
	                    <#assign smallImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher)?if_exists />
	                    <#if !smallImageUrl?string?has_content>
	                    	<#assign smallImageUrl = "/images/defaultImage.jpg" />
	                    </#if>
	                    <#if smallImageUrl?string?has_content>
				            <td class="image product-thumbnail">
			                     <a href="<@ofbizCatalogAltUrl productId=parentProductId/>">
			                        <img src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" class="attachment-shop_thumbnail wp-post-image" />
			                     </a>
				            </td>
	                    <#else>
	                     	<td class="product-thumbnail"></td>
	                    </#if>
	                    
	                    
	                    <#-- end code to display a small image of the product -->
            			<!-- Product Name -->
						<td class="product-name">        
			                    <#-- ${cartLineIndex} - -->
			                    <a href="<@ofbizCatalogAltUrl productId=parentProductId/>" class="linktext">
			                    	${cartLine.getProductId()} -
		                    		${cartLine.getName()?if_exists}
		            			</a> : ${cartLine.getDescription()?if_exists}
                				
                				<#-- For configurable products, the selected options are shown -->
                    	<#if cartLine.getConfigWrapper()?exists>
                      		<#assign selectedOptions = cartLine.getConfigWrapper().getSelectedOptions()?if_exists />
                      		<#if selectedOptions?exists>
                        		<div>&nbsp;</div>
                        		<#list selectedOptions as option>
			                          <div>
			                            ${option.getDescription()}
			                          </div>
                        		</#list>
                      		</#if>
                    	</#if>

	                    <#-- if inventory is not required check to see if it is out of stock and needs to have a message shown about that... -->
	                    <#assign itemProduct = cartLine.getProduct() />
	                    <#assign isStoreInventoryNotRequiredAndNotAvailable = Static["org.ofbiz.product.store.ProductStoreWorker"].isStoreInventoryRequiredAndAvailable(request, itemProduct, cartLine.getQuantity(), false, false) />
	                    <#if isStoreInventoryNotRequiredAndNotAvailable && itemProduct.inventoryMessage?has_content>
	                        (${itemProduct.inventoryMessage})
	                    </#if>
	                    
	                <#else>
	                	<#-- this is a non-product item -->
	            		<td>${cartLine.getItemTypeDescription()?if_exists}: ${cartLine.getName()?if_exists}
	                </#if>
	                    
		                    <#assign attrs = cartLine.getOrderItemAttributes()/>
			                <#if attrs?has_content>
			                    <#assign attrEntries = attrs.entrySet()/>
			                    <ul>
			                    	<#list attrEntries as attrEntry>
				                        <li>
				                            ${attrEntry.getKey()} : ${attrEntry.getValue()}
				                        </li>
				                    </#list>
			                    </ul>
			                </#if>
		                
		              		<#if (cartLine.getIsPromo() && cartLine.getAlternativeOptionProductIds()?has_content)>
				                  <#-- Show alternate gifts if there are any... -->
				                  <div class="tableheadtext">${uiLabelMap.OrderChooseFollowingForGift}:</div>
		                  
				                  <select name="dummyAlternateGwpSelect${cartLineIndex}" onchange="setAlternateGwp(this);" class="selectBox">
				                  		<option value="">- ${uiLabelMap.OrderChooseAnotherGift} -</option>
						                  <#list cartLine.getAlternativeOptionProductIds() as alternativeOptionProductId>
						                    <#assign alternativeOptionName = Static["org.ofbiz.product.product.ProductWorker"].getGwpAlternativeOptionName(dispatcher, delegator, alternativeOptionProductId, requestAttributes.locale) />
						                    <option value="<@ofbizUrl>setDesiredAlternateGwpProductId?alternateGwpProductId=${alternativeOptionProductId}&alternateGwpLine=${cartLineIndex}</@ofbizUrl>">${alternativeOptionName?default(alternativeOptionProductId)}</option>
						                  </#list>
				                  </select>
				                  
				                  <#-- this is the old way, it lists out the options and is not as nice as the drop-down
				                  <ul>
				                  <#list cartLine.getAlternativeOptionProductIds() as alternativeOptionProductId>
				                    <#assign alternativeOptionName = Static["org.ofbiz.product.product.ProductWorker"].getGwpAlternativeOptionName(delegator, alternativeOptionProductId, requestAttributes.locale) />
				                    <li><a href="<@ofbizUrl>setDesiredAlternateGwpProductId?alternateGwpProductId=${alternativeOptionProductId}&alternateGwpLine=${cartLineIndex}</@ofbizUrl>" class="button">Select: ${alternativeOptionName?default(alternativeOptionProductId)}</a></li>
				                  </#list>
				                  </ul>
				                  -->
		                	</#if>
		                
		            			<br/>
			                <#if cartLine.getShoppingListId()?exists>
				                  <#assign itemsFromList = true />
				                  <a href="<@ofbizUrl>editShoppingList?shoppingListId=${cartLine.getShoppingListId()}</@ofbizUrl>" class="linktext">
				                  	L
				                  </a>&nbsp;&nbsp;
			                <#elseif cartLine.getIsPromo()>
				                  <#assign promoItems = true />
				                  <a href="<@ofbizUrl>view/showcart</@ofbizUrl>" class="button">
				                  	${uiLabelMap.BigshopPromo}
				                  </a>&nbsp;&nbsp;
			                <#else>
			                	  &nbsp;
			                </#if>
		            	</td>
	                    
	                    
	                    <#-- gift wrap option -->
			            <#assign showNoGiftWrapOptions = false />
			            <td>
				              <#assign giftWrapOption = lineOptionalFeatures.GIFT_WRAP?if_exists />
				              <#assign selectedOption = cartLine.getAdditionalProductFeatureAndAppl("GIFT_WRAP")?if_exists />
				              <#if giftWrapOption?has_content>
					                <select class="selectBox" name="option^GIFT_WRAP_${cartLineIndex}" onchange="javascript:document.cartform.submit()">
						                  <option value="NO^">${uiLabelMap.EcommerceNoGiftWrap}</option>
						                  <#list giftWrapOption as option>
						                    <option value="${option.productFeatureId}" <#if ((selectedOption.productFeatureId)?exists && selectedOption.productFeatureId == option.productFeatureId)>selected="selected"</#if>>${option.description} : ${option.amount?default(0)}</option>
						                  </#list>
					                </select>
				              <#elseif showNoGiftWrapOptions>
					                <select class="selectBox" name="option^GIFT_WRAP_${cartLineIndex}" onchange="javascript:document.cartform.submit()">
					                  	<option value="">${uiLabelMap.EcommerceNoGiftWrap}</option>
					                </select>
				              <#else>
				                	&nbsp;
				              </#if>
			            </td>
			            <#-- end gift wrap option -->
	                    

						<!-- Product price -->
						<td class="product-price">
							<span class="amount"><@ofbizCurrency amount=cartLine.getDisplayPrice() isoCode=shoppingCart.getCurrency()/></span>
						</td>
						
						
						
						<!-- Product price -->
						<td class="product-price">
							<span class="amount"><@ofbizCurrency amount=cartLine.getOtherAdjustments() isoCode=shoppingCart.getCurrency()/></span>
						</td>





						<!-- Quantity inputs -->
						<td class="product-quantity">
							<div class="quantity buttons_added">
							<#if cartLine.getIsPromo() || cartLine.getShoppingListId()?exists>
		                       <#if fixedAssetExist == true>
			                        <#if cartLine.getReservStart()?exists>
			                            <table >
			                                <tr>
			                                    <td>&nbsp;</td>
			                                    <td>${cartLine.getReservStart()?string("yyyy-mm-dd")}</td>
			                                    <td>${cartLine.getReservLength()?string.number}</td></tr>
			                                <tr>
			                                    <td>&nbsp;</td>
			                                    <td>${cartLine.getReservPersons()?string.number}</td>
			                                    <td>
			                        <#else>
			                            <table >
			                                <tr>
			                                    <td >--</td>
			                                    <td>--</td>
			                                </tr>
			                                <tr>
			                                    <td>--</td>
			                                    <td>    
			                        </#if>
		                        
			                        ${cartLine.getQuantity()?string.number}
				                        		</td>
			                        		</tr>
		                        		</table>
			                    <#else><#-- fixedAssetExist -->
			                        ${cartLine.getQuantity()?string.number}
			                    </#if>
			                <#else><#-- Is Promo or Shoppinglist -->
		                        <#if fixedAssetExist == true>
		                        	<#if cartLine.getReservStart()?exists>
		                        		<table>
		                        			<tr>
		                        				<td>&nbsp;</td>
		                        				<td><input type="text" class="inputBox" size="10" name="reservStart_${cartLineIndex}" value=${cartLine.getReservStart()?string}/></td>
		                        				<td><input type="text" class="inputBox" size="2" name="reservLength_${cartLineIndex}" value="${cartLine.getReservLength()?string.number}"/></td>
	                        				</tr>
	                        				<tr>
	                        					<td>&nbsp;</td>
	                        					<td><input type="text" class="inputBox" size="3" name="reservPersons_${cartLineIndex}" value=${cartLine.getReservPersons()?string.number} /></td>
	                        					<td>
                					<#else>
	                           			<table>
	                           				<tr>
	                           					<td>--</td>
	                           					<td>--</td>
                           					</tr>
                           					<tr>
                           						<td>--</td>
                           						<td>
                   					</#if>
                   									<input type="button" value="-" class="minus">
													<input type="number" name="update_${cartLineIndex}" step="1"
														min="" max="" size="4" title="Qty" class="input-text qty text" maxlength="12" 
														value="${cartLine.getQuantity()?string.number}">
													<input type="button" value="+" class="plus">
		                        				</td>
		                        			</tr>
		                        		</table>
			                    <#else><#-- fixedAssetExist -->
			                    		<input type="button" value="-" class="minus">
										<input type="number" name="update_${cartLineIndex}" step="1"
											min="" max="" size="4" title="Qty" class="input-text qty text" maxlength="12" 
											value="${cartLine.getQuantity()?string.number}">
										<input type="button" value="+" class="plus">
			                    </#if>
			                </#if>
			                </div>
						</td>
						
						
						
						
						
						<!-- Product subtotal -->
						<td class="product-subtotal">
							<span class="amount"><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></span>
						</td>
					</tr>
									
					</#list>
					
					
					
					
					
					
									
					<tr>
						<td colspan="8" class="actions">

							<!-- HERE HERE !!! coupon -->
							
							
							
							<!-- <a href="javascript:document.cartform.submit();" class="button"></a> -->
							
							<input type="submit" class="button" name="update_cart" value="${uiLabelMap.EcommerceRecalculateCart}"> 
							
							
							<a href="<@ofbizUrl>checkoutoptions</@ofbizUrl>" class="button alt checkout-button" style="height:20px">${uiLabelMap.OrderCheckout}</a>
							<!-- <input type="submit" class="checkout-button button alt" name="proceed" value="Proceed to Checkout ->">  -->
							
							
							
							
							
							<input type="hidden" id="_n" name="_n" value="59a3ed39ba">
							<input type="hidden" name="_wp_http_referer" value="/bazar/cart/">
						</td>
					</tr>
					
					
					
					
					
								</tbody>
							</table>
						
		
		<div class="cart-collaterals row-fluid">
			
			<!-- HERE HERE !!! quick add -->
		
		
		
			<div class="span6 cart_totals" style="margin-top:60px">
				<div class="border-1 border">
					<div class="border-2 border">
						<h2>Cart Totals</h2>
						<table align="right" cellspacing="0" cellpadding="0">
							<tbody>
								<#if shoppingCart.getAdjustments()?has_content>
						            <tr class="cart-subtotal">
						              <td><b>${uiLabelMap.CommonSubTotal}:</b></td>
						              <td><strong><span class="amount"><@ofbizCurrency amount=shoppingCart.getDisplaySubTotal() isoCode=shoppingCart.getCurrency()/></span></strong></td>
						            </tr>
						            <#if (shoppingCart.getDisplayTaxIncluded() > 0.0)>
						              <tr>
						                <th>${uiLabelMap.OrderSalesTaxIncluded}:</th>
						                <td><@ofbizCurrency amount=shoppingCart.getDisplayTaxIncluded() isoCode=shoppingCart.getCurrency()/></td>
						              </tr>
						            </#if>
						            <#list shoppingCart.getAdjustments() as cartAdjustment>
						              <#assign adjustmentType = cartAdjustment.getRelatedOne("OrderAdjustmentType", true) />
						              <tr>
						                <td>
						                    ${uiLabelMap.EcommerceAdjustment} - ${adjustmentType.get("description",locale)?if_exists}
						                    <#if cartAdjustment.productPromoId?has_content><a href="<@ofbizUrl>showPromotionDetails?productPromoId=${cartAdjustment.productPromoId}</@ofbizUrl>" class="button">${uiLabelMap.CommonDetails}</a></#if>:
						                </td>
						                <td><@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) isoCode=shoppingCart.getCurrency()/></td>
						              </tr>
						            </#list>
								</#if>
						        <tr>
						          <td><b>${uiLabelMap.EcommerceCartTotal}:</b></td>
						          <td><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></td>
						        </tr>
						        <#if itemsFromList>
						        <tr>
						          <td colspan="2">L - ${uiLabelMap.EcommerceItemsfromShopingList}.</td>
						        </tr>
						        </#if>
						        <#if promoItems>
						        <tr>
						          <td colspan="2">P - ${uiLabelMap.EcommercePromotionalItems}.</td>
						        </tr>
						        </#if>
						        <#if !itemsFromList && !promoItems>
							        <tr>
							        	<td>&nbsp;</td>
							          	<td>&nbsp;</td>
							        </tr>
						        </#if>
						        <tr>
						          <td colspan="2">
						              <#if sessionAttributes.userLogin?has_content && sessionAttributes.userLogin.userLoginId != "anonymous">
						              <select name="shoppingListId" class="selectBox">
						                <#if shoppingLists?has_content>
						                  <#list shoppingLists as shoppingList>
						                    <option value="${shoppingList.shoppingListId}">${shoppingList.listName}</option>
						                  </#list>
						                </#if>
						                <option value="">---</option>
						                <option value="">${uiLabelMap.OrderNewShoppingList}</option>
						              </select>
						              
						              <a href="javascript:addToList();" class="button">${uiLabelMap.EcommerceAddSelectedtoList}</a>&nbsp;&nbsp;
						              <#else>
						               ${uiLabelMap.OrderYouMust} <a href="<@ofbizUrl>checkLogin/showcart</@ofbizUrl>" class="button">${uiLabelMap.CommonBeLogged}</a>
						                ${uiLabelMap.OrderToAddSelectedItemsToShoppingList}.&nbsp;
						              </#if>
						          </td>
						        </tr>
						        <tr>
						          <td colspan="2">
						              <#if sessionAttributes.userLogin?has_content && sessionAttributes.userLogin.userLoginId != "anonymous">
						              <a href="<@ofbizUrl>createCustRequestFromCart</@ofbizUrl>" class="button">${uiLabelMap.OrderCreateCustRequestFromCart}</a>&nbsp;&nbsp;
						              &nbsp;&nbsp;
						              <a href="<@ofbizUrl>createQuoteFromCart</@ofbizUrl>" class="button">${uiLabelMap.OrderCreateQuoteFromCart}</a>&nbsp;&nbsp;
						              <#else>
						               ${uiLabelMap.OrderYouMust} <a href="<@ofbizUrl>checkLogin/showcart</@ofbizUrl>" class="button">${uiLabelMap.CommonBeLogged}</a>
						                ${uiLabelMap.EcommerceToOrderCreateCustRequestFromCart}.&nbsp;
						              </#if>
						          </td>
						        </tr>
						        <tr>
						          <td colspan="2">
						            <input type="checkbox" onclick="document.getElementById('cartform').submit();" name="alwaysShowcart" id="alwaysShowcart" <#if shoppingCart.viewCartOnAdd()>checked="checked"</#if> style="vertical-align:top"/>
						            &nbsp;${uiLabelMap.EcommerceAlwaysViewCartAfterAddingAnItem}.
						          </td>
						        </tr>
							</tbody>
						</table>

						<div class="clear"></div>
					</div>
				</div>
			</div>
		</form>
  <#else>
    <h3 class="margintop5">${uiLabelMap.EcommerceYourShoppingCartEmpty}.</h3>
    
    <div class="cart-collaterals row-fluid">
			<div class="span6 cart_totals " style="float:left !important">
				<div class="border-1 border">
					<div class="border-2 border">
						<div class="cartdiv">
						    <h2>
						        ${uiLabelMap.CommonQuickAdd}
						    </h2>
						    <div>
						        <div>
						            <form method="post" action="<@ofbizUrl>additem<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="quickaddform" id="quickaddform">
						                <table>
						                	<tr>
						                		<td>${uiLabelMap.EcommerceProductNumber}:</td>
						                		<td><input type="text" class="inputBox" name="add_product_id" value="${requestParameters.add_product_id?if_exists}" /></td>
						                	</tr>
						                	<#-- check if rental data present  insert extra fields in Quick Add-->
						                <#if (product?exists && product.getString("productTypeId") == "ASSET_USAGE") || (product?exists && product.getString("productTypeId") == "ASSET_USAGE_OUT_IN")>
						                	<tr>
						                		<td>${uiLabelMap.EcommerceStartDate}:</td>
						                		<td><input type="text" class="inputBox" size="10" name="reservStart" value="${requestParameters.reservStart?default("")}" /></td>
						                	</tr>
						                	<tr>
						                		<td>${uiLabelMap.EcommerceLength}:</td>
						                		<input type="text" class="inputBox" size="2" name="reservLength" value="${requestParameters.reservLength?default("")}" />
						                	</tr>
						                	<tr>
						                		<td>${uiLabelMap.OrderNbrPersons}:</td>
						                		<td><input type="text" class="inputBox" size="3" name="reservPersons" value="${requestParameters.reservPersons?default("1")}" /></td>
						                	</tr>
						                </#if>
						                	<tr>
						                		<td>${uiLabelMap.CommonQuantity}:</td>
						                		<td><input type="text" class="inputBox" size="5" name="quantity" value="${requestParameters.quantity?default("1")}" /></td>
						                	</tr>
						                	<tr>
						                		<td><a href="javascript:void(0)" onclick="document.getElementById('quickaddform').submit();" class="button">${uiLabelMap.OrderAddToCart}</a></td>
						                		<td>&nbsp;</td>
						                	</tr>
						                </table>
						                
						            </form>
						        </div>
						    </div>
						</div>

						<div class="clear"></div>
					</div>
				</div>
			</div>
			
			<div class="span6 cart_totals ">
				<div class="border-1 border">
					<div class="border-2 border">
						<div class="cartdiv">
							<h2 style="text-align:left">${uiLabelMap.ProductPromoCodes}</h2>
							<div style="float:left">
					            <form method="post" action="<@ofbizUrl>addpromocode<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="addpromocodeform" id="addpromocodeform">
					                <table>
					                	<tr>
					                		<td><input type="text" class="inputBox" size="15" name="productPromoCodeId" value="" /></td>
					                	</tr>
					                	<tr>
					                		<td><a href="javascript:void(0)" onclick="document.getElementById('addpromocodeform').submit();" class="button">${uiLabelMap.OrderAddCode}</a></td>
					                	</tr>
					                	
				                		<#assign productPromoCodeIds = (shoppingCart.getProductPromoCodesEntered())?if_exists />
						                <#if productPromoCodeIds?has_content>
						                    ${uiLabelMap.ProductPromoCodesEntered}
						                    <tr>
				                				<td>
								                    <ul>
								                    <#list productPromoCodeIds as productPromoCodeId>
								                        <li>${productPromoCodeId}</li>
								                    </#list>
								                    </ul>
							                    </td>
				                			</tr>
					                	</#if>
					                </table>
					            </form>
					        </div>
						</div>
						<div class="clear"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
			
  </#if>
						
		<#if (shoppingCartSize > 0)>		
			<div style="margin-top: -60px;">
				<div class="coupon">
					<h2 style="text-align:left">${uiLabelMap.ProductPromoCodes}</h2>
					<div>
			            <form method="post" action="<@ofbizUrl>addpromocode<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="addpromocodeform" id="addpromocodeform">
			            	<input type="text" class="inputBox" size="15" name="productPromoCodeId" value="" />
			                <a href="javascript:void(0)" onclick="document.getElementById('addpromocodeform').submit();" class="button">${uiLabelMap.OrderAddCode}</a>
			                <#assign productPromoCodeIds = (shoppingCart.getProductPromoCodesEntered())?if_exists />
			                <#if productPromoCodeIds?has_content>
			                    ${uiLabelMap.ProductPromoCodesEntered}
			                    <ul>
			                    <#list productPromoCodeIds as productPromoCodeId>
			                        <li>${productPromoCodeId}</li>
			                    </#list>
			                    </ul>
			                </#if>
			            </from>
			        </div>
				</div>	
						
				<div class="span6 cart_totals " style="float:left !important">
					<div class="border-1 border">
						<div class="border-2 border">
							<div class="cartdiv">
							    <h2>
							        ${uiLabelMap.CommonQuickAdd}
							    </h2>
							    <div>
							        <div>
							        	<form action="" method="post"></form>
							            <form method="post" action="<@ofbizUrl>additem<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="quickaddform" id="quickaddform">
							                <table>
							                	<tr>
							                		<td>${uiLabelMap.EcommerceProductNumber}:</td>
							                		<td><input type="text" class="inputBox" name="add_product_id" value="${requestParameters.add_product_id?if_exists}" /></td>
							                	</tr>
							                	<#-- check if rental data present  insert extra fields in Quick Add-->
							                <#if (product?exists && product.getString("productTypeId") == "ASSET_USAGE") || (product?exists && product.getString("productTypeId") == "ASSET_USAGE_OUT_IN")>
							                	<tr>
							                		<td>${uiLabelMap.EcommerceStartDate}:</td>
							                		<td><input type="text" class="inputBox" size="10" name="reservStart" value="${requestParameters.reservStart?default("")}" /></td>
							                	</tr>
							                	<tr>
							                		<td>${uiLabelMap.EcommerceLength}:</td>
							                		<input type="text" class="inputBox" size="2" name="reservLength" value="${requestParameters.reservLength?default("")}" />
							                	</tr>
							                	<tr>
							                		<td>${uiLabelMap.OrderNbrPersons}:</td>
							                		<td><input type="text" class="inputBox" size="3" name="reservPersons" value="${requestParameters.reservPersons?default("1")}" /></td>
							                	</tr>
							                </#if>
							                	<tr>
							                		<td>${uiLabelMap.CommonQuantity}:</td>
							                		<td><input type="text" class="inputBox" size="5" name="quantity" value="${requestParameters.quantity?default("1")}" /></td>
							                	</tr>
							                	<tr>
							                		<td><a href="javascript:void(0)" onclick="document.getElementById('quickaddform').submit();" class="button">${uiLabelMap.OrderAddToCart}</a></td>
							                		<td>&nbsp;</td>
							                	</tr>
							                </table>
							                
							            </form>
							        </div>
							    </div>
							</div>
	
							<div class="clear"></div>
						</div>
					</div>
				</div>
			</div>		
		</#if>
						
						
						
						
						
						
						
						
						
						
						
						
						</div>
					</div>
					

				
			</div> <!-- end woo -->
					


<#if showPromoText?exists && showPromoText>
<hr />
<div>
    <div>
        <h2>${uiLabelMap.OrderSpecialOffers}</h2>
    </div>
    <div>
        <#-- show promotions text -->
        <ul>
        <#list productPromos as productPromo>
            <li><a href="<@ofbizUrl>showPromotionDetails?productPromoId=${productPromo.productPromoId}</@ofbizUrl>" class="linktext">[${uiLabelMap.CommonDetails}]</a>${StringUtil.wrapString(productPromo.promoText?if_exists)}</li>
        </#list>
        </ul>
        <div><a href="<@ofbizUrl>showAllPromotions</@ofbizUrl>" class="button">${uiLabelMap.OrderViewAllPromotions}</a></div>
    </div>
</div>
</#if>

<#if associatedProducts?has_content>
<div>
    <div>
        <h2>${uiLabelMap.EcommerceYouMightAlsoIntrested}:</h2>
    </div>
    <div>
        <#-- random complementary products -->
        <#list associatedProducts as assocProduct>
            <div>
                ${setRequestAttribute("optProduct", assocProduct)}
                ${setRequestAttribute("listIndex", assocProduct_index)}
                ${screens.render("component://ec_default/widget/CatalogScreens.xml#productsummary")}
            </div>
        </#list>
    </div>
</div>
</#if>


<#if (shoppingCartSize?default(0) > 0)>
  ${screens.render("component://bazar/widget/CartScreens.xml#promoUseDetailsInline")}
</#if>



					
					
					
					
				</div>
				<!-- START COMMENTS -->
				<div id="comments"></div>
				<!-- END COMMENTS -->
			</div>
			<!-- END CONTENT -->

			<!-- START EXTRA CONTENT -->
			<!-- END EXTRA CONTENT -->
		</div>
	</div>
</div>

<script type="text/javascript">
//<![CDATA[
function removeSelected_2(item_index){
	var cform = document.getElementById('cartform');
    document.getElementById('removeSelected').value = true;
    var checkbox = document.getElementById('cartItemDisplayCheckBox_' + item_index);
    checkbox.checked = true;
    cform.submit();
}

function addToList() {
    var cform = document.getElementById('cartform');
    cform.action = "<@ofbizUrl>addBulkToShoppingList</@ofbizUrl>";
    cform.submit();
}
//]]>
</script>