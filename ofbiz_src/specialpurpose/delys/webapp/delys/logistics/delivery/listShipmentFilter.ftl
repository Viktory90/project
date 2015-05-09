<script>
	<#assign shipmentTypes = delegator.findList("ShipmentType", null, null, null, null, false) />
	var shipmentTypeData = new Array();
	<#list shipmentTypes as item>
		var row = {};
		row['shipmentTypeId'] = '${item.shipmentTypeId}';
		row['description'] = '${item.description}';
		shipmentTypeData[${item_index}] = row;
	</#list>
	
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["SHIPMENT_STATUS","PURCH_SHIP_STATUS"]), null, null, null, false) />
	var statusData = new Array();
	<#list statuses as item>
		var row = {};
		row['statusId'] = '${item.statusId}';
		row['description'] = '${item.description}';
		statusData[${item_index}] = row;
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
	<#assign postalAddress = delegator.findList("FacilityContactMechDetail", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("contactMechPurposeTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["SHIP_ORIG_LOCATION","SHIPPING_LOCATION"]), null, null, null, false) />
	var postalAddressData = new Array();
	<#list postalAddress as item>
		var row = {};
		row['contactMechId'] = '${item.contactMechId}';
		row['description'] = '${item.address1}';
		postalAddressData[${item_index}] = row;
	</#list>
	<#assign facis = delegator.findList("Facility", null, null, null, null, false)>
	var faciData = new Array();
	<#list facis as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.facilityId?if_exists}';
		row['description'] = '${description?if_exists}';
		faciData[${item_index}] = row;
	</#list>
	//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	//Create popup window
	$("#alterpopupWindow").jqxWindow({maxWidth: '1000px',width: '1000px', minHeight: '550px', resizable: true,  isModal: true, autoOpen: false, cancelButton:$('#alterCancel'), modalOpacity: 0.7});
</script>
<h4 class="row header smaller lighter blue" style="width: 900px;">
	${uiLabelMap.ShipmenElement}
</h4>
<#assign dataFieldShipment="[{ name: 'shipmentId', type: 'string'},
	{ name: 'shipmentTypeId', type: 'string'},
	{ name: 'statusId', type: 'string'},
	{ name: 'primaryOrderId', type: 'string'},
	{ name: 'primaryTransferId', type: 'string'},
	{ name: 'estimatedReadyDate', type: 'date', other: 'Timestamp'},
	{ name: 'estimatedShipDate', type: 'date', other: 'Timestamp'},
	{ name: 'estimatedArrivalDate', type: 'date', other: 'Timestamp'},
	{ name: 'estimatedShipCost', type: 'number'},
	{ name: 'currencyUomId', type: 'string'},
	{ name: 'originFacilityId', type: 'string'},
	{ name: 'originContactMechId', type: 'string'},
	{ name: 'destinationFacilityId', type: 'string'},
	{ name: 'destinationContactMechId', type: 'string'},
	{ name: 'totalWeight', type: 'number'},
	{ name: 'defaultWeightUomId', type: 'string'},
	]"/>
<#assign columnlistAlter="{ text: '${uiLabelMap.ShipmentId}', datafield: 'shipmentId', width: 110, editable: false, 
								cellsrenderer: function(row, colum, value){
						        	var data = $('#filterGrid').jqxGrid('getrowdata', row);
						        	var shipmentId = data.shipmentId;
						        	var shipmentTypeId = data.shipmentTypeId;
						        	var link = 'editShipmentInfo?shipmentId=' + shipmentId +'&shipmentTypeId=' + shipmentTypeId;
						        	return '<span><a href=\"' + link + '\">' + shipmentId + '</a></span>';
						   		}
							},
						    { text: '${uiLabelMap.ShipmentType}', datafield: 'shipmentTypeId', minwidth: 150, editable: false,
						        cellsrenderer:function(row, colum, value){
						        	for(var i = 0; i < shipmentTypeData.length; i++){
										if(shipmentTypeData[i].shipmentTypeId == value){
											return '<span title=' + value + '>' + shipmentTypeData[i].description + '</span>'
										}
									}
					        	}
					        },
						    { text: '${uiLabelMap.Status}', datafield: 'statusId', minwidth: 150, editable: false,
						       cellsrenderer: function(row, colum, value){
						    	   for(var i = 0; i < statusData.length; i++){
										if(statusData[i].statusId == value){
											return '<span title=' + value + '>' + statusData[i].description + '</span>'
										}
									}
					        	}
					        },
					        { text: '${uiLabelMap.FacilityTo}',  datafield: 'destinationFacilityId', width: 160, editable: false, cellsrenderer:
						       	function(row, colum, value){
								   	for(var i = 0; i < faciData.length; i++){
									   	if(faciData[i].facilityId == value){
									   		return '<span title=' + value + '>' + faciData[i].description + '</span>';
									 	}
								   	}
					        	}
						   },
						   { text: '${uiLabelMap.OriginContactMech}',  datafield: 'originContactMechId', width: 160, editable: true, cellsrenderer:
						       function(row, colum, value){
								   for(var i = 0; i < postalAddressData.length; i++){
									   	if(postalAddressData[i].contactMechId == value){
									   		return '<span title=' + value + '>' + postalAddressData[i].description + '</span>';
									 	}
								   	}
						   		}
						   },
						   { text: '${uiLabelMap.DestinationContactMech}', sortable:false, datafield: 'destinationContactMechId', width: 160, editable: false, cellsrenderer:
						       	function(row, colum, value){
								   for(var i = 0; i < postalAddressData.length; i++){
									   	if(postalAddressData[i].contactMechId == value){
									   		return '<span title=' + value + '>' + postalAddressData[i].description + '</span>';
									 	}
								   	}
						   		}
						   },
						   { text: '${uiLabelMap.ShipmentTotalWeight}', sortable:false,  datafield: 'totalWeight', width: 180, editable: false, cellsrenderer:
						       	function(row, colum, value){
								   	var data = $('#filterGrid').jqxGrid('getrowdata', row);
							        var totalWeight = data.totalWeight;
					 			    var weightUomId = data.defaultWeightUomId;
					 			    var weightUomAbb = '';
					 			    for(var i = 0; i < weightUomData.length; i++){
										 if(weightUomId == weightUomData[i].uomId){
											 weightUomAbb = weightUomData[i].description;
										 }
									 }
					 			    return '<span>' + totalWeight +' (' + weightUomAbb +  ')</span>';
						   		}
						   },
						   { text: '${uiLabelMap.FormFieldTitle_estimatedReadyDate}',  datafield: 'estimatedReadyDate', width: 160, editable: true, cellsformat: 'dd/MM/yyyy - hh:mm:ss'},
						   { text: '${uiLabelMap.FormFieldTitle_estimatedShipDate}',  datafield: 'estimatedShipDate', width: 160, editable: true, cellsformat: 'dd/MM/yyyy - hh:mm:ss'},
						   { text: '${uiLabelMap.EstimatedArrivalDate}',  datafield: 'estimatedArrivalDate', width: 160, editable: true, cellsformat: 'dd/MM/yyyy - hh:mm:ss'},
						   { text: '${uiLabelMap.EstimatedShipCost}',  datafield: 'estimatedShipCost', minwidth: 180, editable: true},
						   "/>
<@jqGrid filtersimplemode="false" viewSize="5" selectionmode="checkbox" id="filterGrid" width="900" bindresize="false" addType="popup" dataField=dataFieldShipment columnlist=columnlistAlter clearfilteringbutton="false" addrow="false"
		 showtoolbar="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" customLoadFunction="true"
		 url="jqxGeneralServicer?sname=JQGetListFilterShipment&deliveryEntryId=&facilityId=&fromDate="
		 otherParams="totalWeight:S-getTotalShipmentItem(shipmentId)<totalWeight>"
/>