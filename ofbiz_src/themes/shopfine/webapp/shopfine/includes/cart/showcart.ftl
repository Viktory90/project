<script type="text/javascript">
//<![CDATA[
function toggle(e) {
    e.checked = !e.checked;
}
function checkToggle(e) {
    var cform = document.cartform;
    if (e.checked) {
        var len = cform.elements.length;
        var allchecked = true;
        for (var i = 0; i < len; i++) {
            var element = cform.elements[i];
            if (element.name == "selectedItem" && !element.checked) {
                allchecked = false;
            }
            cform.selectAll.checked = allchecked;
        }
    } else {
        cform.selectAll.checked = false;
    }
}
function toggleAll(e) {
    var cform = document.cartform;
    var len = cform.elements.length;
    for (var i = 0; i < len; i++) {
        var element = cform.elements[i];
        if (element.name == "selectedItem" && element.checked != e.checked) {
            toggle(element);
        }
    }
}
function removeSelected() {
    var cform = document.cartform;
    cform.removeSelected.value = true;
    cform.submit();
}
function addToList() {
    var cform = document.cartform;
    cform.action = "<@ofbizUrl>addBulkToShoppingList</@ofbizUrl>";
    cform.submit();
}
function gwAll(e) {
    var cform = document.cartform;
    var len = cform.elements.length;
    var selectedValue = e.value;
    if (selectedValue == "") {
        return;
    }

    var cartSize = ${shoppingCartSize};
    var passed = 0;
    for (var i = 0; i < len; i++) {
        var element = cform.elements[i];
        var ename = element.name;
        var sname = ename.substring(0,16);
        if (sname == "option^GIFT_WRAP") {
            var options = element.options;
            var olen = options.length;
            var matching = -1;
            for (var x = 0; x < olen; x++) {
                var thisValue = element.options[x].value;
                if (thisValue == selectedValue) {
                    element.selectedIndex = x;
                    passed++;
                }
            }
        }
    }
    if (cartSize > passed && selectedValue != "NO^") {
        showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.EcommerceSelectedGiftWrap}");
    }
    cform.submit();
}
//]]>
</script>

<script type="text/javascript">
//<![CDATA[
function setAlternateGwp(field) {
  window.location=field.value;
};
//]]>
</script>
<#assign fixedAssetExist = shoppingCart.containAnyWorkEffortCartItems() /> <#-- change display format when rental items exist in the shoppingcart -->
		<div class="container">

			<div class="row">

		<div class="span12">
			<h2>&nbsp;${uiLabelMap.OrderShoppingCart}</h2>

			<div class="showcart-top-button">
              <#if (shoppingCartSize > 0)>
                <a href="javascript:document.cartform.submit();"><button class="btn">${uiLabelMap.EcommerceRecalculateCart}</button></a>
                <a href="<@ofbizUrl>emptycart</@ofbizUrl>"><button class="btn">${uiLabelMap.EcommerceEmptyCart}</button></a>
                <a href="javascript:removeSelected();"><button class="btn">${uiLabelMap.EcommerceRemoveSelected}</button></a>
				<a href="<@ofbizUrl>checkoutoptions</@ofbizUrl>"><button class="btn btn-primary">${uiLabelMap.OrderCheckout}</button></a>
              </#if>
            </div>
        </div>
				
				<div class="span12">
				
  <#if (shoppingCartSize > 0)>
    <form method="post" action="<@ofbizUrl>modifycart</@ofbizUrl>" name="cartform">
      <fieldset>
      <input type="hidden" name="removeSelected" value="false" />
					<table class="table">
						<thead>
							<tr>
              					<th></th>
								<th>${uiLabelMap.EcommerceImage}</th>
								<th class="desc">${uiLabelMap.OrderProduct}</th>
					          <#if asslGiftWraps?has_content && productStore.showCheckoutGiftOptions?if_exists != "N">>
					            <th>
					              <select class="selectBox" name="GWALL" onchange="javascript:gwAll(this);">
					                <option value="">${uiLabelMap.EcommerceGiftWrapAllItems}</option>
					                <option value="NO^">${uiLabelMap.EcommerceNoGiftWrap}</option>
					                <#list allgiftWraps as option>
					                  <option value="${option.productFeatureId}">${option.description} : ${option.defaultAmount?default(0)}</option>
					                </#list>
					              </select>
					          <#else>
					            <th>&nbsp;</th>
					          </#if>
								
				              <#if fixedAssetExist == true>
				                <td>
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
				                </td>
				              <#else>
				                <th>${uiLabelMap.CommonQuantity}</th>
				              </#if>
				              <th>${uiLabelMap.EcommerceUnitPrice}</th>
				              <th>${uiLabelMap.EcommerceAdjustments}</th>
				              <th>${uiLabelMap.EcommerceItemTotal}</th>
				              <th class="select"><input type="checkbox" name="selectAll" value="0" onclick="javascript:toggleAll(this);" /></th>
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

          <tr id="cartItemDisplayRow_${cartLineIndex}">
            <td>
                <#if cartLine.getShoppingListId()?exists>
                  <#assign itemsFromList = true />
                  <a href="<@ofbizUrl>editShoppingList?shoppingListId=${cartLine.getShoppingListId()}</@ofbizUrl>" class="linktext">L</a>&nbsp;&nbsp;
                <#elseif cartLine.getIsPromo()>
                  <#assign promoItems = true />
                  <a href="<@ofbizUrl>view/showcart</@ofbizUrl>" class="button">P</a>&nbsp;&nbsp;
                <#else>
                  &nbsp;
                </#if>
            </td>
            <td>
                  <#if cartLine.getProductId()?exists>
                    <#-- product item -->
                    <#-- start code to display a small image of the product -->
                    <#if cartLine.getParentProductId()?exists>
                      <#assign parentProductId = cartLine.getParentProductId() />
                    <#else>
                      <#assign parentProductId = cartLine.getProductId() />
                    </#if>
                    <#assign smallImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher)?if_exists />
                    <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg" /></#if>
                    
                    <#if smallImageUrl?string?has_content>
                      <a href="<@ofbizCatalogAltUrl productId=parentProductId/>">
                        <img src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" class="imageborder" />
                      </a>
                    </#if>
              </td>
              <td class="desc">
                    <#-- end code to display a small image of the product -->
                    <#-- ${cartLineIndex} - -->
                    <a href="<@ofbizCatalogAltUrl productId=parentProductId/>" class="linktext">${cartLine.getProductId()} -
                    ${cartLine.getName()?if_exists}</a> : ${cartLine.getDescription()?if_exists}
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
                    ${cartLine.getItemTypeDescription()?if_exists}: ${cartLine.getName()?if_exists}
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
            </td>

            <#-- gift wrap option -->
            <#assign showNoGiftWrapOptions = false />
            <td >
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

            <td class="quantity">
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
                        ${cartLine.getQuantity()?string.number}</td></tr></table>
                    <#else><#-- fixedAssetExist -->
                        ${cartLine.getQuantity()?string.number}
                    </#if>
                <#else><#-- Is Promo or Shoppinglist -->
                       <#if fixedAssetExist == true><#if cartLine.getReservStart()?exists><table><tr><td>&nbsp;</td><td><input type="text" class="inputBox" size="10" name="reservStart_${cartLineIndex}" value=${cartLine.getReservStart()?string}/></td><td><input type="text" class="inputBox" size="2" name="reservLength_${cartLineIndex}" value="${cartLine.getReservLength()?string.number}"/></td></tr><tr><td>&nbsp;</td><td><input type="text" class="inputBox" size="3" name="reservPersons_${cartLineIndex}" value=${cartLine.getReservPersons()?string.number} /></td><td><#else>
                           <table><tr><td>--</td><td>--</td></tr><tr><td>--</td><td></#if>
                        <input class="inputBox" type="text" name="update_${cartLineIndex}" value="${cartLine.getQuantity()?string.number}" /></td></tr></table>
                    <#else><#-- fixedAssetExist -->
                        <input class="inputBox" type="text" name="update_${cartLineIndex}" value="${cartLine.getQuantity()?string.number}" />
                    </#if>
                </#if>
            </td>
            <td class="sub-price"><@ofbizCurrency amount=cartLine.getDisplayPrice() isoCode=shoppingCart.getCurrency()/></td>
            <td class="sub-price"><@ofbizCurrency amount=cartLine.getOtherAdjustments() isoCode=shoppingCart.getCurrency()/></td>
            <td class="sub-price"><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></td>
            <td><#if !cartLine.getIsPromo()><input type="checkbox" name="selectedItem" value="${cartLineIndex}" onclick="javascript:checkToggle(this);" /><#else>&nbsp;</#if></td>
          </tr>
        </#list>
    </tbody>
    </table>					
      </fieldset>
    </form>
  <#else>
    <h2>${uiLabelMap.EcommerceYourShoppingCartEmpty}.</h2>
  </#if>
<#-- Copy link bar to bottom to include a link bar at the bottom too -->
					
				</div><!--end span12-->

				<div class="span6">
				
					<div class="cart-accordain" id="cart-acc">

						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#cart-acc" href="#promotion2">
									<i class="icon-caret-right"></i> ${uiLabelMap.EcommercePromotionalItems}
								</a>
							</div>
							<div id="promotion2" class="accordion-body collapse in">
								<div class="accordion-inner">
	<table>		
<#if (shoppingCartSize > 0)>
		
		<#if promoItems>
        <tr colspan="2">
          <td>P - ${uiLabelMap.EcommercePromotionalItems}.</td>
        </tr>
        </#if>
        <#if !itemsFromList && !promoItems>
        <tr colspan="2">
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
              &nbsp;&nbsp;
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
              &nbsp;&nbsp;
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
            <input type="checkbox" onclick="javascript:document.cartform.submit()" name="alwaysShowcart" <#if shoppingCart.viewCartOnAdd()>checked="checked"</#if>/>${uiLabelMap.EcommerceAlwaysViewCartAfterAddingAnItem}.
          </td>
        </tr>
</#if>        
	</table>			
        
								</div>
							</div>
				
						</div>
				
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#cart-acc" href="#estimate">
									<i class="icon-caret-right"></i> ${uiLabelMap.OrderPromotionInformation}
								</a>
							</div>
							<div id="estimate" class="accordion-body collapse">
								<div class="accordion-inner">
<#if (shoppingCartSize?default(0) > 0)>
  ${screens.render("component://shopfine/widget/CartScreens.xml#promoUseDetailsInline")}
</#if>
								</div>
							</div>
						</div><!--end accordion-group-->

						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#cart-acc" href="#discount-code">
									<i class="icon-caret-right"></i> ${uiLabelMap.ProductPromoCodes}
								</a>
							</div>
							<div id="discount-code" class="accordion-body collapse">
								<div class="accordion-inner">
            						<form class="form-horizontal" method="post" action="<@ofbizUrl>addpromocode<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="addpromocodeform">
                <fieldset>
									  <div class="control-group">
									    <label class="control-label" for="inputDiscount">
									    	<strong>${uiLabelMap.ProductPromoCodes}</strong>
									    	</label>
									    <div class="controls">
									      <input type="text" name="productPromoCodeId" placeholder="Inter Discount Code...">
									    </div>
									  </div><!--end control-group-->
									  <div class="control-group">
									    <div class="controls">
									      <button type="submit" class="btn btn-primary">${uiLabelMap.OrderAddCode}</button>
									    </div>
									  </div><!--end control-group-->
                <#if productPromoCodeIds?has_content>
                    ${uiLabelMap.ProductPromoCodesEntered}
                    <ul>
                    <#list productPromoCodeIds as productPromoCodeId>
                        <li>${productPromoCodeId}</li>
                    </#list>
                    </ul>
                </#if>
                </fieldset>
									</form>
								</div>
							</div>
						</div><!--end accordion-group-->

						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#cart-acc" href="#gift-voucher">
									<i class="icon-caret-right"></i> ${uiLabelMap.OrderSpecialOffers}
								</a>
							</div>
							<div id="gift-voucher" class="accordion-body collapse">
								<div class="accordion-inner">
<#if showPromoText?exists && showPromoText>
<div>
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
                ${screens.render("component://shopfine/widget/CatalogScreens.xml#productsummary")}
            </div>
        </#list>
    </div>
</div>
</#if>								</div>
							</div>
						</div><!--end accordion-group-->

					</div><!--end cart-accordain-->
				</div><!--end span7-->


				<div class="span6">
					<div class="cart-receipt">
						<table class="table table-receipt">
						
					        <#if shoppingCart.getAdjustments()?has_content>
					            <tr>
					              <td class="alignRight">${uiLabelMap.CommonSubTotal}:</td>
					              <td class="alignLeft"><@ofbizCurrency amount=shoppingCart.getDisplaySubTotal() isoCode=shoppingCart.getCurrency()/></td>
					            </tr>
					            <#if (shoppingCart.getDisplayTaxIncluded() > 0.0)>
					              <tr>
					                <td class="alignRight">${uiLabelMap.OrderSalesTaxIncluded}:</td>
					                <td class="alignLeft"><@ofbizCurrency amount=shoppingCart.getDisplayTaxIncluded() isoCode=shoppingCart.getCurrency()/></td>
					              </tr>
					            </#if>
					            <#list shoppingCart.getAdjustments() as cartAdjustment>
					              <#assign adjustmentType = cartAdjustment.getRelatedOne("OrderAdjustmentType", true) />
					              <tr>
					                <td class="alignRight">
					                    ${uiLabelMap.EcommerceAdjustment} - ${adjustmentType.get("description",locale)?if_exists}
					                    <#if cartAdjustment.productPromoId?has_content><a href="<@ofbizUrl>showPromotionDetails?productPromoId=${cartAdjustment.productPromoId}</@ofbizUrl>" class="button">${uiLabelMap.CommonDetails}</a></#if>:
					                </td>
					                <td class="alignLeft"><@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) isoCode=shoppingCart.getCurrency()/></td>
					              </tr>
					            </#list>
					        </#if>
					        <tr>
					          <td class="alignRight">${uiLabelMap.EcommerceCartTotal}:</th>
					          <td class="alignLeft"><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></td>
					        </tr>
								

					        <#if ((sessionAttributes.lastViewedProducts)?has_content && sessionAttributes.lastViewedProducts?size > 0)>
					          <#assign continueLink = "/product?product_id=" + sessionAttributes.lastViewedProducts.get(0) />
					        <#else>
					          <#assign continueLink = "/main" />
					        </#if>


							<tr>
								<td class="alignRight"><a href="<@ofbizUrl>${continueLink}</@ofbizUrl>"><button class="btn">${uiLabelMap.EcommerceContinueShopping}</button></a></td>
        					<#if (shoppingCartSize > 0)>
								<td class="alignLeft"><a href="<@ofbizUrl>checkoutoptions</@ofbizUrl>"><button class="btn btn-primary">${uiLabelMap.OrderCheckout}</button></a></td>
							</#if>								
							</tr>
						</table>
					</div>
				</div><!--end span5-->


			</div><!--end row-->

		</div><!--end conatiner-->