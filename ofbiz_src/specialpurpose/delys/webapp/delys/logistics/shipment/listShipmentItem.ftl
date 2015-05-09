<script>
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	
	<#assign uoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "PRODUCT_PACKING"), null, null, null, false)>
	var quantityUomData = new Array();
	<#list uoms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.abbreviation) />
		row['uomId'] = '${item.uomId}';
		row['description'] = '${description}';
		quantityUomData[${item_index}] = row;
	</#list>
	
	<#assign weightUoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "WEIGHT_MEASURE"), null, null, null, false)>
	var weightUomData = new Array();
	<#list weightUoms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.abbreviation) />
		row['uomId'] = '${item.uomId}';
		row['description'] = '${description}';
		weightUomData[${item_index}] = row;
	</#list>
	//Create Window
	$("#popupShipmentDetailWindow").jqxWindow({
		maxWidth: 1500, minWidth: 950, minHeight: 500, maxHeight: 1200, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});
	$('#popupShipmentDetailWindow').on('open', function (event) {
		initGridjqxgridShipmentItem();
	});
</script>
<h4 class="row header smaller lighter blue">
	${uiLabelMap.ListShipmentItems}
</h4>
<#assign dataField2="[{ name: 'shipmentId', type: 'string' },
                 	{ name: 'shipmentItemSeqId', type: 'string' },
                 	{ name: 'productId', type: 'string' },
                 	{ name: 'internalName', type: 'string' },
                 	{ name: 'quantityUomId', type: 'string' },
                 	{ name: 'quantity', type: 'number' },
                 	{ name: 'weight', type: 'number' },
                 	{ name: 'totalWeight', type: 'number' },
                 	{ name: 'weightUomId', type: 'string' },
                 	
		 		 	]"/>
<#assign columnlist2="{ text: '${uiLabelMap.ShipmentItemSeqId}', dataField: 'shipmentItemSeqId', width: 150, editable: false},
						{ text: '${uiLabelMap.ProductProductId}', dataField: 'productId', width: 150, editable: false},
						{ text: '${uiLabelMap.ProductName}', dataField: 'internalName', width: 150, editable: false},
						{ text: '${uiLabelMap.quantity}', dataField: 'quantity', width: 150, editable: false,
							cellsrenderer: function(row, colum, value){
				 			    var data = $('#jqxgridShipmentItem').jqxGrid('getrowdata', row);
				 			    var quantityUomId = data.quantityUomId;
				 			    var quantityUomAbb = '';
				 			    for(var i = 0; i < quantityUomData.length; i++){
									 if(quantityUomId == quantityUomData[i].uomId){
										 quantityUomAbb = quantityUomData[i].description;
									 }
								 }
				 			    return '<span>' + data.quantity +' (' + quantityUomAbb +  ')</span>';
				 			}
						},
					 	{ text: '${uiLabelMap.weight}', dataField: 'weight', width: 150, editable: false,
					 		cellsrenderer: function(row, colum, value){
				 			    var data = $('#jqxgridShipmentItem').jqxGrid('getrowdata', row);
				 			    var weightUomId = data.weightUomId;
				 			    var weightUomAbb = '';
				 			    for(var i = 0; i < weightUomData.length; i++){
									 if(weightUomId == weightUomData[i].uomId){
										 weightUomAbb = weightUomData[i].description;
									 }
								 }
				 			    return '<span>' + data.weight +' (' + weightUomAbb +  ')</span>';
				 			}
					 	},
					 	{ text: '${uiLabelMap.TotalWeight}', dataField: 'totalWeight', minwidth: 150, editable: false,
					 		cellsrenderer: function(row, colum, value){
				 			    var data = $('#jqxgridShipmentItem').jqxGrid('getrowdata', row);
				 			    var total = (parseFloat(data.weight) * parseFloat(data.quantity)).toFixed(2);
				 			    var weightUomId = data.weightUomId;
				 			    var weightUomAbb = '';
				 			    for(var i = 0; i < weightUomData.length; i++){
									 if(weightUomId == weightUomData[i].uomId){
										 weightUomAbb = weightUomData[i].description;
									 }
								 }
				 			    return '<span>' + total +' (' + weightUomAbb +  ')</span>';
				 			}
					 	},
				 	"/>
<@jqGrid filtersimplemode="true" width="850" id="jqxgridShipmentItem" usecurrencyfunction="true" addType="popup" dataField=dataField2 columnlist=columnlist2 clearfilteringbutton="true" showtoolbar="false" addrow="true" filterable="true" editmode="dblclick" editable="true" 
		url="jqxGeneralServicer?sname=getListShipmentItem&shipmentId=${parameters.shipmentId?if_exists}" bindresize="false" editrefresh="true" functionAfterUpdate=""  customLoadFunction="true"
		updateUrl="" editColumns="shipmentId;shipmentItemSeqId;quantity(java.math.BigDecimal)" otherParams=""
	/>
