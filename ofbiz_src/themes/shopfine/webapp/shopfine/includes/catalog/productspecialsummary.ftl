<#if product?exists>
    <#-- variable setup -->
    <#if backendPath?default("N") == "Y">
        <#assign productUrl><@ofbizCatalogUrl productId=product.productId productCategoryId=productCategoryId/></#assign>
    <#else>
        <#assign productUrl><@ofbizCatalogAltUrl productId=product.productId productCategoryId=productCategoryId/></#assign>
    </#if>

    <#if requestAttributes.productCategoryMember?exists>
        <#assign prodCatMem = requestAttributes.productCategoryMember>
    </#if>
    <#assign smallImageUrl = productContentWrapper.get("SMALL_IMAGE_URL")?if_exists>
    <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg"></#if>
    <#-- end variable setup -->
    <#assign productInfoLinkId = "productInfoLink">
    <#assign productInfoLinkId = productInfoLinkId + product.productId/>
    <#assign productDetailId = "productDetailId"/>
    <#assign productDetailId = productDetailId + product.productId/>

							<li class="span4 clearfix">
								<div class="thumbImage">
										<a href="${productUrl}"><img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="${product.productName?if_exists}"  ></a>
								</div>
								<div class="thumbSetting">
									<div class="thumbTitle">
										<a href="${productUrl}" class="invarseColor">
												${productContentWrapper.get("PRODUCT_NAME")?if_exists}
										</a>
									</div>
									<div class="thumbPrice">
										<span>
																				
                <#if totalPrice?exists>
                  <@ofbizCurrency amount=totalPrice isoCode=totalPrice.currencyUsed/>
                <#else>
                <#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
                  <span class="strike-through"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/></span>
                </#if>
                  <#if (price.price?default(0) > 0 && product.requireAmount?default("N") == "N")>
                    <#if "Y" = product.isVirtual?if_exists> ${uiLabelMap.CommonFrom} </#if><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/>
                  </#if>
                </#if>
                						</span>
									</div>
									
          <#if averageRating?exists && (averageRating?double > 0) && numRatings?exists && (numRatings?long > 1)>
										<ul class="rating" title="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
											<li><i class="<#if (averageRating?double > 0.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 1.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 2.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 3.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 4.5)>star-on<#else>star-off</#if>"></i></li>
										</ul>
          </#if>
								</div>	
							</li>
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br />
</#if>
								