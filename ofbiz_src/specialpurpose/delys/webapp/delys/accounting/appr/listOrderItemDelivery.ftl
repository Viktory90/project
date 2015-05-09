<script>
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	//Create Window
	$("#alterpopupWindow").jqxWindow({
		maxWidth: 1500, minWidth: 950, minHeight: 627, maxHeight: 1200, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});
	//Prepare data for product
	<#assign products = delegator.findList("Product", null, null, null, null, false) >
	var productData = new Array();
	<#list products as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.productName?if_exists) />
		row['productId'] = '${item.productId?if_exists}';
		row['description'] = '${description}';
		productData[${item_index}] = row;
	</#list>
		
	//Prepare data for order item type
	<#assign orderItemTypes = delegator.findList("OrderItemType", null, null, null, null, false) >
	var orderItemTypeData = new Array();
	<#list orderItemTypes as item>
		var row = {};
		row['orderItemTypeId'] = '${item.orderItemTypeId}';
		row['description'] = '${item.description}';
		orderItemTypeData[${item_index}] = row;
	</#list>
	
	<#assign facilities = delegator.findList("Facility", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("facilityTypeId", "WAREHOUSE"), null, null, null, false)>
	var facilityData = new Array();
	<#list facilities as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.uomId?if_exists}';
		row['description'] = '${description?if_exists}';
		facilityData[${item_index}] = row;
	</#list>
	
	<#assign uoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "PRODUCT_PACKING"), null, null, null, false)>
	var uomData = new Array();
	<#list uoms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['quantityUomId'] = '${item.uomId?if_exists}';
		row['description'] = '${description?if_exists}';
		uomData[${item_index}] = row;
	</#list>
</script>
<style type="text/css">
	#statusbarjqxgrid1{
		display:none;
	}
</style>
<#assign dataField1="[{ name: 'orderId', type: 'string' },
                 	{ name: 'orderItemSeqId', type: 'string' },
                 	{ name: 'productId', type: 'string' },
					{ name: 'prodCatalogId', type: 'string' },
					{ name: 'productCategoryId', type: 'string' },
                 	{ name: 'orderItemTypeId', type: 'string' },
                 	{ name: 'resQuantity', type: 'number' },
					{ name: 'quantityUomId', type: 'string'},
                 	{ name: 'facilityId', type: 'string' },
					{ name: 'unitPrice', type: 'number'},
					{ name: 'comments', type: 'string' },
		 		 	]"/>
<#assign columnlist1="{ text: '${uiLabelMap.ProductProductId}', dataField: 'productId', width: 150, filtertype:'input', editable: false, 
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < productData.length; i++){
								if(productData[i].productId == value){
									return '<span title=' + value + '>' + productData[i].description + '</span>'
								}
							}
							return value;
						}	
					 },
		 			 { text: '${uiLabelMap.prodCatalogId}', dataField: 'prodCatalogId', width: 150, editable: false},
		 			 { text: '${uiLabelMap.OrderItemType}', dataField: 'orderItemTypeId', width: 150, editable: false,
		 				cellsrenderer: function(row, column, value){
							for(var i = 0; i < orderItemTypeData.length; i++){
								if(orderItemTypeData[i].orderItemTypeId == value){
									return '<span title=' + value + '>' + orderItemTypeData[i].description + '</span>'
								}
							}
							return value;
						}
		 			 },
					 { text: '${uiLabelMap.quantity}', dataField: 'resQuantity', width: 150, editable: true,
		 				cellsrenderer: function(row, column, value){
		 					var data = $('#jqxgrid1').jqxGrid('getrowdata', row);
		 					var description = value;
		 					for(var i = 0; i < uomData.length; i++){
								 if(uomData[i].quantityUomId == data.quantityUomId){
									 description = uomData[i].description;
								 }
							 }
		 					return '<span title=' + value + '>' + value +' ('+ description + ')</span>'
						}
					 },
					 { text: '${uiLabelMap.facility}', dataField: 'facilityId', width: 150, editable: true,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < facilityData.length; i++){
								 if(facilityData[i].facilityId == value){
									 return '<span title=' + value + '>' + facilityData[i].description + '</span>'
								 }
							 }
						}
					 },
					 { text: '${uiLabelMap.unitPrice} ${uiLabelMap.beforeVAT}', dataField: 'unitPrice', width: 150, editable: false,
						 cellsrenderer: function(row, column, value){
							 var data = $('#jqxgrid1').jqxGrid('getrowdata', row);
							 return '<span>' + formatcurrency(value, data.currencyUomId) + '<span>';
						 }
					 },
					 { text: '${uiLabelMap.comments}', dataField: 'comments', width: 150, editable: false}
					 "/>
<@jqGrid customTitleProperties="DeliveryItemList" filtersimplemode="true" width="890" selectionmode="checkbox" id="jqxgrid1" usecurrencyfunction="true" addType="popup" dataField=dataField1 columnlist=columnlist1 clearfilteringbutton="true" showtoolbar="true" addrow="true" filterable="true" editmode="dblclick" editable="true" 
		url="jqxGeneralServicer?sname=getListOrderItemDelivery&orderId=${parameters.orderId}" bindresize="false" viewSize="5" pagesizeoptions="['5', '10', '15', '20', '25', '30', '50', '100']"	 
	/>