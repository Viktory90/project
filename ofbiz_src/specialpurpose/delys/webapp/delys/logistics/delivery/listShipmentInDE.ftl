<script>
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["SHIPMENT_STATUS", "PURCH_SHIP_STATUS", "DELI_ENTRY_STATUS"]), null, null, null, false) />
	var statusDataArr = new Array();
	<#list statuses as item>
		var row = {};
		row['statusId'] = '${item.statusId}';
		row['description'] = '${item.description}';
		statusDataArr[${item_index}] = row;
	</#list>
	<#assign shipmentTypes = delegator.findList("ShipmentType", null, null, null, null, false) />
	var shipmentTypeData = new Array();
	<#list shipmentTypes as item>
		var row = {};
		row['shipmentTypeId'] = '${item.shipmentTypeId}';
		row['description'] = '${item.description}';
		shipmentTypeData[${item_index}] = row;
	</#list>
	
	<#assign postalAddress = delegator.findList("FacilityContactMechDetail", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("contactMechPurposeTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["SHIP_ORIG_LOCATION","SHIPPING_LOCATION"]), null, null, null, false) />
	var postalAddressData = new Array();
	<#list postalAddress as item>
		var row = {};
		row['contactMechId'] = '${item.contactMechId}';
		row['description'] = '${item.address1}';
		postalAddressData[${item_index}] = row;
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
	
	<#assign deliveryEntry = delegator.findOne("DeliveryEntry", Static["org.ofbiz.base.util.UtilMisc"].toMap("deliveryEntryId", parameters.deliveryEntryId?if_exists), false)/>
	<#assign facility = delegator.findOne("Facility", Static["org.ofbiz.base.util.UtilMisc"].toMap("facilityId", deliveryEntry.facilityId), false)/>
</script>
<div>
<div style="overflow: hidden;">
	<table style="width: 60%">
		<tr style="margin-left: 40px">
			<td colspan="4">
				<h4 class="row header smaller lighter blue" >
				${uiLabelMap.DeliveryEntry}
				</h4>
			</td>
		</tr>
	    <tr style="margin-left: 40px">
	 		<td align="right">${uiLabelMap.FacilityFrom}: </td>
			<td align="left">
				<div id="facilityId" class="green-label">
				</div>
			</td>
	 		<td align="right">${uiLabelMap.weight}: </td>
			<td align="left">
				<div id="weight" class="green-label">
				</div>
			</td>
	 	</tr>
	 	<tr style="margin-left: 40px">	
		 	<td align="right">${uiLabelMap.EstimatedShipDate}: </td>
				<td align="left">
					<div id="fromDate" class="green-label">
					</div>
				</td>
			<td align="right">
				${uiLabelMap.Status}: 
			</td>
			<td align="left">
				<div id="statusId" class="green-label"></div>
			</td>
	 	</tr>
	 	<tr style="margin-left: 40px">	
		 	<td align="right">${uiLabelMap.Description}: </td>
			<td align="left">
				<div id="description" class="green-label">
				</div>
			</td>
	 	</tr>
 	</table>
</div>
<div>
<#assign dataField="[{ name: 'shipmentId', type: 'string'},
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
		   { name: 'destinationFacilityId', type: 'string'},
		   { name: 'originContactMechId', type: 'string'},
			{ name: 'destinationContactMechId', type: 'string'},
		   { name: 'totalWeight', type: 'number'},
		   { name: 'defaultWeightUomId', type: 'string'},
		   ]"/>
		   
<#assign columnlist="{ text: '${uiLabelMap.ShipmentId}', datafield: 'shipmentId', width: 110, editable: false, filtertype:'input', cellsrenderer:
		   function(row, colum, value){
		    var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		    var shipmentId = data.shipmentId;
		    var shipmentTypeId = data.shipmentTypeId;
		    var link = 'editShipmentInfo?shipmentId=' + shipmentId +'&shipmentTypeId=' + shipmentTypeId;
		    return '<span><a href=\"' + link + '\">' + shipmentId + '</a></span>';
		}},
		{ text: '${uiLabelMap.ShipmentType}', datafield: 'shipmentTypeId', minwidth: 150, filtertype:'input', editable: false, cellsrenderer:
		function(row, colum, value){
		    for(var i = 0; i < shipmentTypeData.length; i++){
				if(shipmentTypeData[i].shipmentTypeId == value){
					return '<span title=' + value + '>' + shipmentTypeData[i].description + '</span>'
				}
			}
		}
		},
		{ text: '${uiLabelMap.Status}', dataField: 'statusId', width: 100, align: 'center', filtertype:'input', cellsalign: 'right', editable: false, columntype: 'dropdownlist', filtertype: 'input', 
		cellsrenderer: function(row, column, value){
			for(var i = 0; i < statusDataArr.length; i++){
				if(statusDataArr[i].statusId == value){
					return '<span title=' + value + '>' + statusDataArr[i].description + '</span>'
				}
			}
		},
		},
		{ text: '${uiLabelMap.FacilityTo}',  datafield: 'destinationFacilityId', width: 160, editable: false, filtertype:'input', cellsrenderer:
		function(row, colum, value){
		    var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		    var destinationFacilityId = data.destinationFacilityId;
		    if (destinationFacilityId != null) {
		    	var destinationFacility = getFacility(destinationFacilityId);
		        return '<span>' + destinationFacility + '</span>';
			} else {
				return '';
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
	   { text: '${uiLabelMap.ShipmentTotalWeight}', filterable: false,  datafield: 'totalWeight', width: 180, editable: false, cellsrenderer:
			function(row, colum, value){
		   	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		   	var defaultWeightUomId = data.defaultWeightUomId;
		    var defaultWeightUom = getWeightUnit(defaultWeightUomId);
		    var totalWeight = data.totalWeight;
		    return '<span>' + totalWeight +' (' + defaultWeightUom +  ')</span>';
		}
		},
		{ text: '${uiLabelMap.FormFieldTitle_estimatedReadyDate}', filterable: false, datafield: 'estimatedReadyDate', width: 160, editable: false, cellsformat: 'dd/MM/yyyy',
		},
		{ text: '${uiLabelMap.FormFieldTitle_estimatedShipDate}', filterable: false, datafield: 'estimatedShipDate', width: 160, editable: false, cellsformat: 'dd/MM/yyyy',
		},
		{ text: '${uiLabelMap.EstimatedArrivalDate}', filterable: false,  datafield: 'estimatedArrivalDate', width: 160, editable: false, cellsformat: 'dd/MM/yyyy',
		},
		{ text: '${uiLabelMap.EstimatedShipCost}', filterable: false, datafield: 'estimatedShipCost', minwidth: 180, editable: false, cellsrenderer:
			function(row, colum, value){
				var data = $('#jqxgrid').jqxGrid('getrowdata', row);
				return \"<span>\" + formatcurrency(data.estimatedShipCost, data.currencyUomId) + \"</span>\";
			}
		},
		
	"/>
<#assign deliveryEntry = delegator.findOne("DeliveryEntry", {"deliveryEntryId": parameters.deliveryEntryId?if_exists}, false) />
<#if "DELI_ENTRY_CREATED" == deliveryEntry.statusId >
	<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false" addrow="true"
		showtoolbar="true" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" editmode='click'
		url="jqxGeneralServicer?sname=JQGetListShipmentInDE&deliveryEntryId=${parameters.deliveryEntryId?if_exists}" updateUrl="jqxGeneralServicer?sname=updateProductPrice&jqaction=U"
		createUrl="jqxGeneralServicer?sname=createProductPrice&jqaction=C" otherParams="totalWeight:S-getTotalShipmentItem(shipmentId)<totalWeight>"
		addColumns="shipmentId;shipmentTypeId;statusId;primaryOrderId;estimatedReadyDate(java.sql.Timestamp);estimatedShipDate(java.sql.Timestamp);estimatedArrivalDate(java.sql.Timestamp);estimatedShipCost(java.math.BigDecimal);originFacilityId;destinationFacilityId;originContactMechId;destinationContactMechId;vehicleId;totalWeight(java.math.BigDecimal);defaultWeightUomId"
	/>
<#else>
	<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false" addrow="false"
		showtoolbar="true" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" editmode='click'
		url="jqxGeneralServicer?sname=JQGetListShipmentInDE&deliveryEntryId=${parameters.deliveryEntryId?if_exists}" updateUrl="jqxGeneralServicer?sname=updateProductPrice&jqaction=U"
		createUrl="jqxGeneralServicer?sname=createProductPrice&jqaction=C" otherParams="totalWeight:S-getTotalShipmentItem(shipmentId)<totalWeight>"
		addColumns="shipmentId;shipmentTypeId;statusId;primaryOrderId;estimatedReadyDate(java.sql.Timestamp);estimatedShipDate(java.sql.Timestamp);estimatedArrivalDate(java.sql.Timestamp);estimatedShipCost(java.math.BigDecimal);originFacilityId;destinationFacilityId;originContactMechId;destinationContactMechId;vehicleId;totalWeight(java.math.BigDecimal);defaultWeightUomId"
	/>
</#if>
</div>					     

<div id="alterpopupWindow">
	<div>${uiLabelMap.accCreateNew}</div>
	<div style="overflow: hidden;">
		<input type="hidden" id="facilityId" value="${parameters.facilityId?if_exists}"></input>
		<input type="hidden" id="fromDate" value="${parameters.fromDate?if_exists}"></input>
	    <table>
		 	<tr>	 	
				<td >
					<div style="margin-left: 50px"><#include "listShipmentFilter.ftl" /></div>
				</td>
			</tr>
			<tr>	 	
				<td >
					<td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
				</td>
			</tr>
	    </table>
	</div>
</div>

<script>
	//Create Window popup
	
	//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	$("#facilityId").text('${facility.facilityName}');
	var weightUom;
	for(var i = 0; i < weightUomData.length; i++){
		if(weightUomData[i].uomId == '${deliveryEntry.weightUomId}'){
			weightUom = weightUomData[i].description;
		}
	}
	$("#weight").text('${deliveryEntry.weight?string(",##0")} ('+weightUom+')');
	$("#fromDate").text('${StringUtil.wrapString(Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(deliveryEntry.fromDate, "dd/MM/yyyy", locale, timeZone)!)}');
	for(var i = 0; i < statusDataArr.length; i++){
		if(statusDataArr[i].statusId == '${deliveryEntry.statusId}'){
			$("#statusId").text(statusDataArr[i].description);
		}
	}
	
	//Create Button
	$("#alterSave").jqxButton({theme: theme});
	$("#alterCancel").jqxButton({theme: theme});
	$('#alterpopupWindow').on('open', function (event) {
		initGridfilterGrid();
		var tmpS = $("#filterGrid").jqxGrid('source');
		var curFacilityId = "${parameters.facilityId?if_exists}";
		var curFromDate = "${parameters.fromDate?if_exists}";
		if (curFacilityId == "" || curFacilityId == null){
	 		curFacilityId = $("#facilityId").val();
	 	}
	 	if (curFromDate == "" || curFromDate == null){
	 		curFromDate = $("#fromDate").jqxDateTimeInput('getDate').getTime();
	 	}
	 	tmpS._source.url = "jqxGeneralServicer?sname=JQGetListFilterShipment&deliveryEntryId=${parameters.deliveryEntryId?if_exists}&facilityId="+curFacilityId+"&fromDate="+curFromDate;
	 	$("#filterGrid").jqxGrid('source', tmpS);
	});
	//Handle for alterSave3
	$("#alterCancel").on('click', function(event){
		$("#alterpopupWindow").jqxWindow('close');
	});
	$("#alterSave").on('click', function(event){
		var selectedRow = $('#filterGrid').jqxGrid('getselectedrowindexes');
		var parameters = {};
		for(var i = 0; i < selectedRow.length; i++){
			var dataGrid = $('#filterGrid').jqxGrid('getrowdata', selectedRow[i]);
			parameters['shipmentId_o_' + i] = dataGrid.shipmentId;
			parameters['deliveryEntryId_o_' + i] = '${parameters.deliveryEntryId?if_exists}';
		}
		
		$.ajax({
	        url: "assignShipmentToDE",
	        type: "post",
	        data: parameters,
	        success: function(){
	        	$('#jqxgrid').jqxGrid("updatebounddata");
	        	$("#alterpopupWindow").jqxWindow('close');
	        },
	        error:function(){
	        }
	    });
	});
</script>

<script type="text/javascript">
	<#assign listSMStatus = delegator.findList("StatusItem", null, null, null, null, false) />
	<#assign listWeightUnit = delegator.findList("Uom", null, null, null, null, false) />
	
	<#assign shipmentType = delegator.findList("ShipmentType", null, null, null, null, false) />
	var pptData = new Array();
	<#if shipmentType?exists>
		<#list shipmentType as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description) />
			row['shipmentTypeId'] = '${item.shipmentTypeId?if_exists}';
			row['description'] = "${description}";
			pptData[${item_index}] = row;
		</#list>
	</#if>
	function getShipmentType(shipmentTypeId) {
		for ( var x in pptData) {
			if (shipmentTypeId == pptData[x].shipmentTypeId) {
				return pptData[x].description;
			}
		}
	}
	var listSMStatus = new Array();
	<#if listSMStatus?exists>
		<#list listSMStatus as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description) />
			row['statusId'] = '${item.statusId?if_exists}';
			row['description'] = "${description}";
			listSMStatus[${item_index}] = row;
		</#list>
	</#if>
	function getStatusItem(statusId) {
		for ( var x in listSMStatus) {
			if (statusId == listSMStatus[x].statusId) {
				return listSMStatus[x].description;
			}
		}
	}
	
	var listWeightUnit = new Array();
	<#if listWeightUnit?exists>
		<#list listWeightUnit as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description) />
			row['uomId'] = '${item.uomId?if_exists}';
			row['description'] = "${description}";
			listWeightUnit[${item_index}] = row;
		</#list>
	</#if>
	function getWeightUnit(uomId) {
		for ( var x in listWeightUnit) {
			if (uomId == listWeightUnit[x].uomId) {
				return listWeightUnit[x].description;
			}
		}
	}
	
	<#assign facility = delegator.findList("Facility", null, null, null, null, false) />
	var facility = new Array();
	<#if facility?exists>
		<#list facility as item>
			var row = {};
			<#assign facilityName = StringUtil.wrapString(item.facilityName) />
			row['facilityId'] = '${item.facilityId?if_exists}';
			row['facilityName'] = "${facilityName}";
			facility[${item_index}] = row;
		</#list>
	</#if>
	function getFacility(facilityId) {
		for ( var x in facility) {
			if (facilityId == facility[x].facilityId) {
				return facility[x].facilityName;
			}
		}
	}
	
	function getWeight(id) {
		var thisWeight = 0;
		jQuery.ajax({
	        url: "getTotalShipmentItem",
	        type: "POST",
	        data: {shipmentId: id},
	        success: function(res) {
	        	thisWeight = res["totalWeight"];
	        }
	    }).done(function() {
	    	console.log(thisWeight);
	    	return thisWeight;
		});
		return thisWeight;
	}
</script>