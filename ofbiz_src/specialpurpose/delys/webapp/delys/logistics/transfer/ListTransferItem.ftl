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
	<#assign itemTypes = delegator.findList("TransferItemType", null, null, null, null, false) >
	var transferItemTypeData = new Array();
	<#list itemTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['transferItemTypeId'] = '${item.transferItemTypeId?if_exists}';
		row['description'] = '${description}';
		transferItemTypeData[${item_index}] = row;
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
<h4 class="row header smaller lighter blue">
	${uiLabelMap.DeliveryItemList}
</h4>
<#assign dataField1="[{ name: 'transferId', type: 'string' },
					{ name: 'transferItemSeqId', type: 'string' },
					{ name: 'transferItemTypeId', type: 'string' },
					{ name: 'productId', type: 'string' },
					{ name: 'productName', type: 'string' },
					{ name: 'quantity', type: 'string' },
					{ name: 'quantityToDelivery', type: 'string' },
					{ name: 'quantityUomId', type: 'string' },
					{ name: 'expireDate', type: 'date', other: 'Timestamp' },
		 		 	]"/>
<#assign columnlist1="{ text: '${uiLabelMap.TransferItemType}', dataField: 'transferItemTypeId', width: 150, editable: false,
		 				cellsrenderer: function(row, column, value){
							for(var i = 0; i < transferItemTypeData.length; i++){
								if(transferItemTypeData[i].transferItemTypeId == value){
									return '<span title=' + value + '>' + transferItemTypeData[i].description + '</span>'
								}
							}
							return value;
						}
		 			 },
					{ text: '${uiLabelMap.ProductProductId}', dataField: 'productId', width: 150, filtertype:'input', editable: false},
					 { text: '${uiLabelMap.ProductName}', dataField: 'productName', width: 150, filtertype:'input', editable: false, 
						cellsrenderer: function(row, column, value){
							var data = $('#jqxgridProduct').jqxGrid('getrowdata', row);
							for(var i = 0; i < productData.length; i++){
								if(productData[i].productId == data.productId){
									return '<span title=' + value + '>' + productData[i].description + '</span>'
								}
							}
							return value;
						}	
					 },
					 { text: '${uiLabelMap.QuantityNeedToTransfer}', dataField: 'quantity', width: 150, editable: false,
						 cellsrenderer: function(row, column, value){
							var data = $('#jqxgridProduct').jqxGrid('getrowdata', row);
			 			    var quantityUomId = data.quantityUomId;
			 			    var descriptionUom = quantityUomId;
			 			    for(var i = 0; i < uomData.length; i++){
								 if(quantityUomId == uomData[i].quantityUomId){
									 descriptionUom = uomData[i].description;
								 }
							 }
			 			    return '<span>' + value +' (' + descriptionUom +  ')</span>';
						}
					 },
					 { text: '${uiLabelMap.QuantityToTransfer}', dataField: 'quantityToDelivery', width: 100, align: 'center', cellsalign: 'right', columntype: 'numberinput', editable: true,
						 validation: function (cell, value) {
	                    	 var data = $('#jqxgridProduct').jqxGrid('getrowdata', cell.row);
	                    	 if (value <= 0) {
	                             return { result: false, message: '${uiLabelMap.QuantityMustBeGreateThanZero}'};
	                         }
	                         if (value > data.quantity){
	                        	 return { result: false, message: '${uiLabelMap.QuantityCantNotGreateThanQuantityNeedTransfer}'};
	                         }
	                         return true;
	                     },
	                     createeditor: function (row, cellvalue, editor) {
	                         editor.jqxNumberInput({ decimalDigits: 0, digits: 10});
	                     }
					 },
					 { text: '${uiLabelMap.ExpireDate}', dataField: 'expireDate', minwidth: 150, cellsformat: 'd', filtertype: 'range'},
					 "/>
<@jqGrid filtersimplemode="true" width="850" selectionmode="checkbox" id="jqxgridProduct" usecurrencyfunction="true" addType="popup" dataField=dataField1 columnlist=columnlist1 clearfilteringbutton="true" showtoolbar="false" addrow="true" filterable="true" editmode="dblclick" editable="true" 
		url="jqxGeneralServicer?sname=getListTransferItemDelivery&transferId=${parameters.transferId}" bindresize="false" pagesizeoptions="['5', '10', '15']" viewSize="5"	 
	/>