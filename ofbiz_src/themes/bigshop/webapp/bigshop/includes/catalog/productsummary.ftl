<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
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
    <div>
        <div class="image">
            <a href="${productUrl}">
                <span id="${productInfoLinkId}" class="popup_link"><img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${mediumImageUrl}</@ofbizContentUrl>" alt="Small Image"/></span>
            </a>
        </div>
        
        <div class="name">
          <a href="${productUrl}">${productContentWrapper.get("PRODUCT_NAME")?if_exists}</a>
        </div>
        <div class="description">  ${productContentWrapper.get("DESCRIPTION")?if_exists}  </div>
        <div class="price">  
                <#if totalPrice?exists>
                  <div>${uiLabelMap.ProductAggregatedPrice}: <span class='basePrice'><@ofbizCurrency amount=totalPrice isoCode=totalPrice.currencyUsed/></span></div>
                <#else>
                <#if price.competitivePrice?exists && price.price?exists && price.price?double < price.competitivePrice?double>
                  ${uiLabelMap.ProductCompareAtPrice}: <span class='basePrice'><@ofbizCurrency amount=price.competitivePrice isoCode=price.currencyUsed/></span>
                </#if>
                <#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
                  <div class="price-old"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/></div>
                </#if>
                <b>
                  <#if price.isSale?exists && price.isSale>
                    <#assign priceStyle = "salePrice">
                  <#else>
                    <#assign priceStyle = "regularPrice">
                  </#if>

                  <#if (price.price?default(0) > 0 && product.requireAmount?default("N") == "N")>
                    <#if "Y" = product.isVirtual?if_exists> ${uiLabelMap.CommonFrom} </#if><span class="${priceStyle}"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/></span>
                  </#if>
                </b>
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
        </div>
        <#if averageRating?exists && (averageRating?double > 0) && numRatings?exists && (numRatings?long > 1)>
        <div class="rating">
          <#if (averageRating?double < 0.5)>
            <img src="/bigshop/images/stars-0.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
          <#elseif (averageRating?double >= 0.5 && averageRating?double < 1.5)>
        	<img src="/bigshop/images/stars-1.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
          <#elseif (averageRating?double >= 1.5 && averageRating?double < 2.5)>
            <img src="/bigshop/images/stars-2.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
          <#elseif (averageRating?double >= 2.5 && averageRating?double < 3.5)>
            <img src="/bigshop/images/stars-3.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
          <#elseif (averageRating?double >= 3.5 && averageRating?double < 4.5)>
            <img src="/bigshop/images/stars-4.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
          <#else>
            <img src="/bigshop/images/stars-5.png" alt="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">   
          </#if>	
        </div>
        </#if>
        
        <div>
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
            <div class="cart">
              <a href="${productUrl}" class="button">${uiLabelMap.BigshopOrderChooseVariations}...</a>
            </div>  
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
          <div class="cart">
            <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form" style="margin: 0;">
              <input type="hidden" name="add_product_id" value="${product.productId}"/>
              <input type="hidden" name="quantity" value="1"/>
              <input type="hidden" name="clearSearch" value="N"/>
              <input type="hidden" name="mainSubmitted" value="Y"/>
              
            	<input type="button" value="${uiLabelMap.OrderAddToCart}" onclick="javascript:document.the${requestAttributes.formNamePrefix?if_exists}${requestAttributes.listIndex?if_exists}form.submit()" class="button">
          	  
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
            </div>
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
          </#if>
          <div class="wishlist">
          	<a style="display:none;" href="#" onclick="document.addToCompare${requestAttributes.listIndex?if_exists}form.submit();">${uiLabelMap.BigshopAddCompare}</a>
          </div>
          <div class="compare">
          	  <a href="#" onclick="document.addToCompare${requestAttributes.listIndex?if_exists}form.submit();">${uiLabelMap.BigshopAddCompare}</a>
	          <form method="post" action="<@ofbizUrl secure="${request.isSecure()?string}">addToCompare</@ofbizUrl>" name="addToCompare${requestAttributes.listIndex?if_exists}form">
	          	<input type="hidden" name="productId" value="${product.productId}"/>
	          	<input type="hidden" name="mainSubmitted" value="Y"/>	          	
	      	  </form>
      	  </div>
        </div>
    </div>
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br />
</#if>
