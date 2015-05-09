<#-- variable setup -->
<#assign price = priceMap?if_exists />
<#assign productImageList = productImageList?if_exists />
<#-- end variable setup -->

<#-- virtual product javascript -->
${virtualJavaScript?if_exists}
<script language="JavaScript" type="text/javascript">
<!--
    var detailImageUrl = null;
    function setAddProductId(name) {
    
    	document.getElementById('variant_product').style.display="inline";
    
        document.addform.add_product_id.value = name;
        if (document.addform.quantity == null) return;
        if (name == '' || name == 'NULL' || isVirtual(name) == true) {
            document.addform.quantity.disabled = true;
            var elem = document.getElementById('product_id_display');
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        } else {
            document.addform.quantity.disabled = false;
            var elem = document.getElementById('product_id_display');
            var txt = document.createTextNode(name);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function setVariantPrice(sku) {
    	document.getElementById('variant_product').style.display="inline";
        if (sku == '' || sku == 'NULL' || isVirtual(sku) == true) {
            var elem = document.getElementById('variant_price_display');
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
        else {
            var elem = document.getElementById('variant_price_display');
            var price = getVariantPrice(sku);
            var txt = document.createTextNode(price);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function isVirtual(product) {
        var isVirtual = false;
        <#if virtualJavaScript?exists>
        for (i = 0; i < VIR.length; i++) {
            if (VIR[i] == product) {
                isVirtual = true;
            }
        }
        </#if>
        return isVirtual;
    }
    function addItem() {
       if (document.addform.add_product_id.value == 'NULL') {
           showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonPleaseSelectAllRequiredOptions}");
           return;
       } else {
           if (isVirtual(document.addform.add_product_id.value)) {
               document.location = '<@ofbizUrl>product?category_id=${categoryId?if_exists}&amp;product_id=</@ofbizUrl>' + document.addform.add_product_id.value;
               return;
           } else {
               document.addform.submit();
           }
       }
    }

    function popupDetail() {
        var defaultDetailImage = "${firstDetailImage?default(mainDetailImageUrl?default("_NONE_"))}";
        if (defaultDetailImage == null || defaultDetailImage == "null" || defaultDetailImage == "") {
            defaultDetailImage = "_NONE_";
        }

        if (detailImageUrl == null || detailImageUrl == "null") {
            detailImageUrl = defaultDetailImage;
        }

        if (detailImageUrl == "_NONE_") {
            hack = document.createElement('span');
            hack.innerHTML="${uiLabelMap.CommonNoDetailImageAvailableToDisplay}";
            showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonNoDetailImageAvailableToDisplay}");
            return;
        }
        detailImageUrl = detailImageUrl.replace(/\&\#47;/g, "/");
        popUp("<@ofbizUrl>detailImage?detail=" + detailImageUrl + "</@ofbizUrl>", 'detailImage', '400', '550');
    }

    function toggleAmt(toggle) {
        if (toggle == 'Y') {
            changeObjectVisibility("add_amount", "visible");
        }

        if (toggle == 'N') {
            changeObjectVisibility("add_amount", "hidden");
        }
    }

    function findIndex(name) {
        for (i = 0; i < OPT.length; i++) {
            if (OPT[i] == name) {
                return i;
            }
        }
        return -1;
    }

    function getList(name, index, src) {
        currentFeatureIndex = findIndex(name);

        if (currentFeatureIndex == 0) {
            // set the images for the first selection
            if (IMG[index] != null) {
                if (document.images['mainImage'] != null) {
                    document.images['mainImage'].src = IMG[index];
                    detailImageUrl = DET[index];
                }
            }

            // set the drop down index for swatch selection
            document.forms["addform"].elements[name].selectedIndex = (index*1)+1;
        }

        if (currentFeatureIndex < (OPT.length-1)) {
            // eval the next list if there are more
            var selectedValue = document.forms["addform"].elements[name].options[(index*1)+1].value;
            if (index == -1) {
              <#if featureOrderFirst?exists>
                var Variable1 = eval("list" + "${featureOrderFirst}" + "()");
              </#if>
            } else {
                var Variable1 = eval("list" + OPT[(currentFeatureIndex+1)] + selectedValue + "()");
            }
            // set the product ID to NULL to trigger the alerts
            setAddProductId('NULL');

            // set the variant price to NULL
            setVariantPrice('NULL');
        } else {
            // this is the final selection -- locate the selected index of the last selection
            var indexSelected = document.forms["addform"].elements[name].selectedIndex;

            // using the selected index locate the sku
            var sku = document.forms["addform"].elements[name].options[indexSelected].value;

            // display alternative packaging dropdown
            ajaxUpdateArea("product_uom", "<@ofbizUrl>ProductUomDropDownOnly</@ofbizUrl>", "productId=" + sku);

            // set the product ID
            setAddProductId(sku);

            // set the variant price
            setVariantPrice(sku);

            // check for amount box
            toggleAmt(checkAmtReq(sku));
        }
    }

    function validate(x){
        var msg=new Array();
        msg[0]="Please use correct date format [yyyy-mm-dd]";

        var y=x.split("-");
        if(y.length!=3){ showAlert(msg[0]);return false; }
        if((y[2].length>2)||(parseInt(y[2])>31)) { showAlert(msg[0]); return false; }
        if(y[2].length==1){ y[2]="0"+y[2]; }
        if((y[1].length>2)||(parseInt(y[1])>12)){ showAlert(msg[0]); return false; }
        if(y[1].length==1){ y[1]="0"+y[1]; }
        if(y[0].length>4){ showAlert(msg[0]); return false; }
        if(y[0].length<4) {
            if(y[0].length==2) {
                y[0]="20"+y[0];
            } else {
                showAlert(msg[0]);
                return false;
            }
        }
        return (y[0]+"-"+y[1]+"-"+y[2]);
    }

    function showAlert(msg) {
        showErrorAlert("${uiLabelMap.CommonErrorMessage2}",msg);
    }

    function additemSubmit(){
        <#if product.productTypeId?if_exists == "ASSET_USAGE" || product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
        newdatevalue = validate(document.addform.reservStart.value);
        if (newdatevalue == false) {
            document.addform.reservStart.focus();
        } else {
            document.addform.reservStart.value = newdatevalue;
            document.addform.submit();
        }
        <#else>
        document.addform.submit();
        </#if>
    }

    function addShoplistSubmit(){
        <#if product.productTypeId?if_exists == "ASSET_USAGE" || product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
        if (document.addToShoppingList.reservStartStr.value == "") {
            document.addToShoppingList.submit();
        } else {
            newdatevalue = validate(document.addToShoppingList.reservStartStr.value);
            if (newdatevalue == false) {
                document.addToShoppingList.reservStartStr.focus();
            } else {
                document.addToShoppingList.reservStartStr.value = newdatevalue;
                // document.addToShoppingList.reservStart.value = ;
                document.addToShoppingList.reservStartStr.value.slice(0,9)+" 00:00:00.000000000";
                document.addToShoppingList.submit();
            }
        }
        <#else>
        document.addToShoppingList.submit();
        </#if>
    }

    <#if product.virtualVariantMethodEnum?if_exists == "VV_FEATURETREE" && featureLists?has_content>
        function checkRadioButton() {
            var block1 = document.getElementById("addCart1");
            var block2 = document.getElementById("addCart2");
            <#list featureLists as featureList>
                <#list featureList as feature>
                    <#if feature_index == 0>
                        var myList = document.getElementById("FT${feature.productFeatureTypeId}");
                         if (myList.options[0].selected == true){
                             block1.style.display = "none";
                             block2.style.display = "block";
                             return;
                         }
                        <#break>
                    </#if>
                </#list>
            </#list>
            block1.style.display = "block";
            block2.style.display = "none";
        }
    </#if>
    
    function displayProductVirtualVariantId(variantId) {
        document.addform.product_id.value = variantId;
        var elem = document.getElementById('product_id_display');
        var txt = document.createTextNode(variantId);
        if(elem.hasChildNodes()) {
            elem.replaceChild(txt, elem.firstChild);
        } else {
            elem.appendChild(txt);
        }
        setVariantPrice(variantId);
    }
    
    function changeProductImage(imgLarge, imgOriginal){
    	var element = document.getElementById('imgProduct'); 
    	element.parentElement.href = imgOriginal;
    	element.src = imgLarge;
    }
 //-->
 </script>

				<div class="span9">
					<div class="row">

						<div class="product-details clearfix">
							<div class="span5">
								<div class="product-title">
									<h4>${productContentWrapper.get("PRODUCT_NAME")?if_exists}</h4>
								</div>
								
								<div class="product-img">

    <#assign productAdditionalImage1 = productContentWrapper.get("ADDITIONAL_IMAGE_1")?if_exists />
    <#assign productAdditionalImage2 = productContentWrapper.get("ADDITIONAL_IMAGE_2")?if_exists />
    <#assign productAdditionalImage3 = productContentWrapper.get("ADDITIONAL_IMAGE_3")?if_exists />
    <#assign productAdditionalImage4 = productContentWrapper.get("ADDITIONAL_IMAGE_4")?if_exists />
    <#assign productAdditionalImage1_Small = productContentWrapper.get("XTRA_IMG_1_SMALL")?if_exists />
    <#assign productAdditionalImage2_Small = productContentWrapper.get("XTRA_IMG_2_SMALL")?if_exists />
    <#assign productAdditionalImage3_Small = productContentWrapper.get("XTRA_IMG_3_SMALL")?if_exists />
    <#assign productAdditionalImage4_Small = productContentWrapper.get("XTRA_IMG_4_SMALL")?if_exists />
    <#assign productAdditionalImage1_Large = productContentWrapper.get("XTRA_IMG_1_LARGE")?if_exists />
    <#assign productAdditionalImage2_Large = productContentWrapper.get("XTRA_IMG_2_LARGE")?if_exists />
    <#assign productAdditionalImage3_Large = productContentWrapper.get("XTRA_IMG_3_LARGE")?if_exists />
    <#assign productAdditionalImage4_Large = productContentWrapper.get("XTRA_IMG_4_LARGE")?if_exists />

								
                <#assign productSmallImageUrl = productContentWrapper.get("SMALL_IMAGE_URL")?if_exists />
                <#assign productLargeImageUrl = productContentWrapper.get("LARGE_IMAGE_URL")?if_exists />
                <#assign productOriginalImageUrl = productContentWrapper.get("ORIGINAL_IMAGE_URL")?if_exists />
                <#-- remove the next two lines to always display the virtual image first (virtual images must exist) -->
                <#if firstLargeImage?has_content>
                    <#assign productLargeImageUrl = firstLargeImage />
                </#if>
                <#if productLargeImageUrl?string?has_content>
									<a class="fancybox" href="<@ofbizContentUrl>${contentPathPrefix?if_exists}${productOriginalImageUrl?if_exists}</@ofbizContentUrl>">
										<img id="imgProduct" src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${productLargeImageUrl?if_exists}</@ofbizContentUrl>" alt="">
									</a>
                </#if>
                <#if !productLargeImageUrl?string?has_content>
									<a class="fancybox" href="/images/defaultImage.jpg"><img src="/images/defaultImage.jpg" alt=""></a>
                </#if>
								
								</div><!--end product-img-->
								<div class="product-img-thumb">
								
                <#if productLargeImageUrl?string?has_content>
									<a class="fancybox" href="javascript:changeProductImage('<@ofbizContentUrl>${contentPathPrefix?if_exists}${productLargeImageUrl?if_exists}</@ofbizContentUrl>', '<@ofbizContentUrl>${contentPathPrefix?if_exists}${productOriginalImageUrl?if_exists}</@ofbizContentUrl>');"><img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${productSmallImageUrl?if_exists}</@ofbizContentUrl>" alt=""></a>
                </#if>
                <#if productAdditionalImage1?string?has_content>
									<a class="fancybox" href="javascript:changeProductImage('<@ofbizContentUrl>${productAdditionalImage1_Large}</@ofbizContentUrl>', '<@ofbizContentUrl>${productAdditionalImage1}</@ofbizContentUrl>');"><img src="<@ofbizContentUrl>${productAdditionalImage1_Small}</@ofbizContentUrl>" alt=""></a>
                </#if>
                <#if productAdditionalImage2?string?has_content>
									<a class="fancybox" href="javascript:changeProductImage('<@ofbizContentUrl>${productAdditionalImage2_Large}</@ofbizContentUrl>', '<@ofbizContentUrl>${productAdditionalImage2}</@ofbizContentUrl>');"><img src="<@ofbizContentUrl>${productAdditionalImage2_Small}</@ofbizContentUrl>" alt=""></a>
                </#if>
                <#if productAdditionalImage3?string?has_content>
									<a class="fancybox" href="javascript:changeProductImage('<@ofbizContentUrl>${productAdditionalImage3_Large}</@ofbizContentUrl>', '<@ofbizContentUrl>${productAdditionalImage3}</@ofbizContentUrl>');"><img src="<@ofbizContentUrl>${productAdditionalImage3_Small}</@ofbizContentUrl>" alt=""></a>
                </#if>
                <#if productAdditionalImage4?string?has_content>
									<a class="fancybox" href="javascript:changeProductImage('<@ofbizContentUrl>${productAdditionalImage4_Large}</@ofbizContentUrl>', '<@ofbizContentUrl>${productAdditionalImage4}</@ofbizContentUrl>');"><img src="<@ofbizContentUrl>${productAdditionalImage4_Small}</@ofbizContentUrl>" alt=""></a>
                </#if>
								
								</div><!--end flexslider-thumb-->
							</div><!--end span5-->

							<div class="span4">
								<div class="product-set">
									<div class="product-price">
          <#-- for prices:
                  - if price < competitivePrice, show competitive or "Compare At" price
                  - if price < listPrice, show list price
                  - if price < defaultPrice and defaultPrice < listPrice, show default
                  - if isSale show price with salePrice style and print "On Sale!"
          -->
          <#if price.competitivePrice?exists && price.price?exists && price.price &lt; price.competitivePrice>
            <div>${uiLabelMap.ProductCompareAtPrice}: <span class="basePrice"><@ofbizCurrency amount=price.competitivePrice isoCode=price.currencyUsed /></span></div>
          </#if>
          <#if price.listPrice?exists && price.price?exists && price.price &lt; price.listPrice>
            <div>${uiLabelMap.ProductListPrice}: <span class="basePrice"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed /></span></div>
          </#if>
          <#if price.listPrice?exists && price.defaultPrice?exists && price.price?exists && price.price &lt; price.defaultPrice && price.defaultPrice &lt; price.listPrice>
            <div>${uiLabelMap.ProductRegularPrice}: <span class="basePrice"><@ofbizCurrency amount=price.defaultPrice isoCode=price.currencyUsed /></span></div>
          </#if>
          <#if price.specialPromoPrice?exists>
            <div>${uiLabelMap.ProductSpecialPromoPrice}: <span class="basePrice"><@ofbizCurrency amount=price.specialPromoPrice isoCode=price.currencyUsed /></span></div>
          </#if>
          <div>
            <strong>
              <#if price.isSale?exists && price.isSale>
                <span class="salePrice">${uiLabelMap.OrderOnSale}!</span>
                <#assign priceStyle = "salePrice" />
              <#else>
                <#assign priceStyle = "regularPrice" />
              </#if>
                ${uiLabelMap.OrderYourPrice}: <#if "Y" = product.isVirtual?if_exists> ${uiLabelMap.CommonFrom} </#if><span class="${priceStyle}"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed /></span>
                 <#if product.productTypeId?if_exists == "ASSET_USAGE" || product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
                <#if product.reserv2ndPPPerc?exists && product.reserv2ndPPPerc != 0><br /><span class="${priceStyle}">${uiLabelMap.ProductReserv2ndPPPerc}<#if !product.reservNthPPPerc?exists || product.reservNthPPPerc == 0>${uiLabelMap.CommonUntil} ${product.reservMaxPersons?if_exists}</#if> <@ofbizCurrency amount=product.reserv2ndPPPerc*price.price/100 isoCode=price.currencyUsed /></span></#if>
                <#if product.reservNthPPPerc?exists &&product.reservNthPPPerc != 0><br /><span class="${priceStyle}">${uiLabelMap.ProductReservNthPPPerc} <#if !product.reserv2ndPPPerc?exists || product.reserv2ndPPPerc == 0>${uiLabelMap.ProductReservSecond} <#else> ${uiLabelMap.ProductReservThird} </#if> ${uiLabelMap.CommonUntil} ${product.reservMaxPersons?if_exists}, ${uiLabelMap.ProductEach}: <@ofbizCurrency amount=product.reservNthPPPerc*price.price/100 isoCode=price.currencyUsed /></span></#if>
                <#if (!product.reserv2ndPPPerc?exists || product.reserv2ndPPPerc == 0) && (!product.reservNthPPPerc?exists || product.reservNthPPPerc == 0)><br />${uiLabelMap.ProductMaximum} ${product.reservMaxPersons?if_exists} ${uiLabelMap.ProductPersons}.</#if>
                 </#if>
             </strong>
          </div>
          <#if price.listPrice?exists && price.price?exists && price.price &lt; price.listPrice>
            <#assign priceSaved = price.listPrice - price.price />
            <#assign percentSaved = (priceSaved / price.listPrice) * 100 />
            <div>${uiLabelMap.OrderSave}: <span class="basePrice"><@ofbizCurrency amount=priceSaved isoCode=price.currencyUsed /> (${percentSaved?int}%)</span></div>
          </#if>
          <#-- show price details ("showPriceDetails" field can be set in the screen definition) -->
          <#if (showPriceDetails?exists && showPriceDetails?default("N") == "Y")>
              <#if price.orderItemPriceInfos?exists>
                  <#list price.orderItemPriceInfos as orderItemPriceInfo>
                      <div>${orderItemPriceInfo.description?if_exists}</div>
                  </#list>
              </#if>
          </#if>

										
									</div><!--end product-price-->
									
          <#if averageRating?exists && (averageRating?double > 0) && numRatings?exists && (numRatings?long > 1)>
									<div class="product-rate clearfix">
										<ul class="rating" title="${uiLabelMap.OrderAverageRating}: ${averageRating} (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})">
											<li><i class="<#if (averageRating?double > 0.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 1.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 2.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 3.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (averageRating?double > 4.5)>star-on<#else>star-off</#if>"></i></li>
										</ul>
										<span>${numRatings} ${uiLabelMap.OrderRatings}</span>
									</div><!--end product-inputs-->
          </#if>
	
									<div class="product-info">
										<dl class="dl-horizontal">
										
										
      <#-- Included quantities/pieces -->
      <#if product.piecesIncluded?exists && product.piecesIncluded?long != 0>
          <dt>${uiLabelMap.OrderPieces}: </dt><dd>${product.piecesIncluded}</dd>
      </#if>
      <#if (product.quantityIncluded?exists && product.quantityIncluded?double != 0) || product.quantityUomId?has_content>
        <#assign quantityUom = product.getRelatedOne("QuantityUom", true)?if_exists/>
          <dt>${uiLabelMap.CommonQuantity}: </dt><dd>${product.quantityIncluded?if_exists} ${((quantityUom.abbreviation)?default(product.quantityUomId))?if_exists}</dd>
      </#if>

      <#if (product.weight?exists && product.weight?double != 0) || product.weightUomId?has_content>
        <#assign weightUom = product.getRelatedOne("WeightUom", true)?if_exists/>
          <dt>${uiLabelMap.CommonWeight}: </dt><dd>${product.weight?if_exists} ${((weightUom.abbreviation)?default(product.weightUomId))?if_exists}</dd>
      </#if>
      <#if (product.productHeight?exists && product.productHeight?double != 0) || product.heightUomId?has_content>
        <#assign heightUom = product.getRelatedOne("HeightUom", true)?if_exists/>
          <dt>${uiLabelMap.CommonHeight}: </dt><dd>${product.productHeight?if_exists} ${((heightUom.abbreviation)?default(product.heightUomId))?if_exists}</dd>
      </#if>
      <#if (product.productWidth?exists && product.productWidth?double != 0) || product.widthUomId?has_content>
        <#assign widthUom = product.getRelatedOne("WidthUom", true)?if_exists/>
          <dt>${uiLabelMap.CommonWidth}: </dt><dd>${product.productWidth?if_exists} ${((widthUom.abbreviation)?default(product.widthUomId))?if_exists}</dd>
      </#if>
      <#if (product.productDepth?exists && product.productDepth?double != 0) || product.depthUomId?has_content>
        <#assign depthUom = product.getRelatedOne("DepthUom", true)?if_exists/>
          <dt>${uiLabelMap.CommonDepth}: </dt><dd>${product.productDepth?if_exists} ${((depthUom.abbreviation)?default(product.depthUomId))?if_exists}</dd>
      </#if>

      <#if daysToShip?exists>
        <dt><b>${uiLabelMap.ProductUsuallyShipsIn} <font color="red">${daysToShip}</font> ${uiLabelMap.CommonDays}!<b></dt>
      </#if>

      <#if disFeatureList?exists && 0 < disFeatureList.size()>
      <p>&nbsp;</p>
        <#list disFeatureList as currentFeature>
            <#assign disFeatureType = currentFeature.getRelatedOne("ProductFeatureType", true)/>
            <div>
                <#if disFeatureType.description?exists>${disFeatureType.get("description", locale)}<#else>${currentFeature.productFeatureTypeId}</#if>:&nbsp;${currentFeature.description}
            </div>
        </#list>
            <div>&nbsp;</div>
      </#if>				
      
      <span id="variant_product" style="display:none">
      		<dt>${uiLabelMap.ProductProductId}: </dt><dd><b><span id="product_id_display"> </span></b></dd>
            <dt>${uiLabelMap.ProductPrice}: </dt><dd><b><span id="variant_price_display"> </span></b></dd>
	  </span>            
      						
										</dl>
									</div><!--end product-info-->

									<div class="product-inputs">
									
      <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="addform"  style="margin: 0;">
											<div class="controls-row">

        <#if requestAttributes.paramMap?has_content>
          <input type="hidden" name="itemComment" value="${requestAttributes.paramMap.itemComment?if_exists}" />
          <input type="hidden" name="shipBeforeDate" value="${requestAttributes.paramMap.shipBeforeDate?if_exists}" />
          <input type="hidden" name="shipAfterDate" value="${requestAttributes.paramMap.shipAfterDate?if_exists}" />
          <input type="hidden" name="itemDesiredDeliveryDate" value="${requestAttributes.paramMap.itemDesiredDeliveryDate?if_exists}" />
        </#if>
        <#assign inStock = true>
        <#-- Variant Selection -->
        <#if product.isVirtual?if_exists?upper_case == "Y">
          <#if product.virtualVariantMethodEnum?if_exists == "VV_FEATURETREE" && featureLists?has_content>
            <#list featureLists as featureList>
                <#list featureList as feature>
                    <#if feature_index == 0>
                        ${feature.description}: <select class="span2" id="FT${feature.productFeatureTypeId}" name="FT${feature.productFeatureTypeId}" onchange="javascript:checkRadioButton();">
                        <option value="select" selected="selected"> select option </option>
                    <#else>
                        <option value="${feature.productFeatureId}">${feature.description} <#if feature.price?exists>(+ <@ofbizCurrency amount=feature.price?string isoCode=feature.currencyUomId/>)</#if></option>
                    </#if>
                </#list>
                </select>
            </#list>
              <input type="hidden" name="product_id" value="${product.productId}"/>
              <input type="hidden" name="add_product_id" value="${product.productId}"/>
            <div id="addCart1" style="display:none;>
              <span style="white-space: nowrap;"><b>${uiLabelMap.CommonQuantity}:</b></span>&nbsp;
              <input type="text" size="5" name="quantity" value="1"/>
              <a href="javascript:javascript:addItem();" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
              &nbsp;
            </div>
            <div id="addCart2" style="display:block;>
              <span style="white-space: nowrap;"><b>${uiLabelMap.CommonQuantity}:</b></span>&nbsp;
              <input type="text" size="5" value="1" disabled="disabled"/>
              <a href="javascript:showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonPleaseSelectAllFeaturesFirst}");" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
              &nbsp;
            </div>
          </#if>
          <#if !product.virtualVariantMethodEnum?exists || product.virtualVariantMethodEnum == "VV_VARIANTTREE">
           <#if variantTree?exists && (variantTree.size() > 0)>
            <#list featureSet as currentType>
                <select class="span2" name="FT${currentType}" onchange="javascript:getList(this.name, (this.selectedIndex-1), 1);">
                  <option>${featureTypes.get(currentType)}</option>
                </select>
            </#list>
            <span id="product_uom"></span>
            <input type="hidden" name="product_id" value="${product.productId}"/>
            <input type="hidden" name="add_product_id" value="NULL"/>
          <#else>
            <input type="hidden" name="product_id" value="${product.productId}"/>
            <input type="hidden" name="add_product_id" value="NULL"/>
            <div><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
            <#assign inStock = false>
          </#if>
         </#if>
        <#else>
          <input type="hidden" name="product_id" value="${product.productId}"/>
          <input type="hidden" name="add_product_id" value="${product.productId}"/>
          <#if productStoreId?exists>
            <#assign isStoreInventoryNotAvailable = !(Static["org.ofbiz.product.store.ProductStoreWorker"].isStoreInventoryAvailable(request, product, 1.0?double))>
            <#assign isStoreInventoryRequired = Static["org.ofbiz.product.store.ProductStoreWorker"].isStoreInventoryRequired(request, product)>
            <#if isStoreInventoryNotAvailable>
              <#if isStoreInventoryRequired>
                <div><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
                <#assign inStock = false>
              <#else>
                <div><b>${product.inventoryMessage?if_exists}</b></div>
              </#if>
            </#if>
          </#if>
        </#if>

        <#-- check to see if introductionDate hasnt passed yet -->
        <#if product.introductionDate?exists && nowTimestamp.before(product.introductionDate)>
        <p>&nbsp;</p>
          <div style="color: red;">${uiLabelMap.ProductProductNotYetMadeAvailable}.</div>
        <#-- check to see if salesDiscontinuationDate has passed -->
        <#elseif product.salesDiscontinuationDate?exists && nowTimestamp.after(product.salesDiscontinuationDate)>
          <div style="color: red;">${uiLabelMap.ProductProductNoLongerAvailable}.</div>
        <#-- check to see if the product requires inventory check and has inventory -->
        <#elseif product.virtualVariantMethodEnum?if_exists != "VV_FEATURETREE">
          <#if inStock>
            <#if product.requireAmount?default("N") == "Y">
              <#assign hiddenStyle = "visible">
            <#else>
              <#assign hiddenStyle = "hidden">
            </#if>
            <div id="add_amount" class="${hiddenStyle}">
              <span style="white-space: nowrap;"><b>${uiLabelMap.CommonAmount}:</b></span>&nbsp;
              <input type="text" size="5" name="add_amount" value=""/>
            </div>
            
											</div><!--end controls-row-->

											<div class="input-append">
            
            <#if product.productTypeId?if_exists == "ASSET_USAGE" || product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
                    <@htmlTemplate.renderDateTimeField name="reservStart" event="" action="" value="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="startDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                    <@htmlTemplate.renderDateTimeField name="reservEnd" event="" action="" value="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="endDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                <#--td nowrap="nowrap" align="right">Number<br />of days</td><td><input type="textt" size="4" name="reservLength"/></td></tr><tr><td>&nbsp;</td><td align="right" nowrap>&nbsp;</td-->
                Number of persons: <input type="text" size="4" name="reservPersons" value="2"/>
                Number of rooms: <input type="text" size="5" name="quantity" value="1"/>
            <#else/>
				<input class="span1" type="text" name="quantity" value="1" <#if product.isVirtual?if_exists?upper_case == "Y"> disabled="disabled"</#if>/>
            </#if>
            <#-- This calls addItem() so that variants of virtual products cant be added before distinguishing features are selected, it should not be changed to additemSubmit() -->
            <span style="white-space: nowrap;">
            <button onclick="addItem();" class="btn btn-primary" type="button"><i class="icon-shopping-cart"></i> ${uiLabelMap.OrderAddToCart}</button></span>
          </#if>
          <#if requestParameters.category_id?exists>
            <input type="hidden" name="category_id" value="${requestParameters.category_id}"/>
          </#if>
        </#if>
      
											

											<button onclick="document.addToCompare2form.submit()" form="addToCompare2form" class="btn" data-title="${uiLabelMap.ProductAddToCompare}" data-placement="top" data-toggle="tooltip" type="button">
												<i class="icon-refresh"></i>												
											</button>
											</div>
										</form><!--end form-->

          <form method="post" action="<@ofbizUrl secure="${request.isSecure()?string}">addToCompare</@ofbizUrl>" name="addToCompare2form">
              <input type="hidden" name="productId" value="${product.productId}"/>
              <input type="hidden" name="mainSubmitted" value="Y"/>
          </form>

    <div>
      <#if sessionAttributes.userLogin?has_content && sessionAttributes.userLogin.userLoginId != "anonymous">
        <hr />
        <form name="addToShoppingList" method="post" action="<@ofbizUrl>addItemToShoppingList<#if requestAttributes._CURRENT_VIEW_?exists>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>">
          <input type="hidden" name="productId" value="${product.productId}"/>
          <input type="hidden" name="product_id" value="${product.productId}"/>
          <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}"/>
          <input type="hidden" name="reservStart" value= ""/>
          <select name="shoppingListId">
            <#if shoppingLists?has_content>
              <#list shoppingLists as shoppingList>
                <option value="${shoppingList.shoppingListId}">${shoppingList.listName}</option>
              </#list>
            </#if>
            <option value="">---</option>
            <option value="">${uiLabelMap.OrderNewShoppingList}</option>
          </select>
          &nbsp;&nbsp;
          <#if product.productTypeId?if_exists == "ASSET_USAGE" || product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
              <table><tr><td>&nbsp;</td><td align="right">${uiLabelMap.CommonStartDate} (yyyy-mm-dd)</td><td><input type="text" size="10" name="reservStartStr" /></td><td>Number of&nbsp;days</td><td><input type="text" size="4" name="reservLength" /></td><td>&nbsp;</td><td align="right">Number of&nbsp;persons</td><td><input type="text" size="4" name="reservPersons" value="1" /></td><td align="right">Qty&nbsp;</td><td><input type="text" size="5" name="quantity" value="1" /></td></tr></table>
          <#else>
											<div class="input-append">
          
				<input class="span1" type="text" name="quantity" value="1"/>
              	<input type="hidden" name="reservStartStr" value= ""/>
              
        		<a href="javascript:addShoplistSubmit();"><span style="white-space: nowrap;">
            		<button class="btn btn-primary"><i class="icon-shopping-cart"></i> ${uiLabelMap.OrderAddToShoppingList}</button></span>
            	</a>
											</div>
              
          </#if>
        </form>
        
        
      <#else> <br />
        ${uiLabelMap.OrderYouMust} <a href="<@ofbizUrl>checkLogin/showcart</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonBeLogged}</a>
        ${uiLabelMap.OrderToAddSelectedItemsToShoppingList}.&nbsp;
      </#if>
      </div>
      <#-- Prefill first select box (virtual products only) -->
      <#if variantTree?exists && 0 < variantTree.size()>
        <script language="JavaScript" type="text/javascript">eval("list" + "${featureOrderFirst}" + "()");</script>
      </#if>

      <#-- Swatches (virtual products only) -->
      <#if variantSample?exists && 0 < variantSample.size()>
        <#assign imageKeys = variantSample.keySet()>
        <#assign imageMap = variantSample>
        <p>&nbsp;</p>
        <table cellspacing="0" cellpadding="0">
          <tr>
            <#assign maxIndex = 7>
            <#assign indexer = 0>
            <#list imageKeys as key>
              <#assign swatchProduct = imageMap.get(key)>
              <#if swatchProduct?has_content && indexer < maxIndex>
                <#assign imageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(swatchProduct, "SMALL_IMAGE_URL", request)?if_exists>
                <#if !imageUrl?string?has_content>
                  <#assign imageUrl = productContentWrapper.get("SMALL_IMAGE_URL")?if_exists>
                </#if>
                <#if !imageUrl?string?has_content>
                  <#assign imageUrl = "/images/defaultImage.jpg">
                </#if>
                <td align="center" valign="bottom">
                  <a href="javascript:getList('FT${featureOrderFirst}','${indexer}',1);"><img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${imageUrl}</@ofbizContentUrl>" class='cssImgSmall' alt="" /></a>
                  <br />
                  <a href="javascript:getList('FT${featureOrderFirst}','${indexer}',1);" class="linktext">${key}</a>
                </td>
              </#if>
              <#assign indexer = indexer + 1>
            </#list>
            <#if (indexer > maxIndex)>
              <div><b>${uiLabelMap.ProductMoreOptions}</b></div>
            </#if>
          </tr>
        </table>
      </#if>

																	
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
<div style="padding-top:10px"><span id="fb-like-span"></span></div>

<script>
	window.onload = function () {
    var currentUrl = window.location.href;
    //document.getElementById("fb-like-olbius").setAttribute("data-href", currentUrl);
    document.getElementById("fb-like-span").innerHTML = '<div id="fb-like-olbius" class="fb-like" data-href="' + currentUrl + '" data-width="450" layout="button_count"></div>';
if (typeof FB !== 'undefined') {
    FB.XFBML.parse(document.getElementById('fb-like-span'));
}
}
</script>

  <#-- Digital Download Files Associated with this Product -->
  <#if downloadProductContentAndInfoList?has_content>
    <div id="download-files">
      <div>${uiLabelMap.OrderDownloadFilesTitle}:</div>
      <#list downloadProductContentAndInfoList as downloadProductContentAndInfo>
        <div>${downloadProductContentAndInfo.contentName}<#if downloadProductContentAndInfo.description?has_content> - ${downloadProductContentAndInfo.description}</#if></div>
      </#list>
    </div>
  </#if>

									</div><!--end product-inputs-->
								</div><!--end product-set-->
							</div><!--end span4-->

						</div><!--end product-details-->

					</div><!--end row-->
<br />


					<div class="product-tab">
						<ul class="nav nav-tabs">
						  <li class="active">
						  	<a href="#descraption" data-toggle="tab">${uiLabelMap.EcommerceDescription}</a>
						  </li>
						  <li>
						  	<a href="#read-review" data-toggle="tab">${uiLabelMap.OrderCustomerReviews}</a>
						  </li>
						  <li>
						  	<a href="#make-review" data-toggle="tab">${uiLabelMap.ProductMakeReview}</a>
						  </li>
						</ul>
						<div class="tab-content">
							<div class="tab-pane active" id="descraption">
								  <#-- Long description of product -->
							      <p>${productContentWrapper.get("LONG_DESCRIPTION")?if_exists}</p>
							      <p>${productContentWrapper.get("WARNINGS")?if_exists}</p>
							</div>
							<div class="tab-pane" id="read-review">
							
      <#-- Product Reviews -->
          <#if productReviews?has_content>
            <#list productReviews as productReview>
              <#assign postedUserLogin = productReview.getRelatedOne("UserLogin", false) />
              <#assign postedPerson = postedUserLogin.getRelatedOne("Person", false)?if_exists />
								<div class="single-review clearfix">
									<div class="review-header">
										<ul class="rating">
											<li><i class="<#if (productReview.productRating?if_exists?double > 0.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (productReview.productRating?if_exists?double > 1.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (productReview.productRating?if_exists?double > 2.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (productReview.productRating?if_exists?double > 3.5)>star-on<#else>star-off</#if>"></i></li>
											<li><i class="<#if (productReview.productRating?if_exists?double > 4.5)>star-on<#else>star-off</#if>"></i></li>
										</ul>
										<h4>${uiLabelMap.CommonBy}: <#if productReview.postedAnonymous?default("N") == "Y"> ${uiLabelMap.OrderAnonymous}<#else> ${postedPerson.firstName} ${postedPerson.lastName}</#if></h4>
										<small>${uiLabelMap.CommonAt}: ${productReview.postedDateTime?if_exists}</small>
									</div><!--end review-header-->

									<div class="review-body">
										<p>${productReview.productReview?if_exists}</p>
									</div><!--end review-body-->
								</div><!--end single-review-->

            </#list>
          <#else>
            <div>${uiLabelMap.ProductProductNotReviewedYet}.</div>
            <div>
                <a href="#make-review" data-toggle="tab" class="linktext">${uiLabelMap.ProductBeTheFirstToReviewThisProduct}</a>
            </div>
      </#if>							
							

							</div>

							<div class="tab-pane" id="make-review">
      <#if sessionAttributes.userLogin?has_content && sessionAttributes.userLogin.userLoginId != "anonymous">
							
								<form id="reviewProduct" method="post" action="<@ofbizUrl>createProductReview</@ofbizUrl>" class="form-horizontal">
      <input type="hidden" name="productStoreId" value="${productStore.productStoreId}" />
      <input type="hidden" name="productId" value="${product.productId}" />
      <input type="hidden" name="product_id" value="${product.productId}" />
      <input type="hidden" name="category_id" value="${categoryId?if_exists}" />
								
									<div class="control-group">
									    <label class="control-label">${uiLabelMap.EcommercePostAnonymous} <span class="text-error">*</span></label>
									    <div class="controls">
									        <span>
									          <label for="yes">${uiLabelMap.CommonYes}</label>
									          <input type="radio" id="yes" name="postedAnonymous" value="Y" />
									        </span>
									        <span>
									          <label for="no">${uiLabelMap.CommonNo}</label>
									          <input type="radio" id="no" name="postedAnonymous" value="N" checked="checked" />
									        </span>
									    </div>
									</div>
									<div class="control-group">
										<label class="control-label" for="productReview">${uiLabelMap.CommonReview} <span class="text-error">*</span></label>
									    <div class="controls">
									      <textarea name="productReview" id="productReview" placeholder="${uiLabelMap.CommonReview}..." cols="60"></textarea>
									    </div>
									</div>
									<div class="control-group">
										<label class="control-label" for="inputReview">${uiLabelMap.EcommerceRating} <span class="text-error">*</span></label>
									    <div class="controls">
									        <span>
									          <label for="one">1</label> 
									          <input type="radio" id="one" name="productRating" value="1.0" />
									        </span>
									        <span>
									          <label for="two">2</label>
									          <input type="radio" id="two" name="productRating" value="2.0" />
									        </span>
									        <span>
									          <label for="three">3</label>
									          <input type="radio" id="three" name="productRating" value="3.0" />
									        </span>
									        <span>
									          <label for="four">4</label>
									          <input type="radio" id="four" name="productRating" value="4.0" />
									        </span>
									        <span>
									          <label for="five">5</label>
									          <input type="radio" id="five" name="productRating" value="5.0" />
									        </span>
									    </div>
									</div>
									<div class="control-group">
									    <div class="controls">
									    
        <a href="javascript:document.getElementById('reviewProduct').submit();"><button class="btn btn-primary">${uiLabelMap.CommonSave}</button></a>
									    
									    </div>
									</div>
								</form><!--end form-->
          <#else>
			<a href="<@ofbizUrl>checkLogin/product?product_id=${product.productId}</@ofbizUrl>" class="button">${uiLabelMap.CommonBeLogged}</a>          
          </#if>
							</div>
						</div><!--end tab-content-->
					</div><!--end product-tab-->


    <#-- Upgrades/Up-Sell/Cross-Sell -->
      <#macro associated assocProducts beforeName showName afterName formNamePrefix targetRequestName>
      <#assign pageProduct = product />
      <#assign targetRequest = "product" />
      <#if targetRequestName?has_content>
        <#assign targetRequest = targetRequestName />
      </#if>
      <#if assocProducts?has_content>
      
					<div class="related-product">
						<div class="titleHeader clearfix">
							<h3>${beforeName?if_exists}<#if showName == "Y">${productContentWrapper.get("PRODUCT_NAME")?if_exists}</#if>${afterName?if_exists}</h3>
						</div><!--end titleHeader-->

						<div class="row">
						<ul class="hProductItems clearfix">
      
        <#list assocProducts as productAssoc>
            <#if productAssoc.productId == product.productId>
                <#assign assocProductId = productAssoc.productIdTo />
            <#else>
                <#assign assocProductId = productAssoc.productId />
            </#if>
          ${setRequestAttribute("optProductId", assocProductId)}
          ${setRequestAttribute("listIndex", listIndex)}
          ${setRequestAttribute("formNamePrefix", formNamePrefix)}
          <#if targetRequestName?has_content>
            ${setRequestAttribute("targetRequestName", targetRequestName)}
          </#if>
              ${screens.render(productsummaryScreen)}
          <#assign product = pageProduct />
          <#local listIndex = listIndex + 1 />
        </#list>
						</ul>
						</div><!--end row-->
					</div><!--end related-product-->
    
        ${setRequestAttribute("optProductId", "")}
        ${setRequestAttribute("formNamePrefix", "")}
        ${setRequestAttribute("targetRequestName", "")}
      </#if>
    </#macro>
    
    <#assign productValue = product />
    <#assign listIndex = 1 />
    ${setRequestAttribute("productValue", productValue)}

        <#-- also bought -->
        <@associated assocProducts=alsoBoughtProducts beforeName="" showName="N" afterName="${uiLabelMap.ProductAlsoBought}" formNamePrefix="albt" targetRequestName="" />
        <#-- obsolete -->
        <@associated assocProducts=obsoleteProducts beforeName="" showName="Y" afterName=" ${uiLabelMap.ProductObsolete}" formNamePrefix="obs" targetRequestName="" />
        <#-- cross sell -->
        <@associated assocProducts=crossSellProducts beforeName="" showName="N" afterName="${uiLabelMap.ProductCrossSell}" formNamePrefix="cssl" targetRequestName="crosssell" />
        <#-- up sell -->
        <@associated assocProducts=upSellProducts beforeName="${uiLabelMap.ProductUpSell} " showName="Y" afterName=":" formNamePrefix="upsl" targetRequestName="upsell" />
        <#-- obsolescence -->
        <@associated assocProducts=obsolenscenseProducts beforeName="" showName="Y" afterName=" ${uiLabelMap.ProductObsolescense}" formNamePrefix="obce" targetRequestName="" />

    
    <#-- special cross/up-sell area using commonFeatureResultIds (from common feature product search) -->
    <#if comsmonFeatureResultIds?has_content>
    
					<div class="related-product">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.ProductSimilarProducts}</h3>
						</div><!--end titleHeader-->

						<div class="row">
						<ul class="hProductItems clearfix">
    
            <#list commonFeatureResultIds as commonFeatureResultId>
                ${setRequestAttribute("optProductId", commonFeatureResultId)}
                ${setRequestAttribute("listIndex", commonFeatureResultId_index)}
                ${setRequestAttribute("formNamePrefix", "cfeatcssl")}
                <#-- ${setRequestAttribute("targetRequestName", targetRequestName)} -->
                ${screens.render(productsummaryScreen)}
            </#list>
						</ul>
						</div><!--end row-->
					</div><!--end related-product-->
    </#if>
    <div class="product-tags">
        <h3><p class="titleProductTags">${uiLabelMap.EcommerceProductTags}</p></h3>
        <#if productTags?exists>
            <p class="titleAddTags"><strong>${uiLabelMap.EcommerceProductTagsDetail}:</strong></p>
                <ul>
                    <li>
                    <#assign no = 0 />
                    <#list productTags?keys?sort as productTag>
                        <#assign tagValue = productTags.get(productTag)?if_exists/>
                        <#if tagValue?has_content>
                              <span><a href="javascript:void(0);" id="productTag_${productTag}">${productTag}</a> (${tagValue}) <#if no < (productTags.size() - 1)> | </#if></span>
                              <#assign no = no + 1 />
                        </#if>
                    </#list>
                    </li>
                </ul>
        </#if>
        
        <p class="titleAddTags"><strong>${uiLabelMap.EcommerceAddYourTags}:</strong></p>
            <form method="post" action="<@ofbizUrl>addProductTags</@ofbizUrl>" name="addProductTags">
                <input type="hidden" name="productId" value="${product.productId?if_exists}"/>
                <input class="inputProductTags" type="text" value="" name="productTags" id="productTags" size="40"/>
                <input class="buttonProductTags" type="submit" value="${uiLabelMap.EcommerceAddTags}" name="addTag"/>
            </form>
            <span>${uiLabelMap.EcommerceAddTagsDetail}</span>
    </div>
    <hr />
    <form action="<@ofbizUrl>tagsearch</@ofbizUrl>" method="post" name="productTagsearchform" id="productTagsearchform">
        <input type="hidden" name="keywordTypeId" value="KWT_TAG"/>
        <input type="hidden" name="statusId" value="KW_APPROVED"/>
        <input type="hidden" name="clearSearch" value="Y"/>
        <input type="hidden" name="VIEW_SIZE" value="10"/>
        <input type="hidden" name="PAGING" value="Y"/>
        <input type="hidden" name="SEARCH_STRING" id="productTagStr"/>
    </form>
<div id="fb-root"></div>

				</div><!--end span9-->