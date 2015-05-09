<#assign shoppingCart = sessionAttributes.shoppingCart?if_exists>
<#if shoppingCart?has_content>
    <#assign shoppingCartSize = shoppingCart.size()>
<#else>
    <#assign shoppingCartSize = 0>
</#if>

        <#if (shoppingCartSize > 0)>
							<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
							    <i class="icon-shopping-cart"></i> ${shoppingCart.getTotalQuantity()} <#if shoppingCart.getTotalQuantity() == 1>${uiLabelMap.OrderItem}<#else/>${uiLabelMap.OrderItems}</#if>
							    <span class="caret"></span>
							</a>
							<div class="dropdown-menu cart-content pull-right">
								<table class="table-cart">
									<tbody>
									
            <#list shoppingCart.items() as cartLine>
									<tr>
										<td class="cart-product-info">
                    <#assign smallImageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher)?if_exists />
                    <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg" /></#if>
                    <#if smallImageUrl?string?has_content>
                        <img src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Image" class="imageborder" />
                    </#if>
										
											<div class="cart-product-desc">
												<p>
                  <#if cartLine.getProductId()?exists>
                      <#if cartLine.getParentProductId()?exists>
                          <a href="<@ofbizCatalogAltUrl productId=cartLine.getParentProductId()/>" class="invarseColor">${cartLine.getName()}</a>
                      <#else>
                          <a href="<@ofbizCatalogAltUrl productId=cartLine.getProductId()/>" class="invarseColor">${cartLine.getName()}</a>
                      </#if>
                  <#else>
                    <strong>${cartLine.getItemTypeDescription()?if_exists}</strong>
                  </#if>
												</p>
												<ul class="unstyled">
													<li>${uiLabelMap.OrderQty}: ${cartLine.getQuantity()?string.number}</li>
												</ul>
											</div>
										</td>
										<td class="cart-product-setting">
											<p><strong><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></strong></p>
										</td>
									</tr>
            </#list>
								</tbody>
								<tfoot>
									<tr>
										<td class="cart-product-info">
											<a href="<@ofbizUrl>checkoutoptions</@ofbizUrl>" class="btn btn-small btn-primary">${uiLabelMap.OrderCheckout}</a>
											<a href="<@ofbizUrl>view/showcart</@ofbizUrl>" class="btn btn-small">${uiLabelMap.OrderViewCart}</a>
										</td>
										<td>
											<h4>${uiLabelMap.EcommerceCartTotal}<br><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></h4>
										</td>
									</tr>
								</tfoot>
								</table>
							</div>
							
        <#else>
							<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
							    <i class="icon-shopping-cart"></i> ${uiLabelMap.OrderShoppingCartEmpty}
							    <span class="caret"></span>
							</a>
        </#if>