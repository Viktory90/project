<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcombobox.js"></script>
<script>
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "DELI_ENTRY_STATUS"), null, null, null, false) />
	var statusDataDE = new Array();
	<#list statuses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description)>
		row['statusId'] = '${item.statusId}';
		row['description'] = '${item.description}';
		statusDataDE[${item_index}] = row;
	</#list>
	
//	<#assign parties = delegator.findList("PartyPersonPartyRole", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("roleTypeId", "CARRIER"), null, null, null, false) />
//	var partyData = new Array();
//	<#list parties as item>
//		<#assign isEmpl = delegator.findOne("PartyRole", {"partyId" : item.partyId, "roleTypeId" : "EMPLOYEE"}, false)!>
//		<#if isEmpl?exists>
//			var row = {};
//			row['partyId'] = '${item.partyId?if_exists}';
//			row['partyName'] = '${item.firstName?if_exists} ${item.middleName?if_exists} ${item.lastName?if_exists} [${item.partyId?if_exists}]';
//			partyData[${item_index}] = row;
//		</#if>	
//	</#list>
	
	<#assign facis = delegator.findList("Facility", null, null, null, null, false)>
	var faciData = new Array();
	<#list facis as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.facilityId?if_exists}';
		row['description'] = '${description?if_exists}';
		faciData[${item_index}] = row;
	</#list>
	
//	<#assign vehicles = delegator.findList("Vehicle", null, null, null, null, false)>
//	var vehicleData = new Array();
//	<#list vehicles as item>
//		var row = {};
//		<#assign description = StringUtil.wrapString(item.vehicleName?if_exists)/>
//		row['vehicleId'] = '${item.vehicleId?if_exists}';
//		row['description'] = '${description?if_exists}';
//		vehicleData[${item_index}] = row;
//	</#list>
	
	<#assign uoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "WEIGHT_MEASURE"), null, null, null, false)>
	var uomData = new Array();
	<#list uoms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['weightUomId'] = '${item.uomId?if_exists}';
		row['description'] = '${description?if_exists}';
		row['abbreviation'] = '${item.abbreviation?if_exists}';
		uomData[${item_index}] = row;
	</#list>
</script>
<#assign dataField="[{ name: 'deliveryEntryId', type: 'string' },
					 { name: 'description', type: 'string'},
					 { name: 'fromDate', type: 'date'},
					 { name: 'thruDate', type: 'date'},
					 { name: 'weight', type: 'number'},
					 { name: 'facilityId', type: 'string'},
					 { name: 'weightUomId', type: 'string'},
					 { name: 'statusId', type: 'string'}
					 ]"/>
<#assign columnlist="{ text: '${uiLabelMap.deliveryEntryId}', datafield: 'deliveryEntryId', width: 200, editable: false,
						cellsrenderer: function(row, column, value){
							var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							return '<span><a href=/delys/control/deliveryEntryDetail?deliveryEntryId=' + value + '&facilityId='+data.facilityId+'&fromDate='+data.fromDate.getTime()+'>' + value + '</a></span>'
						}
					 },
					 { text: '${uiLabelMap.FacilityFrom}', datafield: 'facilityId', width: 200, editable: false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>';
								 }
							 }
						 }
					 },
					 { text: '${uiLabelMap.weight}', datafield: 'weight', width: 200, editable: false,  
						cellsrenderer: function(row, colum, value){
						   	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
						   	var weightUomId = data.weightUomId;
						   	var weightUomIdAbb = '';
						   	for(var i = 0; i < uomData.length; i++){
								 if(uomData[i].weightUomId == weightUomId){
									 weightUomIdAbb = uomData[i].abbreviation;
								 }
							 }
					        return '<span>' + value +' (' + weightUomIdAbb +  ')</span>';
			        	}
					 },
					 { text: '${uiLabelMap.statusId}', datafield: 'statusId', width: 200, editable: true, columntype: 'dropdownlist',
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < statusDataDE.length; i++){
								 if(statusDataDE[i].statusId == value){
									 return '<span title=' + value + '>' + statusDataDE[i].description + '</span>';
								 }
							 }
							 return value;
						 },
						 cellbeginedit: function (row, datafield, columntype) {
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								if(data.statusId == 'DELI_ENTRY_COMPLETED' || data.statusId == 'DELI_ENTRY_DELIVERED' || data.statusId == 'DELI_ENTRY_CANCELED'){
									tmpEditable = true;
									return false;
								}else{
									tmpEditable = false;
									return true;
								}
						 },
						 createeditor: function(row, cellvalue, editor){
							 var statusList = new Array();
							 switch (cellvalue) {
								case 'DELI_ENTRY_CREATED':
									 var row = {};
									 row['statusId'] = 'DELI_ENTRY_SCHEDULED';
									 row['description'] = 'Scheduled';
									 statusList[0] = row;
									 
									 var row = {};
									 row['statusId'] = 'DELI_ENTRY_CANCELED';
									 row['description'] = 'Canceled';
									 statusList[1] = row;
									 break;
								case 'DELI_ENTRY_SCHEDULED':
									var row = {};
									 row['statusId'] = 'DELI_ENTRY_SHIPED';
									 row['description'] = 'shiped';
									 statusList[0] = row;
									 break;
								case 'DELI_ENTRY_SHIPED':
									 var row = {};
									 row['statusId'] = 'DELI_ENTRY_DELIVERED';
									 row['description'] = 'Delivered';
									 statusList[0] = row;
									 break;
								default:
									break;
								}
							 
							 editor.jqxDropDownList({source: statusList, valueMember: 'statusId', valueMember: 'statusId',
								 renderer: function (index, label, value){
									 for(var i = 0; i < statusDataDE.length; i++){
										 if(value == statusDataDE[i].statusId){
											 return statusDataDE[i].description;
										 }
									 }
									 return value;
							 	}
							 });
						 }
					 },
					 { text: '${uiLabelMap.description}', datafield: 'description', width: 200, editable: false},
					 { text: '${uiLabelMap.fromDate}', datafield: 'fromDate', width: 200, cellsformat:'dd/MM/yyyy', editable: false},
					 { text: '${uiLabelMap.thruDate}', datafield: 'thruDate', minwidth: 200, cellsformat:'dd/MM/yyyy', editable: false},
					 "/>
<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist sortable="true" sortdirection="desc" defaultSortColumn="fromDate" clearfilteringbutton="true" showtoolbar="true" addrow="true" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true"
		 url="jqxGeneralServicer?sname=JQListDeliveryEntry" addrefresh="true" editrefresh="true" 
		 updateUrl="jqxGeneralServicer?sname=updateDeliveryEntry&jqaction=U" editColumns="deliveryEntryId;statusId"
		 createUrl="jqxGeneralServicer?sname=createDeliveryEntry&jqaction=C"
		 addColumns="description;fromDate(java.sql.Timestamp);facilityId;weightUomId;listShipments(java.util.List);"
		/>
					
<div id="alterpopupWindow" style="display:none;">
	<div>${uiLabelMap.accCreateNew}</div>
	<div style="overflow: hidden;">
	    <table>
	    	<tr style="margin-left: 40px">
	    		<td colspan="4">
	    			<h4 class="row header smaller lighter blue" style="width: 900px;">
	    			${uiLabelMap.DeliveryEntry}
	    			</h4>
    			</td>
			</tr>
		    <tr style="margin-left: 40px">
		 		<td align="right">${uiLabelMap.FacilityFrom}:</td>
				<td align="left">
					<div id="facilityId">
					</div>
				</td>
		 		<td align="right">${uiLabelMap.WeightUomId}:</td>
				<td align="left">
					<div id="weightUomId">
					</div>
				</td>
		 	</tr>
		 	<tr style="margin-left: 40px">	
			 	<td align="right">${uiLabelMap.EstimatedShipDate}:</td>
	 			<td align="left">
	 				<div id="fromDate">
	 				</div>
	 			</td>
				<td align="right">
					${uiLabelMap.description}
				</td>
				<td align="left">
					<input id="description"></input>
				</td>
		 	</tr>
		 	<tr>
			    <td colspan="4" style="max-width: 1000px;">
					<div style="margin-left: 50px"><#include "listShipmentFilter.ftl" /></div>
				</td>
		    </tr>
	        <tr style="margin-left: 40px; margin-top: -20px">
	            <td align="right"></td>
	            <td align="right"></td>
	            <td align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
	            <td align="right"></td>
	        </tr>
	    </table>
	</div>
</div>
<script>
	//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	//Create description
	$("#description").jqxInput({width: 195, theme: theme});
	
	//Create fromDate
	$("#fromDate").jqxDateTimeInput({width: 200, theme: theme});
	
	//Create facilityId
	$("#facilityId").jqxDropDownList({width: 200, selectedIndex: 0, theme: theme, source: faciData, valueMember:'facilityId', displayMember:'description'});
	
	//Create Vehicle 
//	$("#vehicleId").jqxDropDownList({width: 200, selectedIndex: 0, theme: theme, source: vehicleData, valueMember:'vehicleId', displayMember:'description'});
	
	//Create party carrier
//	$("#partyId").jqxComboBox({ source: partyData, selectedIndex: 0, width: '200', height: '25', displayMember: 'partyName', valueMember:'partyId'});
	$("#weightUomId").jqxDropDownList({width: 200, selectedIndex: 0, theme: theme, source: uomData, valueMember:'weightUomId', displayMember:'description'});
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
	$("#facilityId").on('change', function(event){
		var tmpS = $("#filterGrid").jqxGrid('source');
	 	var curFacilityId = $("#facilityId").val();
	 	var curFromDate = $("#fromDate").jqxDateTimeInput('getDate').getTime();
	 	tmpS._source.url = "jqxGeneralServicer?sname=JQGetListFilterShipment&deliveryEntryId=${parameters.deliveryEntryId?if_exists}&facilityId="+curFacilityId+"&fromDate="+curFromDate;
	 	$("#filterGrid").jqxGrid('source', tmpS);
	});
	$("#fromDate").on('change', function(event){
		var tmpS = $("#filterGrid").jqxGrid('source');
	 	var curFacilityId = $("#facilityId").val();
	 	var curFromDate = $("#fromDate").jqxDateTimeInput('getDate').getTime();
	 	tmpS._source.url = "jqxGeneralServicer?sname=JQGetListFilterShipment&deliveryEntryId=${parameters.deliveryEntryId?if_exists}&facilityId="+curFacilityId+"&fromDate="+curFromDate;
	 	$("#filterGrid").jqxGrid('source', tmpS);
	});
	$("#alterCancel").jqxButton();
	$("#alterSave").jqxButton();
	//add row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
    	var row;
    	var selectedIndexs = $('#filterGrid').jqxGrid('getselectedrowindexes');
		var listShipments = new Array();
		for(var i = 0; i < selectedIndexs.length; i++){
			var data = $('#filterGrid').jqxGrid('getrowdata', selectedIndexs[i]);
			var map = {};
			map['shipmentId'] = data.shipmentId;
			listShipments[i] = map;
		}
		listShipments = JSON.stringify(listShipments);
        row = { 
        		description:$('#description').val(),
        		weightUomId:$('#weightUomId').val(),
        		facilityId:$('#facilityId').val(),
        		fromDate: new Date($('#fromDate').jqxDateTimeInput('getDate')),
        		listShipments:listShipments
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
        // select the first row and clear the selection.
	   	$("#jqxgrid").jqxGrid("updatebounddata");
        $("#alterpopupWindow").jqxWindow('close');
    });
</script>