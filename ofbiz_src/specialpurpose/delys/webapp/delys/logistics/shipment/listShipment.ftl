<script>
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["SHIPMENT_STATUS","PURCH_SHIP_STATUS"]), null, null, null, false) />
	var statusData = new Array();
	<#list statuses as item>
		var row = {};
		row['statusId'] = '${item.statusId}';
		row['description'] = '${item.description}';
		statusData[${item_index}] = row;
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
</script>
<div id="transfer-list" class="tab-pane">
<#if security.hasPermission("LOGISTICS_ADMIN", userLogin)>
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
						   { name: 'totalWeight', type: 'number'},
						   { name: 'defaultWeightUomId', type: 'string'},
						   { name: 'listStatusIds', type: 'string' },
						   ]"/>
						   
   <#assign columnlist="{ text: '${uiLabelMap.ShipmentId}', datafield: 'shipmentId', width: 110, editable: false, filtertype:'input',
					   cellsrenderer:function(row, colum, value){
							return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
						}
   					},
				   { text: '${uiLabelMap.ShipmentType}', datafield: 'shipmentTypeId', minwidth: 150, filtertype:'input', editable: false, cellsrenderer:
				       function(row, colum, value){
					        for(var i = 0; i < shipmentTypeData.length; i++){
								if(shipmentTypeData[i].shipmentTypeId == value){
									return '<span title=' + value + '>' + shipmentTypeData[i].description + '</span>'
								}
							}
			        	}
					},
			        { text: '${uiLabelMap.Status}', dataField: 'statusId', width: 100, align: 'center', filtertype:'input', cellsalign: 'right', columntype: 'dropdownlist', filtertype: 'input', 
			        	cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						},
			        	initeditor: function (row, cellvalue, editor) {
		                   var newStatusData = new Array();
		                   var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
		                   var statusArray = data['listStatusIds'];
		                   for (var i = 0; i < statusArray.length; i++) {
			                    var statusItemId = statusArray[i];
			                    for (var j = 0; j < statusData.length; j++) {
				                    var itemId = statusData[j];
				                    if (statusData[j].statusId == statusItemId.statusIdTo){
				                    	var row = {};
					                    row['statusId'] = '' + statusItemId.statusIdTo;
					                    row['description'] = '' + itemId.description;
					                    newStatusData[i] = row;
				                    }
			                   }
		                   }
		                   for (var i = 0; i < statusData.length; i++) {
			                    var itemId = statusData[i];
			                    if (statusData[i].statusId == cellvalue){
			                    	var row = {};
				                    row['statusId'] = '' + itemId.statusId;
				                    row['description'] = '' + itemId.description;
				                    newStatusData.unshift(row);
			                    }
		                   }
		                   var sourceStatusData =
		                   {
			                   localdata: newStatusData,
			                   datatype: 'array',
			                   datafields: [
	                                { name: 'description', type: 'string' },
	                                { name: 'statusId', type: 'string' }
	                            ],
		                   };
		                   var dataAdapterStatus = new $.jqx.dataAdapter(sourceStatusData, {
		                	   autoBind: true
		                   });
		                   editor.jqxDropDownList({ selectedIndex: 0, source: dataAdapterStatus, displayMember: 'description', valueMember: 'statusId'
		                   });
					 	},
			        },
			        { text: '${uiLabelMap.FacilityFrom}',  datafield: 'originFacilityId', width: 160, editable: false, filtertype:'input', cellsrenderer:
				       function(row, colum, value){
					        var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
					        var originFacilityId = data.originFacilityId;
					        if (originFacilityId != null) {
					        	var originFacility = getFacility(originFacilityId);
						        return '<span>' + originFacility + '</span>';
							} else {
								return '';
							}
			        	}
			        },
				   { text: '${uiLabelMap.FacilityTo}',  datafield: 'destinationFacilityId', width: 160, editable: false, filtertype:'input', cellsrenderer:
				       function(row, colum, value){
					        var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
					        var destinationFacilityId = data.destinationFacilityId;
					        if (destinationFacilityId != null) {
					        	var destinationFacility = getFacility(destinationFacilityId);
						        return '<span>' + destinationFacility + '</span>';
							} else {
								return '';
							}
				        }
			        },
				   { text: '${uiLabelMap.OrderId}',  datafield: 'primaryOrderId', width: 140, filtertype:'input', editable: false,
			        	cellsrenderer: function(row, column, value){
							if('' == value){
								return '<span title=' + value + '>--</span>'
							} else {
								var link = 'orderView?orderId=' + value;
								return '<span><a href=\"' + link + '\">' + value + '</a></span>';
							}
						},
				   },
				   { text: '${uiLabelMap.TransferId}',  datafield: 'primaryTransferId', width: 140, filtertype:'input', editable: false,
					   cellsrenderer: function(row, column, value){
							if('' == value){
								return '<span title=' + value + '>--</span>'
							} else {
								var link = 'viewTransfer?transferId=' + value;
								return '<span><a href=\"' + link + '\">' + value + '</a></span>';
							}
						},
				   },
				   { text: '${uiLabelMap.FormFieldTitle_estimatedReadyDate}', filterable: false, datafield: 'estimatedReadyDate', columntype: 'datetimeinput', width: 160, editable: true, cellsformat: 'dd/MM/yyyy',
					   cellbeginedit: function (row, datafield, columntype) {
						   	var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
					        var statusId = data.statusId;
					        if ('SHIPMENT_INPUT' != statusId) {
					        	return false;
					        }
					    }
				   },
				   { text: '${uiLabelMap.FormFieldTitle_estimatedShipDate}', filterable: false, datafield: 'estimatedShipDate', columntype: 'datetimeinput', width: 160, editable: true, cellsformat: 'dd/MM/yyyy',
					   cellbeginedit: function (row, datafield, columntype) {
						   	var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
					        var statusId = data.statusId;
					        if ('SHIPMENT_INPUT' != statusId) {
					        	return false;
					        }
					    }
				   },
				   { text: '${uiLabelMap.EstimatedArrivalDate}', filterable: false,  datafield: 'estimatedArrivalDate', columntype: 'datetimeinput', width: 160, editable: true, cellsformat: 'dd/MM/yyyy',
					   cellbeginedit: function (row, datafield, columntype) {
						   	var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
					        var statusId = data.statusId;
					        if ('SHIPMENT_DELIVERED' == statusId) {
					        	return false;
					        }
					    }
				   },
				   { text: '${uiLabelMap.EstimatedShipCost}', filterable: false, datafield: 'estimatedShipCost', width: 180, editable: true, cellsrenderer:
				       	function(row, colum, value){
					   		var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
					   		return \"<span>\" + formatcurrency(data.estimatedShipCost, data.currencyUomId) + \"</span>\";
			        	}
				   },
				   { text: '${uiLabelMap.ShipmentTotalWeight}', filterable: false,  datafield: 'totalWeight', minwidth: 180, editable: false, cellsrenderer:
				       	function(row, colum, value){
						   	var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
						   	var defaultWeightUomId = data.defaultWeightUomId;
					        var defaultWeightUom = getWeightUnit(defaultWeightUomId);
					        var totalWeight = data.totalWeight;
					        return '<span>' + totalWeight +' (' + defaultWeightUom +  ')</span>';
			        	}
				   },
	   			"/>
   <#else>
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
		   { name: 'totalWeight', type: 'number'},
		   { name: 'defaultWeightUomId', type: 'string'},
		   ]"/>
		   
		<#assign columnlist="{ text: '${uiLabelMap.ShipmentId}', datafield: 'shipmentId', width: 110, editable: false, filtertype:'input',
			cellsrenderer:function(row, colum, value){
				return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
			}
		},
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
			for(var i = 0; i < statusData.length; i++){
				if(statusData[i].statusId == value){
					return '<span title=' + value + '>' + statusData[i].description + '</span>'
				}
			}
		},
		},
		{ text: '${uiLabelMap.FacilityFrom}',  datafield: 'originFacilityId', width: 160, editable: false, filtertype:'input', cellsrenderer:
		function(row, colum, value){
		    var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
		    var originFacilityId = data.originFacilityId;
		    if (originFacilityId != null) {
		    	var originFacility = getFacility(originFacilityId);
		        return '<span>' + originFacility + '</span>';
			} else {
				return '';
			}
		}
		},
		{ text: '${uiLabelMap.FacilityTo}',  datafield: 'destinationFacilityId', width: 160, editable: false, filtertype:'input', cellsrenderer:
		function(row, colum, value){
		    var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
		    var destinationFacilityId = data.destinationFacilityId;
		    if (destinationFacilityId != null) {
		    	var destinationFacility = getFacility(destinationFacilityId);
		        return '<span>' + destinationFacility + '</span>';
			} else {
				return '';
			}
		}
		},
		{ text: '${uiLabelMap.OrderId}',  datafield: 'primaryOrderId', width: 140, filtertype:'input', editable: false,
		cellsrenderer: function(row, column, value){
			if('' == value){
				return '<span title=' + value + '>--</span>'
			} else {
				var link = 'orderView?orderId=' + value;
				return '<span><a href=\"' + link + '\">' + value + '</a></span>';
			}
		},
		},
		{ text: '${uiLabelMap.TransferId}',  datafield: 'primaryTransferId', width: 140, filtertype:'input', editable: false,
		cellsrenderer: function(row, column, value){
			if('' == value){
				return '<span title=' + value + '>--</span>'
			} else {
				var link = 'viewTransfer?transferId=' + value;
				return '<span><a href=\"' + link + '\">' + value + '</a></span>';
			}
		},
		},
		{ text: '${uiLabelMap.FormFieldTitle_estimatedReadyDate}', filterable: false, datafield: 'estimatedReadyDate', width: 160, editable: false, cellsformat: 'dd/MM/yyyy',
		},
		{ text: '${uiLabelMap.FormFieldTitle_estimatedShipDate}', filterable: false, datafield: 'estimatedShipDate', width: 160, editable: false, cellsformat: 'dd/MM/yyyy',
		},
		{ text: '${uiLabelMap.EstimatedArrivalDate}', filterable: false,  datafield: 'estimatedArrivalDate', width: 160, editable: false, cellsformat: 'dd/MM/yyyy',
		},
		{ text: '${uiLabelMap.EstimatedShipCost}', filterable: false, datafield: 'estimatedShipCost', minwidth: 180, editable: false, cellsrenderer:
			function(row, colum, value){
				var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
				return \"<span>\" + formatcurrency(data.estimatedShipCost, data.currencyUomId) + \"</span>\";
			}
		},
		{ text: '${uiLabelMap.ShipmentTotalWeight}', filterable: false,  datafield: 'totalWeight', width: 180, editable: false, cellsrenderer:
			function(row, colum, value){
		   	var data = $('#jqxgridShipment').jqxGrid('getrowdata', row);
		   	var defaultWeightUomId = data.defaultWeightUomId;
		    var defaultWeightUom = getWeightUnit(defaultWeightUomId);
		    var totalWeight = data.totalWeight;
		    return '<span>' + totalWeight +' (' + defaultWeightUom +  ')</span>';
		}
		},
		"/>
   </#if>
	<@jqGrid contextMenuId="Menu" viewSize="10" id="jqxgridShipment" filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false" showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true" 
	editmode='click' customcontrol1="icon-plus-sign@${uiLabelMap.CommonCreateNew}@prepareCreateNewShipment"
	url="jqxGeneralServicer?sname=JQGetListShipment&facilityId=${facilityId?if_exists}" updateUrl="jqxGeneralServicer?sname=updateShipment&jqaction=U" editColumns="shipmentId;statusId;estimatedReadyDate(java.sql.Timestamp);estimatedShipDate(java.sql.Timestamp);estimatedArrivalDate(java.sql.Timestamp);estimatedShipCost(java.math.BigDecimal);" createUrl=""
	addColumns="shipmentId;shipmentTypeId;statusId;primaryTransferId;primaryOrderId;estimatedReadyDate(java.sql.Timestamp);estimatedShipDate(java.sql.Timestamp);estimatedArrivalDate(java.sql.Timestamp);estimatedShipCost(java.math.BigDecimal);originFacilityId;destinationFacilityId;originContactMechId;destinationContactMechId;vehicleId;totalWeight(java.math.BigDecimal);defaultWeightUomId"
	otherParams="totalWeight:S-getTotalShipmentItem(shipmentId)<totalWeight>;listStatusIds:S-getStatusValidToChange(statusId)<listStatusIds>;"
	/>
</div>
<div id="popupShipmentDetailWindow" style="display:none;">
	<div>${uiLabelMap.ShipmentInformations}</div>
	<div id="windowContent">
		<table>
		<tr>
			<td align="right">
				${uiLabelMap.FacilityFrom}:
			</td>
			<td align="left">
		       <div id="originFacilityDT" style="width: 200px" class="green-label">
		       </div>
		    </td>
		   
		   	<td align="right">
				${uiLabelMap.FacilityTo}:
			</td>
			<td align="left">
		       <div id="destFacilityDT" style="width: 200px" class="green-label"></div>
		    </td>
		</tr>
		<tr>
			<td align="right">
				${uiLabelMap.OriginContactMech}:
			</td>
			<td align="left">
		       <div id="originContactMechDT" style="width: 200px" class="green-label">
		       </div>
		    </td>
		   
		   	<td align="right">
				${uiLabelMap.DestinationContactMech}:
			</td>
			<td align="left">
		       <div id="destContactMechDT" style="width: 200px" class="green-label"></div>
		    </td>
		</tr>
		</table>
		<div style="margin-left: 50px"><#include "listShipmentItem.ftl" /></div>
	</div>
</div>
<div id="popupShipmentPackage" style="display:none;">
	<div>${uiLabelMap.PackageInfo}</div>
	<div id="windowContent">
		<div style="margin-left: 50px"><#include "listShipmentPackage.ftl" /></div>
	</div>
</div>
<div id="popupShipmentCosts" style="display:none;">
<div>${uiLabelMap.PackageInfo}</div>
<div id="windowContent">
	<div style="margin-left: 50px"><#include "listShipmentCosts.ftl" /></div>
</div>
</div>
<div id='Menu'>
<ul>
	<li id='menuShipmentPackage'>${uiLabelMap.PackageInfo}</li>
	<li id='menuShipmentCost'>${uiLabelMap.TransportCost}</li>
</ul>
</div>
<script type="text/javascript">
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	var alterData = new Object();
	function showDetailPopup(shipmentId){
		var shipmentDT;
		$.ajax({
	           type: "POST",
	           url: "getShipmentById",
	           data: {'shipmentId': shipmentId},
	           dataType: "json",
	           async: false,
	           success: function(response){
	        	   shipmentDT = response.shipment;
	           },
	           error: function(response){
	             alert("Error:" + response);
	           }
	    });
		
		var originFacilityDT;
		for(var i = 0; i < facility.length; i++){
			if(shipmentDT.originFacilityId == facility[i].facilityId){
				originFacilityDT = 	facility[i].facilityName;
				break;
			}
		}
		$("#originFacilityDT").text(originFacilityDT);
		
		var destFacilityDT;
		for(var i = 0; i < facility.length; i++){
			if(shipmentDT.destinationFacilityId == facility[i].facilityId){
				destFacilityDT = facility[i].facilityName;
				break;
			}
		}
		$("#destFacilityDT").text(destFacilityDT);
		
		var originContactMechDT;
		for(var i = 0; i < postalAddressData.length; i++){
			if(shipmentDT.originContactMechId == postalAddressData[i].contactMechId){
				originContactMechDT = postalAddressData[i].description;
				break;
			}
		}
		$("#originContactMechDT").text(originContactMechDT);
		
		var destContactMechDT;
		for(var i = 0; i < postalAddressData.length; i++){
			if(shipmentDT.destinationContactMechId == postalAddressData[i].contactMechId){
				destContactMechDT = postalAddressData[i].description;
				break;
			}
		}
		$("#destContactMechDT").text(destContactMechDT);
		
		$("#shipmentId").val(shipmentId);
		alterData.pagenum = "0";
        alterData.pagesize = "20";
        alterData.noConditionFind = "Y";
        alterData.conditionsFind = "N";
        alterData.shipmentId = shipmentId;
		$("#popupShipmentDetailWindow").jqxWindow('open');
		$("#jqxgridShipmentItem").jqxGrid("updatebounddata");
	}
	var contextMenu = $("#Menu").jqxMenu({ width: 150, height: 58, autoOpenPopup: false, mode: 'popup'});
    $("#jqxgridShipment").on('contextmenu', function () {
        return false;
    });
    // handle context menu clicks.
    $("#Menu").on('itemclick', function (event) {
        var args = event.args;
        var rowindex = $("#jqxgridShipment").jqxGrid('getselectedrowindex');
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.PackageInfo)}") {
            var dataRecord = $("#jqxgridShipment").jqxGrid('getrowdata', rowindex);
            var shipmentId = dataRecord.shipmentId;
            alterData.pagenum = "0";
            alterData.pagesize = "20";
            alterData.noConditionFind = "Y";
            alterData.conditionsFind = "N";
            alterData.shipmentId = shipmentId;
            $("#popupShipmentPackage").jqxWindow('open');
    		$("#jqxgridShipmentPackage").jqxGrid("updatebounddata");
        }
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.TransportCost)}") {
            var dataRecord = $("#jqxgridShipment").jqxGrid('getrowdata', rowindex);
            var shipmentId = dataRecord.shipmentId;
            alterData.pagenum = "0";
            alterData.pagesize = "20";
            alterData.noConditionFind = "Y";
            alterData.conditionsFind = "N";
            alterData.shipmentId = shipmentId;
            $("#popupShipmentCosts").jqxWindow('open');
    		$("#jqxgridShipmentCosts").jqxGrid("updatebounddata");
        }
    });
    $("#jqxgridShipment").on('rowClick', function (event) {
        if (event.args.rightclick) {
        	var dataRecord = $("#jqxgridShipment").jqxGrid('getrowdata', event.args.rowindex);
    		$("#jqxgridShipment").jqxGrid('selectrow', event.args.rowindex);
            var scrollTop = $(window).scrollTop();
            var scrollLeft = $(window).scrollLeft();
            contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
            return false;
        }
    });
    
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
			<#assign description = StringUtil.wrapString(item.abbreviation) />
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
	    	return thisWeight;
		});
		return thisWeight;
	}
</script>