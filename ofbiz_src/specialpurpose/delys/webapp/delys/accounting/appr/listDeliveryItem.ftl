<script>
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "DELIVERY_ITEM_STATUS"), null, null, null, false)>
	var itemStatusData = new Array();
	<#list statuses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description) />
		row['statusId'] = '${item.statusId}';
		row['description'] = '${description}';
		itemStatusData[${item_index}] = row;
	</#list>
	
	<#assign uoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "PRODUCT_PACKING"), null, null, null, false)>
	var quantityUomData = new Array();
	<#list uoms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description) />
		row['uomId'] = '${item.uomId}';
		row['description'] = '${description}';
		quantityUomData[${item_index}] = row;
	</#list>
	//Create Window
	$("#popupDeliveryDetailWindow").jqxWindow({
		maxWidth: 1500, minWidth: 950, minHeight: 500, maxHeight: 1200, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});
	$('#popupDeliveryDetailWindow').on('close', function (event) { 
		if($("#jqxgrid").is('*[class^="jqx"]')){
			$("#jqxgrid").jqxGrid('updatebounddata');
		}
		if($("#jqxgridDlv").is('*[class^="jqx"]')){
			$("#jqxgridDlv").jqxGrid('updatebounddata');
		}
	}); 
</script>
<h4 class="row header smaller lighter blue">
	${uiLabelMap.DeliveryItemList}
</h4>
<#assign dataField2="[{ name: 'deliveryId', type: 'string' },
                 	{ name: 'deliveryItemSeqId', type: 'string' },
                 	{ name: 'productId', type: 'string' },
                 	{ name: 'quantityUomId', type: 'string' },
                 	{ name: 'comment', type: 'string' },
                 	{ name: 'actualExportedQuantity', type: 'number' },
                 	{ name: 'actualDeliveredQuantity', type: 'number' },
                 	{ name: 'statusId', type: 'string' },
                 	{ name: 'quantity', type: 'number' },
					{ name: 'expireDate', type: 'date', other: 'Timestamp' },
                 	{ name: 'deliveryStatusId', type: 'string'}
		 		 	]"/>
<#assign columnlist2="{ text: '${uiLabelMap.deliveryItemSeqId}', dataField: 'deliveryItemSeqId', width: 100, editable: false},
						{ text: '${uiLabelMap.ProductProductId}', dataField: 'productId', width: 150, editable: false},
						{ text: '${uiLabelMap.quantity}', dataField: 'quantity', width: 150, editable: false,
							cellsrenderer: function(row, column, value){
								var data = $('#jqxgrid2').jqxGrid('getrowdata', row);
								var descriptionUom = data.quantityUomId;
								for(var i = 0; i < quantityUomData.length; i++){
									if(data.quantityUomId == quantityUomData[i].uomId){
										descriptionUom = quantityUomData[i].description;
								 	}
								}
								return '<span>' + value +' (' + descriptionUom +  ')</span>';
							 }
						},
						{ text: '${uiLabelMap.ExpireDate}', dataField: 'expireDate', width: 150, cellsformat: 'd', filtertype: 'range'},
					 	"/>
<#if security.hasPermission("DELIVERY_ITEM_UPDATE", userLogin)>
	<#assign columnlist2 = columnlist2 + "{ text: '${uiLabelMap.actualExportedQuantity}', dataField: 'actualExportedQuantity', width: 150, editable: true,
											cellbeginedit: function (row, datafield, columntype) {
												var data = $('#jqxgrid2').jqxGrid('getrowdata', row);
												if(data.deliveryStatusId == 'DLV_CREATED'){
													tmpEditable = false;
													return true;
												}else{
													tmpEditable = true;
													return false;
												}
										    }
										  },
										 { text: '${uiLabelMap.actualDeliveredQuantity}', dataField: 'actualDeliveredQuantity', width: 150, editable: true,
											cellbeginedit: function (row, datafield, columntype) {
												var data = $('#jqxgrid2').jqxGrid('getrowdata', row);
												if(data.deliveryStatusId == 'DLV_EXPORTED'){
													tmpEditable = false;
													return true;
												}else{
													tmpEditable = true;
													return false;
												}
											 } 
										 },"/>
<#else>
	<#assign columnlist2 =columnlist2 + "{ text: '${uiLabelMap.actualExportedQuantity}', dataField: 'actualExportedQuantity', width: 150, editable: false}," +
										"{ text: '${uiLabelMap.actualDeliveredQuantity}', dataField: 'actualDeliveredQuantity', width: 150, editable: false},"/>
</#if>					 
					 
<#assign columnlist2 = columnlist2 + "
					 { text: '${uiLabelMap.statusId}', dataField: 'statusId', width: 150, editable: false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < itemStatusData.length; i++){
								 if(value == itemStatusData[i].statusId){
									 return '<span title=' + value + '>' + itemStatusData[i].description + '</span>';
								 }
							 }
						 }
					 	},
					 	{ text: '${uiLabelMap.comments}', dataField: 'comments', width: 150, editable: false},
					 "/>
<@jqGrid filtersimplemode="true" width="850" id="jqxgrid2" usecurrencyfunction="true" addType="popup" dataField=dataField2 columnlist=columnlist2 clearfilteringbutton="true" showtoolbar="false" addrow="true" filterable="true" editmode="dblclick" editable="true" 
		url="jqxGeneralServicer?sname=getListDeliveryItem" bindresize="false" editrefresh="true" functionAfterUpdate="functionAfterUpdate()"  customLoadFunction="false"
		updateUrl="jqxGeneralServicer?sname=updateDeliveryItem&jqaction=U" editColumns="deliveryId;deliveryItemSeqId;actualExportedQuantity(java.math.BigDecimal);actualDeliveredQuantity(java.math.BigDecimal)" otherParams="productId,quantityUomId,expireDate:S-getDeliveryItemDetail(deliveryId,deliveryItemSeqId)<productId,quantityUomId,expireDate>"
	/>
