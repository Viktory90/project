<#-- variable setup -->
<#assign price = priceMap?if_exists />
<#assign productImageList = productImageList?if_exists />
<#-- end variable setup -->

<#-- virtual product javascript -->
${virtualJavaScript?if_exists}
${virtualVariantJavaScript?if_exists}

<style>
	.yith-wcwl-add-button > a.button.alt{background:#4F4F4F;color:#FFFFFF;border-color:#4F4F4F;}.wishlist_table a.add_to_cart.button.alt{background:#4F4F4F;color:#FFFFFF;border-color:#4F4F4F;}.wishlist_table{background:#FFFFFF;color:#676868;border-color:#676868;}
	
</style>

<link rel="stylesheet" href="/bazar/css/colorbox.css" type="text/css">
<link rel="stylesheet" href="/bazar/css/new/yith_magnifier.css" type="text/css">

<style type="text/css">
	#product-img{
		position:relative;
		width:auto;
		height:auto;
		max-width:462px;
	   	width: expression(this.width &gt; 462 ? 462: true);
	   	max-height:392px;
	   	height: expression(this.height &gt; 392 ? 392: true);
	}
	#addToCart:hover{
		color:#FFF;
	}
	#price{
		background: url('/bazar/images/icons/price-icon.png') left top no-repeat !important;
		height:15px;
	}
	.control-group label{
		display:inline-block;
	}
</style>

<style type="text/css">
	#product-id {
		width:auto; 
		height:auto; 
		max-width:150px !important; 
		max-height:150px !important; 
		margin-left: auto; 
		margin-right: auto;
	}
</style>


<script type="text/javascript">
	//<![CDATA[
    var detailImageUrl = null;
    function setAddProductId(name) {
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
        if (sku == '' || sku == 'NULL' || isVirtual(sku) == true) {
            var elem = document.getElementById('variant_price_display');
            document.getElementById('variant_price_display').innerHTML = "";
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
        else {
            var elem = document.getElementById('variant_price_display');
            document.getElementById('variant_price_display').innerHTML = "";
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
           //showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonPleaseSelectAllRequiredOptions}");
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

    function popupDetail(specificDetailImageUrl) {
        if( specificDetailImageUrl ) {
            detailImageUrl = specificDetailImageUrl;
        }
        else {
            var defaultDetailImage = "${firstDetailImage?default(mainDetailImageUrl?default("_NONE_"))}";
            if (defaultDetailImage == null || defaultDetailImage == "null" || defaultDetailImage == "") {
               defaultDetailImage = "_NONE_";
            }

            if (detailImageUrl == null || detailImageUrl == "null") {
                detailImageUrl = defaultDetailImage;
            }
        }

        if (detailImageUrl == "_NONE_") {
            hack = document.createElement('span');
            hack.innerHTML="${uiLabelMap.CommonNoDetailImageAvailableToDisplay}";
            showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonNoDetailImageAvailableToDisplay}");
            return;
        }
        detailImageUrl = detailImageUrl.replace(/\&\#47;/g, "/");
        popUp("<@ofbizUrl>detailImage?detail=" + detailImageUrl + "</@ofbizUrl>", 'detailImage', '600', '600');
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

    function showAlert(msg){
        showErrorAlert("${uiLabelMap.CommonErrorMessage2}", msg);
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
        if(variantId){
            document.addform.product_id.value = variantId;
        }else{
            document.addform.product_id.value = '';
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
        document.getElementById('variant_price_display').innerHTML = "";
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
//]]>
$(function(){
    $('a[id^=productTag_]').click(function(){
        var id = $(this).attr('id');
        var ids = id.split('_');
        var productTagStr = ids[1];
        if (productTagStr) {
            $('#productTagStr').val(productTagStr);
            $('#productTagsearchform').submit();
        }
    });
})
</script>

<#macro showUnavailableVarients>
  <#if unavailableVariants?exists>
    <ul>
      <#list unavailableVariants as prod>
        <#assign features = prod.getRelated("ProductFeatureAppl", null, null, false)/>
        <li>
          <#list features as feature>
            <em>${feature.getRelatedOne("ProductFeature", false).description}</em><#if feature_has_next>, </#if>
          </#list>
          <span>${uiLabelMap.ProductItemOutOfStock}</span>
        </li>
      </#list>
    </ul>
  </#if>
</#macro>


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
    <#assign productLargeImageUrl = productContentWrapper.get("LARGE_IMAGE_URL")?if_exists />
    <#assign productSmallImageUrl = productContentWrapper.get("SMALL_IMAGE_URL")?if_exists />
    <#assign productOriginalImageUrl = productContentWrapper.get("ORIGINAL_IMAGE_URL")?if_exists />
	<#assign inStock = true />



<div class="single-product">

<!-- START BG SHADOW -->
<div class="bg-shadow">
    <!-- START WRAPPER -->
    <div id="wrapper" class="container group">
    	<div id="primary" class="sidebar-right">
		    <div class="container group">
			    <div class="row">      
        			<!-- START CONTENT -->
	        		<div id="content-shop" class="span9 content group">    
	        			<div itemscope="" itemtype="http://schema.org/Product" id="product-552" class="post-552 product type-product status-publish hentry sale instock">		
							<div class="row">
								<div class="images">
								<!-- YITH Magnifier Template -->
								
								
									<div class="yith_magnifier_zoom_wrap">
										<a id='zoom1' itemprop="image" href="${productOriginalImageUrl}" title="${productContentWrapper.get("PRODUCT_NAME")?if_exists}" class="yith_magnifier_zoom" rel="thumbnails" style="display:block; min-width:466px; min-height:392px; border:1px solid #ccc">
											<img id="product-img" src="${productOriginalImageUrl}" class="yit-image attachment-shop_single" style="border:none">
										</a>
										<div class="yith_magnifier_mousetrap" style="width: 100%; height: 100%; top: 0px; left: 0px; cursor: auto;"></div>
									</div>
									<#if price.listPrice?exists && price.price?exists && price.price?double < price.listPrice?double>
										<img src="/bazar/images/icons/sale.png" alt="On sale!" class="onsale yit-image" width="71" height="68">
									</#if>
									
									<div class="thumbnails">
										<div id="slider-prev"></div>
										<div id="slider-next"></div>
									</div>
								</div>

								<script type="text/javascript" charset="utf-8">
								var yith_magnifier_options = {
									enableSlider: true,
								
										sliderOptions: {
										responsive: false,
										//items: ,
										circular: true,
										infinite: true,
										direction: 'left',  
										debug: false,
										auto: false,
										align: 'left',
										prev	: {	
								    		button	: "#slider-prev",
								    		key		: "left"
								    	},
								    	next	: { 
								    		button	: "#slider-next",
								    		key		: "right"
								    	},
								    	//width   : 470,
									    scroll : {
									    	items     : 1,
									    	pauseOnHover: true
									    } 
									},
										
									showTitle: false,	
									zoomWidth: 'auto',
									zoomHeight: 'auto',
									position: 'right',
									tint: false,
									tintOpacity: 0.5,
									lensOpacity: 0.5,
									softFocus: false,
									smoothMove: 3,
									adjustY: 0,
									disableRightClick: false,
									phoneBehavior: 'inside',
									loadingLabel: 'Loading...'
								};
								</script>
							
	    						<div class="summary entry-summary">
									<h1 itemprop="name" class="product_title entry-title">${productContentWrapper.get("PRODUCT_NAME")?if_exists}</h1>
									<div class="border borderstrong"></div>
									<div class="border"></div>
									<div class="border"></div>
									<div class="border"></div>
									<div itemprop="description" class="product-description">
										<#if product.isVirtual?if_exists?upper_case == "Y">
							            	<span>${uiLabelMap.ProductProductId}:</span>
								            <div id="product_id_display" style="display:inline">
								            </div>
							            <#else>
							            	<span>${uiLabelMap.ProductProductId}:</span>${product.productId?if_exists}<br>
							            </#if> 
							            <#if inStock>
								            <#if product.requireAmount?default("N") == "Y">
								              <#assign hiddenStyle = "visible">
								            <#else>
								              <#assign hiddenStyle = "hidden">
								            </#if> 
							            	<div style="display:${hiddenStyle}"><span>${uiLabelMap.BigshopAvailability}:</span> ${uiLabelMap.BigshopInStock}</div>
							            <#else>
							            	<#if product.requireAmount?default("N") == "Y">
								              <#assign hiddenStyle = "visible">
								            <#else>
								              <#assign hiddenStyle = "hidden">
								            </#if> 
							            	<div style="display:${hiddenStyle}"><span>${uiLabelMap.BigshopAvailability}:</span> ${uiLabelMap.BigshopOutStock}</div>
							        	</#if>
									</div>
									
									<script type="text/javascript">var switchTo5x=true;</script>
									<script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
									<script type="text/javascript">stLight.options({publisher:"9c5a1d2e-f6e5-40dd-a371-30228258f8ea"});</script>
									<div class="product_meta">
										<span class="posted_in">
										</span>
									</div>    
	    						</div><!-- .summary -->
							</div>
						</div><!-- #product-552 -->
					</div>           
	    	    	<!-- START SIDEBAR -->
	    			<div id="sidebar-product-single" class="span3 sidebar group">
						<div class="product-box group">
	    					<div class="border group">
								<div itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
									<p itemprop="price" class="price" id="price">
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
								                <#assign priceStyle = "price-tag" />
								              <#else>
								                <#assign priceStyle = "regularPrice" />
								              </#if>
								                ${uiLabelMap.OrderYourPrice}: <div id="variant_price_display" style="display:inline;"><#if "Y" = product.isVirtual?if_exists> ${uiLabelMap.CommonFrom} </#if><span class="${priceStyle}"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed /></span></div>
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
										<!-- <del><span class="amount">$22</span></del> 
										<ins><span class="amount">$19</span></ins>	 -->	
									</p>
									<link itemprop="availability" href="http://schema.org/InStock">
								</div>
							
								
								
								<form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="addform"  style="margin: 0;">
									<#if requestAttributes.paramMap?has_content>
							          <input type="hidden" name="itemComment" value="${requestAttributes.paramMap.itemComment?if_exists}" />
							          <input type="hidden" name="shipBeforeDate" value="${requestAttributes.paramMap.shipBeforeDate?if_exists}" />
							          <input type="hidden" name="shipAfterDate" value="${requestAttributes.paramMap.shipAfterDate?if_exists}" />
							          <input type="hidden" name="itemDesiredDeliveryDate" value="${requestAttributes.paramMap.itemDesiredDeliveryDate?if_exists}" />
							      </#if>      
							      <#-- Variant Selection -->
							      <#assign stylevariant = 'none' />
							      <#if product.isVirtual?if_exists?upper_case == "Y">
							      	<#assign stylevariant = 'block' />
							      </#if>
							      <div class="options" style="width:98.5%;display:${stylevariant}">
							          	<h2>${uiLabelMap.BigshopAvaiableOption}</h2>
							          	<br />
							          	<div id="option-226" class="option">
						                    <span class="required" style="display:inline;color:red;">*</span>
						                    <b>${uiLabelMap.BigshopSelect}:</b><br>
						        
							          	<#if product.isVirtual?if_exists?upper_case == "Y">
							          		<#if product.virtualVariantMethodEnum?if_exists == "VV_FEATURETREE" && featureLists?has_content>
							          			test
								                <#list featureLists as featureList>
								                    <#list featureList as feature>
								                        <#if feature_index == 0>
								                            <div>${feature.description}: <select id="FT${feature.productFeatureTypeId}" name="FT${feature.productFeatureTypeId}" onchange="javascript:checkRadioButton();">
								                            <option value="select" selected="selected">${uiLabelMap.EcommerceSelectOption}</option>
								                        <#else>
								                            <option value="${feature.productFeatureId}">${feature.description} <#if feature.price?exists>(+ <@ofbizCurrency amount=feature.price?string isoCode=feature.currencyUomId />)</#if></option>
								                        </#if>
								                    </#list>
								                    </select>
								                    </div>
								                </#list>
							                  	<input type="hidden" name="add_product_id" value="${product.productId}" />
								                <div id="addCart1" style="display:none;">
								                  <span style="white-space: nowrap;"><strong>${uiLabelMap.CommonQuantity}:</strong></span>&nbsp;
								                  <input type="text" size="5" name="quantity" value="1" />
								                  <a href="javascript:javascript:addItem();" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
								                  &nbsp;
								                </div>
								                <div id="addCart2" style="display:block;">
								                  <span style="white-space: nowrap;"><strong>${uiLabelMap.CommonQuantity}:</strong></span>&nbsp;
								                  <input type="text" size="5" value="1" disabled="disabled" />
								                  <a href="javascript:showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonPleaseSelectAllFeaturesFirst}");" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
								                  &nbsp;
								                </div>
							                
											</#if>
							              	<#if !product.virtualVariantMethodEnum?exists || product.virtualVariantMethodEnum == "VV_VARIANTTREE">
							               		<#if variantTree?exists && (variantTree.size() &gt; 0)>
									                <#list featureSet as currentType>
									                  <div>
									                    <select <#if currentType_index != 0> class="marginleft3 margin10" <#else> class="margin10" </#if> name="FT${currentType}" onchange="javascript:getList(this.name, (this.selectedIndex-1), 1);">
									                      <option>${featureTypes.get(currentType)}</option>
									                    </select>
									                  </div>
									                </#list>
									                <span id="product_uom"></span>
									                <input type="hidden" name="product_id" value="${product.productId}"/>
									                <input type="hidden" name="add_product_id" value="NULL"/>
									                <div>
									                  <strong><span id="product_id_display"> </span></strong>
									                  <strong><div id="variant_price_display_2" style="display:none;"> </div></strong>
									                </div>
												<#else>
									                <input type="hidden" name="product_id" value="${product.productId}"/>
									            	<input type="hidden" name="add_product_id" value="NULL"/>
									            	<div><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
									                <#assign inStock = false />
							              		</#if>
							             	</#if>
						          		<#else>
							              	<input type="hidden" name="add_product_id" value="${product.productId}" />
							              	<#if mainProducts?has_content>
								                <input type="hidden" name="product_id" value=""/>
								                <select name="productVariantId" onchange="javascript:displayProductVirtualVariantId(this.value);">
								                    <option value="">Select Unit Of Measure</option>
								                    <#list mainProducts as mainProduct>
								                        <option value="${mainProduct.productId}">${mainProduct.uomDesc} : ${mainProduct.piecesIncluded}</option>
								                    </#list>
								                </select><br/>
								                <div>
								                  <strong><span id="product_id_display"> </span></strong>
								                  <strong><div id="variant_price_display"> </div></strong>
								                </div>
							              	</#if>
											<#if (availableInventory?exists) && (availableInventory <= 0)>
												<#assign inStock = false />
											</#if>
						            	</#if> 
							            </div>
						            </div>
							      	
							      	
							      	
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
						                <#if product.productTypeId?if_exists == "ASSET_USAGE" || product.productTypeId?if_exists == "ASSET_USAGE_OUT_IN">
						                  <div>
						                    <label>Start Date(yyyy-mm-dd)</label><@htmlTemplate.renderDateTimeField event="" action="" name="reservStart" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="${startDate}" size="25" maxlength="30" id="reservStart1" dateType="date" shortDateInput=true timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
						                  </div>
						                  <div>
						                    Number of days<input type="text" size="4" name="reservLength" value=""/>
						                    Number of persons<input type="text" size="4" name="reservPersons" value="2"/>
						                    Number of rooms<input type="text" size="5" name="quantity" value="1"/>
						                  </div>
						                  <a href="javascript:addItem()" class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
						                <#else>
						                	<div>
							                  <div class="qty" style="margin-bottom:15px;">
							                      	<label>${uiLabelMap.CommonQuantity}:</label>
							                      	
							                      	<div class="quantity buttons_added" style="float:left">
														<input type="button" value="-" class="minus">
														<input type="number" name="quantity" step="1" id="qty" min="1" max="" size="2" title="Qty" class="input-text qty text" maxlength="2" value="1" <#if product.isVirtual!?upper_case == "Y">disabled="disabled"</#if>>
														<input type="button" value="+" class="plus">
													</div>
													<input type="button" style="float:right; height:30px" id="addToCart" value="${uiLabelMap.OrderAddToCart}" id="addToCart" class="button single_add_to_cart_button alt" onclick="javascript:addItem();">
							                      	<div class="clear"></div>
							                  </div>
							                  
						                    </div>
						                  <@showUnavailableVarients/>
						                </#if>
						                <#else>
						                  <#if productStore?exists>
						                    <#if productStore.requireInventory?exists && productStore.requireInventory == "N">
						                      <div class="qty" style="margin-bottom:15px;">
						                      		<label>${uiLabelMap.CommonQuantity}:</label>
							                      	
							                      	<div class="quantity buttons_added" style="float:left">
														<input type="button" value="-" class="minus">
														<input type="number" name="quantity" step="1" id="qty" min="1" max="" size="2" title="Qty" class="input-text qty text" maxlength="2" value="1" <#if product.isVirtual!?upper_case == "Y">disabled="disabled"</#if>>
														<input type="button" value="+" class="plus">
													</div>
						                      	
						                      		<a href="javascript:addItem()" style="float:right; height:20px" id="addToCart" name="addToCart" class="button single_add_to_cart_button alt">${uiLabelMap.OrderAddToCart}</a>
						                      		<div class="clear"></div>
						                      </div>
						                      
						                      <@showUnavailableVarients/>
						                    <#else>
						                      <span><input name="quantity" id="quantity" value="1" size="4" maxLength="4" type="text" disabled="disabled" /></span><a href="javascript:void(0);" disabled="disabled" class="buttontext">${uiLabelMap.OrderAddToCart}</a><br />
						                      <span>${uiLabelMap.ProductItemOutOfStock}<#if product.inventoryMessage?exists>&mdash; ${product.inventoryMessage}</#if></span>
						                    </#if>
						                  </#if>
						              </#if>
						            </#if>
						            <#if variantPriceList?exists>
						              <#list variantPriceList as vpricing>
						                <#assign variantName = vpricing.get("variantName")?if_exists>
						                <#assign secondVariantName = vpricing.get("secondVariantName")?if_exists>
						                <#assign minimumQuantity = vpricing.get("minimumQuantity")>
						                <#if minimumQuantity &gt; 0>
						                  <div>minimum order quantity for ${secondVariantName!} ${variantName!} is ${minimumQuantity!}</div>
						                </#if>
						              </#list>
						            <#elseif minimumQuantity?exists && minimumQuantity?has_content && minimumQuantity &gt; 0>
						               <div>minimum order quantity for ${productContentWrapper.get("PRODUCT_NAME")?if_exists} is ${minimumQuantity!}</div>
						            </#if>	
								</form>
								
								
								
								
								
								<div class="border borderstrong"></div>
						        <div class="border"></div>
						        <div class="border"></div>
						        <div class="border"></div>
        
						        <div class="buttons buttons_3 group" style="margin-top:-15px"> 
						          
								<div class="woocommerce compare-button">
						          	  <a href="#" class="compare" onclick="document.getElementById('addToCompare${requestAttributes.listIndex?if_exists}form').submit();">
						          	  	${uiLabelMap.BigshopAddCompare}
						          	  </a>
							          <form method="post" action="<@ofbizUrl secure="${request.isSecure()?string}">addToCompare</@ofbizUrl>" id="addToCompare${requestAttributes.listIndex?if_exists}form" name="addToCompare${requestAttributes.listIndex?if_exists}form">
							          	<input type="hidden" name="productId" value="${product.productId}"/>
							          	<input type="hidden" name="mainSubmitted" value="Y"/>	          	
							      	  </form>
						      	</div>
								<a href="#" class="woo_compare_button_go hide" style="display: none;"></a>
								<a href="#" class="yit_share share">Share</a>
							</div> <!-- END OPTIONS -->
						</div>
					</div>




					<div class="product-share">
						<div class="socials"><h2>Share on: </h2>
						<div class="socials-default-small facebook-small default">
							<a href="https://www.facebook.com/sharer.php?u=http://dev.olbius.com/bazastore/products/CLOTHINGS_PROMOTIONS/p_${product.productId}" class="socials-default-small default facebook" target="_blank">facebook</a>
						</div>
						<div class="socials-default-small twitter-small default">
							<a href="https://twitter.com/share?url=http://dev.olbius.com/bazastore/products/CLOTHINGS_PROMOTIONS/p_${product.productId}" class="socials-default-small default twitter" target="_blank">twitter</a>
						</div>
						<div class="socials-default-small google-small default">
							<a href="https://plusone.google.com/_/+1/confirm?hl=en&amp;url=http://dev.olbius.com/bazastore/products/CLOTHINGS_PROMOTIONS/p_${product.productId}" class="socials-default-small default google" target="_blank">google</a>
						</div>
						<div class="socials-default-small pinterest-small default">
							<a href="http://pinterest.com/pin/create/button/?url=http://dev.olbius.com/bazastore/products/CLOTHINGS_PROMOTIONS/p_${product.productId}" class="socials-default-small default pinterest" target="_blank">pinterest</a>
						</div>
					</div>
				
				</div>

				<#include "slideright.ftl">
			</div>
			<!-- END SIDEBAR -->




			<div class="product-extra span9">
				<div class="woocommerce-tabs">
					<ul class="tabs">
						<li class="description_tab active">
							<a href="#tab-description">${uiLabelMap.BigShopEcommerceDescription}</a>
						</li>
						<li class="info_tab"><a href="#tab-info">${uiLabelMap.OrderCustomerReviews}</a></li>
						<li class="reviews_tab"><a href="#tab-reviews">${uiLabelMap.BigshopProductMakeReview}</a></li>
					</ul>
					<div class="panel entry-content" id="tab-description" style="display: block;">
						<p>${productContentWrapper.get("LONG_DESCRIPTION")?if_exists}</p>
				        <h3 style="display:none;">Features:</h3>
				        <p style="display:none;">Unrivaled display performance</p>
				        <ul style="display:none;">
				          <li> 30-inch (viewable) active-matrix liquid crystal display provides breathtaking image quality and vivid, richly saturated color.</li>
				          <li> Support for 2560-by-1600 pixel resolution for display of high definition still and video imagery.</li>
				          <li> Wide-format design for simultaneous display of two full pages of text and graphics.</li>
				          <li> Industry standard DVI connector for direct attachment to Mac- and Windows-based desktops and notebooks</li>
				          <li> Incredibly wide (170 degree) horizontal and vertical viewing angle for maximum visibility and color performance.</li>
				          <li> Lightning-fast pixel response for full-motion digital video playback.</li>
				          <li> Support for 16.7 million saturated colors, for use in all graphics-intensive applications.</li>
				        </ul>
					</div>

					<div class="panel entry-content" id="tab-info" style="display: none;">
						<#-- Product Reviews -->
					          <#if productReviews?has_content>
					          	<div id="review">
						            <#list productReviews as productReview>
						              <#assign postedUserLogin = productReview.getRelatedOne("UserLogin", false) />
						              <#assign postedPerson = postedUserLogin.getRelatedOne("Person", false)?if_exists />
										<div class="review-list">
											<div class="author" style="font-family:Tahoma">
												<b><#if productReview.postedAnonymous?default("N") == "Y"> ${uiLabelMap.OrderAnonymous}<#else> ${postedPerson.firstName} ${postedPerson.lastName}</#if></b>
												${uiLabelMap.CommonAt}: ${productReview.postedDateTime?if_exists}
											</div>
											<div class="rating">
												<#if (productReview.productRating?if_exists?double < 0.5)>
													<img src="/bazar/images/basic/stars-0.png" alt="1 reviews">
												</#if>
												<#if ((productReview.productRating?if_exists?double >= 0.5) && (productReview.productRating?if_exists?double < 1.5))>
													<img src="/bazar/images/basic/stars-1.png" alt="1 reviews">
												</#if>
												<#if ((productReview.productRating?if_exists?double >= 1.5) && (productReview.productRating?if_exists?double < 2.5))>
													<img src="/bazar/images/basic/stars-2.png" alt="1 reviews">
												</#if>
												<#if ((productReview.productRating?if_exists?double >= 2.5) && (productReview.productRating?if_exists?double < 3.5))>
													<img src="/bazar/images/basic/stars-3.png" alt="1 reviews">
												</#if>
												<#if ((productReview.productRating?if_exists?double >= 3.5) && (productReview.productRating?if_exists?double < 4.5))>
													<img src="/bazar/images/basic/stars-4.png" alt="1 reviews">
												</#if>
												<#if (productReview.productRating?if_exists?double >= 4.5)>
													<img src="/bigshop/images/stars-5.png" alt="1 reviews">
												</#if>
											</div><!--end review-header-->
						
											<div class="text">
												<p>${productReview.productReview?if_exists}</p>
											</div><!--end review-body-->
										</div><!--end single-review-->
						            </#list>
					            </div>
					          <#else>
					            <div>${uiLabelMap.ProductProductNotReviewedYet}.</div>
					            <div>
					            	<script type="text/javascript">
					            		function triggerreview(){
					            			var l = $('#mrv').click();
					            		}
					            	</script>
					                <a onclick="triggerreview();">${uiLabelMap.ProductBeTheFirstToReviewThisProduct}</a> 
					            </div>
					      	</#if>		

					</div>
					
					
					<div class="panel entry-content" id="tab-reviews" style="display: none;">
						<div id="reviews">
							<div id="tab-makereview" class="tab-content" style="display: block;">
						  		${uiLabelMap.BigshopReview}
						  	</div>
						  	<#if sessionAttributes.userLogin?has_content && sessionAttributes.userLogin.userLoginId != "anonymous">
								<form id="reviewProduct" method="post" action="<@ofbizUrl>createProductReview</@ofbizUrl>" >
							      <input type="hidden" name="productStoreId" value="${productStore.productStoreId}" />
							      <input type="hidden" name="productId" value="${product.productId}" />
							      <input type="hidden" name="product_id" value="${product.productId}" />
							      <input type="hidden" name="category_id" value="${categoryId?if_exists}" />
									<h2 id="review-title">Write a review</h2><br>
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
									      <textarea name="productReview" id="productReview" placeholder="${uiLabelMap.CommonReview}..."  cols="40" rows="8" style="width: 98%;"></textarea>
									    </div>
									</div>
									<div class="control-group">
									    <div class="controls" id="review">
									    	<b>${uiLabelMap.EcommerceRating}*:</b> <span>Bad</span>&nbsp;
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
									        &nbsp;<span>Good</span><br>
									    </div>
									</div>
									<div class="control-group">
									    <div class="controls">
											<input type="button" value="${uiLabelMap.CommonSave}" id="savereview" class="button" onclick="javascript:document.getElementById('reviewProduct').submit();">
									    </div>
									</div>
								</form><!--end form-->
					          <#else>
								<a style="display:block; margin-top:10px; width:50px; height:20px;" href="<@ofbizUrl>checkLogin/product?product_id=${product.productId}</@ofbizUrl>" class="button">${uiLabelMap.CommonBeLogged}</a>          
					          </#if>
						</div>
					</div>
					
					<#if variantTree?exists && 0 < variantTree.size()>
				        <script language="JavaScript" type="text/javascript">eval("list" + "${featureOrderFirst}" + "()");</script>
				    </#if>
					
					<!-- Related Products Start -->
				    <#-- Upgrades/Up-Sell/Cross-Sell -->
				    <#macro associated assocProducts beforeName showName afterName formNamePrefix targetRequestName>
					      <#assign pageProduct = product />
					      <#assign targetRequest = "product" />
					      ${setRequestAttribute("ismain", "Y")}
					      <#if targetRequestName?has_content>
					        	<#assign targetRequest = targetRequestName />
					      </#if>
					      <#if assocProducts?has_content>
					        	<h2>${beforeName?if_exists}<#if showName == "Y">${productContentWrapper.get("PRODUCT_NAME")?if_exists}</#if>${afterName?if_exists}</h2>
					    		
					        	<div class="yit-wcan-container">
					        		<ul class="products">
					        			<#assign productNo = 0>
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
								            <li class="product group grid with-hover with-border <#if productNo%4 == 0>first</#if> span3 css3 open-on-mobile">
					            				${screens.render(productsummaryScreen)}
				            				</li>
								            <#assign product = pageProduct />
								            <#local listIndex = listIndex + 1 />
								            <#assign productNo = productNo + 1>
					        			</#list>
				        			</ul>
					        	</div>
					    
						        ${setRequestAttribute("optProductId", "")}
						        ${setRequestAttribute("formNamePrefix", "")}
						        ${setRequestAttribute("targetRequestName", "")}
					      </#if>
				    </#macro>
				    
				    <#assign productValue = product />
				    <#assign listIndex = 1 />
				    ${setRequestAttribute("productValue", productValue)}
				    <div class="yit-wcan-container">
						<div class="related products">
					        <#-- also bought -->
					        <@associated assocProducts=alsoBoughtProducts beforeName="" showName="N" afterName="${uiLabelMap.BigshopProductAlsoBought}" formNamePrefix="albt" targetRequestName="" />
					        <#-- obsolete -->
					        <@associated assocProducts=obsoleteProducts beforeName="" showName="Y" afterName=" ${uiLabelMap.ProductObsolete}" formNamePrefix="obs" targetRequestName="" />
					        <#-- cross sell -->
					        <@associated assocProducts=crossSellProducts beforeName="" showName="N" afterName="${uiLabelMap.ProductCrossSell}" formNamePrefix="cssl" targetRequestName="crosssell" />
					        <#-- up sell -->
					        <@associated assocProducts=upSellProducts beforeName="${uiLabelMap.ProductUpSell} " showName="Y" afterName=":" formNamePrefix="upsl" targetRequestName="upsell" />
					        <#-- obsolescence -->
					        <@associated assocProducts=obsolenscenseProducts beforeName="" showName="Y" afterName=" ${uiLabelMap.ProductObsolescense}" formNamePrefix="obce" targetRequestName="" />
					   	</div>
					</div>
				    
				    <#-- special cross/up-sell area using commonFeatureResultIds (from common feature product search) -->
				    <#if comsmonFeatureResultIds?has_content>
					    <div class="box">
					        <h2>${uiLabelMap.ProductSimilarProducts}</h2>
					        <div class="box-content">
					        	<div class="box-product">
					            <#list commonFeatureResultIds as commonFeatureResultId>
					                ${setRequestAttribute("optProductId", commonFeatureResultId)}
					                ${setRequestAttribute("listIndex", commonFeatureResultId_index)}
					                ${setRequestAttribute("formNamePrefix", "cfeatcssl")}
					                <#-- ${setRequestAttribute("targetRequestName", targetRequestName)} -->
					                ${screens.render(productsummaryScreen)}
					            </#list>
					            </div>
					        </div>
					    </div>
				    </#if>

				</div>
			</div>
		</div>
	</div>


</div>

</div>
<!-- END WRAPPER -->


</div>
<!-- END BG SHADOW -->


<script type="text/javascript"
	src="/bazar/js/hover/jquery.custom.js"></script>
<script type="text/javascript"
	src="/bazar/js/hover/jq-cookie.js"></script>
<script type="text/javascript">
/* <![CDATA[ */
var yith_woocompare = {"nonceadd":"08ffed7c1c",
						"nonceremove":"b77f2f1832",
						"nonceview":"903a944fbe",
						"ajaxurl":"http:\/\/demo.yithemes.com\/bazar\/wp-admin\/admin-ajax.php",
						"actionadd":"yith-woocompare-add-product",
						"actionremove":"yith-woocompare-remove-product",
						"actionview":"yith-woocompare-view-table",
						"added_label":"Added",
						"table_title":"Product Comparison",
						"auto_open":"yes"};
/* ]]> */
</script>


<script type="text/javascript" src="/bazar/js/plugins/yith-woocommerce-compare/woocompare.js"></script>
<script type="text/javascript" src="/bazar/js/plugins/yith-woocommerce-compare/jquery.colorbox-min.js"></script>
<script type="text/javascript" src="/bazar/js/hover/responsive.js"></script>
<script type="text/javascript" src="/bazar/js/plugins/yith_magnifier/carouFredSel.js"></script>
<script type="text/javascript" src="/bazar/js/plugins/yith_magnifier/yith_magnifier.js"></script>
<script type="text/javascript" src="/bazar/js/plugins/yith_magnifier/frontend.js"></script>
<script type="text/javascript">
/* <![CDATA[ */
var yith_wcwl_l10n = {"out_of_stock":"Cannot add to the cart as product is Out of Stock!"};
/* ]]> */
</script>







<script type="text/javascript" src="/bazar/js/plugins/yith_wishlist/jquery.yith-wcwl.js"></script>
<script type="text/javascript" src="/bazar/js/hover/twitter-text.js"></script>
<script type="text/javascript" src="/bazar/js/hover/jquery.cycle.min.js"></script>
<script type="text/javascript" src="/bazar/js/hover/shortcodes.js"></script>
<script type="text/javascript" src="/bazar/js/hover/widgets.js"></script>
<script type="text/javascript" src="/bazar/js/hover/woocommerce.js"></script>
<script type="text/javascript" src="/bazar/js/frontend/add-to-cart.min.js"></script>
<script type="text/javascript" src="/bazar/js/prettyPhoto/jquery.prettyPhoto.min.js"></script>
<script type="text/javascript" src="/bazar/js/prettyPhoto/jquery.prettyPhoto.init.min.js"></script>
<script type="text/javascript" src="/bazar/js/frontend/single-product.min.js"></script>
<script type="text/javascript" src="/bazar/js/jquery-blockui/jquery.blockUI.min.js"></script>









<!-- START GOOGLE ANALYTICS by Plugin -->
<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement( o ),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	
	  ga('create', 'UA-36516261-31', 'yithemes.com');
	  ga('send', 'pageview');

</script>
<!-- END GOOGLE ANALYTICS by Plugin -->



<!-- END BODY -->


