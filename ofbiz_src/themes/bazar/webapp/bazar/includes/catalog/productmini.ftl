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
	<#assign productName = "">
	
	<a href="${productUrl}">
		<img width="100" height="80" class="product-mini-img" src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="${product.productName?if_exists}" class="attachment-shop_thumbnail wp-post-image">
		<#assign productName = productContentWrapper.get("PRODUCT_NAME")?if_exists>
		<a href="${productUrl}" title="${productName}">
				<#if productName?length &lt; 15>
					${productName}
				<#else>
					${productName?substring(0, 14)} ...
				</#if>
		</a>
	</a>
	<div class="price">
    	<#if price.isSale?exists && price.isSale>
    		<del><span class="price-old"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/></span></del>
          <#else>
          </#if>
    	<#if totalPrice?exists>
          <@ofbizCurrency amount=totalPrice isoCode=totalPrice.currencyUsed/>
        <#else>
            <#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
            </#if>
            <#if (price.price?default(0) > 0 && product.requireAmount?default("N") == "N")>
                <#if "Y" = product.isVirtual?if_exists> ${uiLabelMap.CommonFrom} </#if><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/>
            </#if>
        </#if>
  	</div>
</#if>