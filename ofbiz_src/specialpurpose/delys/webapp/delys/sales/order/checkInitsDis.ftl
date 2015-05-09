<script language="JavaScript" type="text/javascript">
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
	<#--function toggleAll() {
	    var cform = document.cartform;
	    var len = cform.elements.length;
	    for (var i = 0; i < len; i++) {
	        var e = cform.elements[i];
	        if (e.name == "selectedItem") {
	            toggle(e);
	        }
	    }
	}-->
	function removeSelected() {
	    var cform = document.cartform;
	    cform.removeSelected.value = true;
	    cform.submit();
	}
	<#--
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
	        showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.OrderSelectedGiftNotAvailableForAll}");
	    }
	    cform.submit();
	}
	function quicklookup_popup(element) {
	    target = element;  // note: global var target comes from fieldlookup.js
	    var searchTerm = element.value;
	    var obj_lookupwindow = window.open('LookupProduct?productId_op=like&amp;productId_ic=Y&amp;productId=' + searchTerm,'FieldLookup', 'width=700,height=550,scrollbars=yes,status=no,resizable=yes,top='+my+',left='+mx+',dependent=yes,alwaysRaised=yes');
	    obj_lookupwindow.opener = window;
	    obj_lookupwindow.focus();
	}
	function quicklookup(element) {
	    <#if shoppingCart.getOrderType() == "PURCHASE_ORDER">
	    window.location='<@ofbizUrl>LookupBulkAddSupplierProducts</@ofbizUrl>?productId='+element.value;
	    <#else>
	    window.location='<@ofbizUrl>LookupBulkAddProducts</@ofbizUrl>?productId='+element.value;
	    </#if>
	}
	-->
</script>
<form class="form-horizontal basic-custom-form form-size-mini" id="initOrderEntry" name="initOrderEntry" method="post" action="<@ofbizUrl>initSalesOrderEntryDis</@ofbizUrl>" style="display: block;">
	<input type="hidden" name="salesChannelEnumId" value="WEB_SALES_CHANNEL"/>
	<input type="hidden" name="originOrderId" value="${parameters.originOrderId?if_exists}"/>
  	<input type="hidden" name="finalizeMode" value="type"/>
  	<input type="hidden" name="orderMode" value="SALES_ORDER"/>
  	<input type="hidden" name="CURRENT_CATALOG_ID" value="${currentCatalogId?if_exists}"/>
  	<input type="hidden" name="catalogId" value="${currentCatalogId?if_exists}"/>
  	<#--
  	<input type="hidden" name="shipBeforeDate" value=""/>
  	<input type="hidden" name="shipAfterDate" value=""/>
  	-->
	<div class="row-fluid">
		<div class="span6">
			<div class="control-group">
				<label class="control-label" for="orderId">${uiLabelMap.DAOrderId}</label>
				<div class="controls">
					<div class="span12">
						<input type="text" name="orderId" id="orderId" class="span12 input-small" maxlength="20" value="${parameters.orderId?if_exists}">
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="orderName">${uiLabelMap.DAOrderName}</label>
				<div class="controls">
					<div class="span12">
						<input type="text" name="orderName" id="orderName" class="span12" maxlength="100" value="${parameters.orderName?if_exists}">
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="productStoreId">${uiLabelMap.DAProductStore}</label>
				<div class="controls">
					<div class="span12">
						<#--
						<#if sessionAttributes.orderMode?exists>
							<input type="hidden" name="productStoreId" value="${currentStoreId?if_exists}"/>
						</#if>
						<select name="productStoreId" id="productStoreId" class="span12 input-small" <#if sessionAttributes.orderMode?exists> disabled</#if>>
			                <#list productStores as productStore>
		                  		<option value="${productStore.productStoreId}"<#if productStore.productStoreId == currentStoreId> selected="selected"</#if>>${productStore.storeName?if_exists}</option>
		                	</#list>
						</select>
						<#if sessionAttributes.orderMode?exists>
							<span class="help-inline tooltipob">${uiLabelMap.OrderCannotBeChanged}</span>
						</#if>
						-->
						<select name="productStoreId" id="productStoreId" class="span12 input-small">
			                <#list productStores as productStore>
		                  		<option value="${productStore.productStoreId}"<#if currentStoreId?exists && (productStore.productStoreId == currentStoreId)> selected="selected"</#if>>${productStore.storeName?if_exists}</option>
		                	</#list>
						</select>
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="correspondingPoId">${uiLabelMap.DAPONumber}</label>
				<div class="controls">
					<div class="span12">
						<input type="text" name="correspondingPoId" id="correspondingPoId" class="span12 input-small" maxlength="20" value="${parameters.correspondingPoId?if_exists}"/>
					</div>
				</div>
			</div>
		</div><!-- .span6 -->
		<div class="span6">
			<div class="control-group">
				<label class="control-label required" for="currencyUomId">${uiLabelMap.DACurrencyUomId}</label>
				<div class="controls">
					<div class="span12">
						<select name="currencyUomId" id="currencyUomId" class="input-mini chzn-select" data-placeholder="${uiLabelMap.DAChooseACurrency}...">
			              	<#list currencies as currency>
			              		<option value="${currency.uomId}" <#if currencyUomId?default('') == currency.uomId>selected="selected"</#if> />${currency.uomId}
			              	</#list>
			            </select>
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label required" for="partyId">${uiLabelMap.DACustomer}</label>
				<div class="controls">
					<div class="span12">
						<@htmlTemplate.lookupField name="partyId" id="partyId" value='${currentPartyId?if_exists}' width="1150"
							formName="initOrderEntry" fieldFormName="LookupCustomerNameOfDis" title="${uiLabelMap.DALookupCustomer}"/>
					</div>
				</div>
			</div>
	  		<div class="control-group">
				<label class="control-label required" for="desiredDeliveryDate">${uiLabelMap.DADesiredDeliveryDate}</label>
				<div class="controls">
					<div class="span12">
						<@htmlTemplate.renderDateTimeField name="desiredDeliveryDate" id="desiredDeliveryDate" event="" action="" 
							value="${parameters.desiredDeliveryDate?default(nowTimestamp)}" className="" alert="" 
							title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" dateType="date" 
							shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" 
							timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" 
							isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName="" />
					</div>
				</div>
			</div>			
		</div><!-- .span6 -->
	</div><!-- .row-fluid -->
</form>
<br />
<#--<form method="post" action="<@ofbizUrl>modifyCart</@ofbizUrl>" name="cartform" class="form-size-mini">-->
	<#include 'checkInitsDisPartJQ.ftl'/> 
	<#--
	<input type="hidden" name="removeSelected" value="false"/>
	<table cellspacing="0" cellpadding="1" border="0" class="table table-striped dataTable table-hover table-bordered">
		<thead class="align-center">
			<tr>
				<th>${uiLabelMap.DANo}</th>
				<th class="center">${uiLabelMap.DAProductId}</th>
				<th class="center">${uiLabelMap.DAProductName}</th>
				<th class="center">${uiLabelMap.DAExpireDate}</th>
				<th class="center">${uiLabelMap.DAQuantity}</th>
				<th align="center">
		          	<label>
						<input type="checkbox" name="selectAll" value="0" onclick="javascript:toggleAll(this);" />
						<span class="lbl"></span>
					</label>
				</th>
			</tr>
		</thead>
		<tbody>
		<#if productList?exists>
			<#list productList as productItem>
			<tr>
				<td>${productItem_index + 1}</td>
				<td>${productItem.productId}</td>
				<td></td>
				<td>
					<div class="controls">
						
					</div>
				</td>
				<td>
					<div class="controls">
						<input type="text" name="quantity_o_${productItem_index}" class="input-mini input-mask-product"/>
					</div>
				</td>
				<td>
					<input type="checkbox" name="selectedItem" value="" onclick="javascript:checkToggle(this);"/>
					<span class="lbl"></span>
				</td>
			</tr>
			</#list>
		</#if>
		</tbody>
	</table>
	-->
<#--</form>-->

<#--
<form class="form-horizontal basic-custom-form form-size-mini" name="checkoutInfoForm" method="post" action="<@ofbizUrl>checkout</@ofbizUrl>" style="display: block;">
	<div class="row-fluid">
		<div class="span6">
			<div id="leftScreen" class="span12"></div>
		</div>
		<div class="span6">
			<div id="rightScreen" class="span12"></div>
		</div>
	</div>
</form>
-->
<div>
	<div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;" class="jqx-rc-all jqx-rc-all-olbius">
		<div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
			<div style="float: left;">
				<div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
				<span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
			</div>
		</div>
	</div>
	<div id="checkoutInfo">
		<#include "checkoutAjaxDis.ftl"/>
	</div>
</div>
<div style="clear:both"></div>

<script src="/delys/images/js/bootbox.min.js"></script>
<script type="text/javascript">
	$(".chzn-select").chosen({allow_single_deselect:true , no_results_text: "${uiLabelMap.DANoSuchState}"});
</script>