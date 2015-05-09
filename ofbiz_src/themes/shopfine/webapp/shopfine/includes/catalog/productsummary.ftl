${virtualJavaScript?if_exists}
<script type="text/javascript">
<!--
    function displayProductVirtualId(variantId, virtualProductId, pForm) {
        if(variantId){
            pForm.product_id.value = variantId;
        }else{
            pForm.product_id.value = '';
            variantId = '';
        }
        var elem = document.getElementById('product_id_display');
        var txt = document.createTextNode(variantId);
        if(elem.hasChildNodes()) {
            elem.replaceChild(txt, elem.firstChild);
        } else {
            elem.appendChild(txt);
        }
        
        var priceElem = document.getElementById('variant_price_display');
        var price = getVariantPrice(variantId);
        var priceTxt = null;
        if(price){
            priceTxt = document.createTextNode(price);
        }else{
            priceTxt = document.createTextNode('');
        }
        
        if(priceElem.hasChildNodes()) {
            priceElem.replaceChild(priceTxt, priceElem.firstChild);
        } else {
            priceElem.appendChild(priceTxt);
        }
    }
//-->
</script>

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
    <#assign smallImageUrl = productContentWrapper.get("MEDIUM_IMAGE_URL")?if_exists>
    <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg"></#if>
    <#-- end variable setup -->
    <#assign productInfoLinkId = "productInfoLink">
    <#assign productInfoLinkId = productInfoLinkId + product.productId/>
    <#assign productDetailId = "productDetailId"/>
    <#assign productDetailId = productDetailId + product.productId/>

								<li class="span3 clearfix">
									<div class="thumbnail">
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

										<div class="thumbButtons">
																				
          <#-- check to see if introductionDate hasn't passed yet -->
          <#if product.introductionDate?exists && nowTimestamp.before(product.introductionDate)>
            <div style="color: red;">${uiLabelMap.ProductNotYetAvailable}</div>
          <#-- check to see if salesDiscontinuationDate has passed -->
          <#elseif product.salesDiscontinuationDate?exists && nowTimestamp.after(product.salesDiscontinuationDate)>
            <div style="color: red;">${uiLabelMap.ProductNoLongerAvailable}</div>
          <#-- check to see if it is a rental item; will enter parameters on the detail screen-->
          <#elseif product.productTypeId?if_exists == "ASSET_USAGE">
											<a href="${productUrl}"><button class="btn btn-primary btn-small" data-title="${uiLabelMap.OrderMakeBooking}..." data-placement="top" data-toggle="tooltip">
												<i class="icon-pencil"></i>
											</button></a>
          <#-- check to see if it is an aggregated or configurable product; will enter parameters on the detail screen-->
          <#elseif product.productTypeId?if_exists == "AGGREGATED" || product.productTypeId?if_exists == "AGGREGATED_SERVICE">
											<a href="${productUrl}"><button class="btn btn-primary btn-small" data-title="${uiLabelMap.OrderConfigure}..." data-placement="top" data-toggle="tooltip">
												<i class="icon-pencil"></i>
											</button></a>
          <#-- check to see if the product is a virtual product -->
          <#elseif product.isVirtual?exists && product.isVirtual == "Y">
											<a href="${productUrl}"><button class="btn btn-primary btn-small" data-title="${uiLabelMap.OrderChooseVariations}..." data-placement="top" data-toggle="tooltip">
												<i class="icon-pencil"></i>
											</button></a>
          <#-- check to see if the product requires an amount -->
          <#elseif product.requireAmount?exists && product.requireAmount == "Y">
											<a href="${productUrl}"><button class="btn btn-primary btn-small" data-title="${uiLabelMap.OrderChooseAmount}..." data-placement="top" data-toggle="tooltip">
												<i class="icon-pencil"></i>
											</button></a>
          <#elseif product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
											<a href="${productUrl}"><button class="btn btn-primary btn-small" data-title="${uiLabelMap.OrderRent}..." data-placement="top" data-toggle="tooltip">
												<i class="icon-pencil"></i>
											</button></a>
          <#else>
            <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form">
              <input type="hidden" name="add_product_id" value="${product.productId}"/>
              <input type="hidden" size="5" name="quantity" value="1"/>
              <input type="hidden" name="clearSearch" value="N"/>
              <input type="hidden" name="mainSubmitted" value="Y"/>
              <input type="hidden" name="productCategoryId" value="${productCategoryId?if_exists}"/>
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

				<button class="btn btn-primary btn-small" data-title="${uiLabelMap.OrderAddToCart}..." data-placement="top" data-toggle="tooltip" type="button" onclick="document.the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form.submit();">
					<i class="icon-shopping-cart"></i>
				</button>

            
              <#if prodCatMem?exists && prodCatMem.quantity?exists && 0.00 < prodCatMem.quantity?double>
                <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform" style="margin: 0;">
                  <input type="hidden" name="add_product_id" value="${prodCatMem.productId?if_exists}"/>
                  <input type="hidden" name="quantity" value="${prodCatMem.quantity?if_exists}"/>
                  <input type="hidden" name="clearSearch" value="N"/>
                  <input type="hidden" name="mainSubmitted" value="Y"/>
                  <input type="hidden" name="productCategoryId" value="${productCategoryId?if_exists}"/>
                  <a href="javascript:document.the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform.submit()" class="buttontext">${uiLabelMap.CommonAddDefault}(${prodCatMem.quantity?string.number}) ${uiLabelMap.OrderToCart}</a>
                </form>
                <#assign productCategory = delegator.findOne("ProductCategory", Static["org.ofbiz.base.util.UtilMisc"].toMap("productCategoryId", prodCatMem.productCategoryId), false)/>
                <#if productCategory.productCategoryTypeId != "BEST_SELL_CATEGORY">
                    <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform" style="margin: 0;">
                      <input type="hidden" name="add_product_id" value="${prodCatMem.productId?if_exists}"/>
                      <input type="hidden" name="quantity" value="${prodCatMem.quantity?if_exists}"/>
                      <input type="hidden" name="clearSearch" value="N"/>
                      <input type="hidden" name="mainSubmitted" value="Y"/>
                      <input type="hidden" name="productCategoryId" value="${productCategoryId?if_exists}"/>
                      
                      <a href="javascript:document.the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}defaultform.submit()" class="buttontext">${uiLabelMap.CommonAddDefault}(${prodCatMem.quantity?string.number}) ${uiLabelMap.OrderToCart}</a>
                    </form>
                </#if>
              </#if>            
          
          </#if>
          
											<button class="btn btn-small" data-title="${uiLabelMap.ProductAddToCompare}" data-placement="top" data-toggle="tooltip" onclick="document.addToCompare${requestAttributes.listIndex?if_exists}form.submit();" type="button">
												<i class="icon-refresh"></i>												
											</button>
											
											<form method="post" action="<@ofbizUrl secure="${request.isSecure()?string}">addToCompare</@ofbizUrl>" name="addToCompare${requestAttributes.listIndex?if_exists}form">
								              	<input type="hidden" name="productId" value="${product.productId}"/>
								              	<input type="hidden" name="mainSubmitted" value="Y"/>
								          	</form>
		
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
								