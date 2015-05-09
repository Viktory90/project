<script type="text/javascript" src="/delys/images/js/util/DateUtil.js" ></script>
<script>
	var alterData = new Object();
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "DELIVERY_STATUS"), null, null, null, false) />
	var statusData = new Array();
	<#list statuses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description)>
		row['statusId'] = '${item.statusId}';
		row['description'] = '${item.description}';
		statusData[${item_index}] = row;
	</#list>
	
	<#assign parties = delegator.findList("PartyNameView", null, null, null, null, false) />
	var partyData = new Array();
	<#list parties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + StringUtil.wrapString(item.middleName?if_exists) + StringUtil.wrapString(item.lastName?if_exists) + StringUtil.wrapString(item.groupName?if_exists))>
		row['partyId'] = "${item.partyId}";
		row['description'] = "${description}";
		partyData[${item_index}] = row;
	</#list>
	
	<#assign postalAddresses = delegator.findList("PostalAddress", null, null, null, null, false)>
	var pstAddrData = new Array();
	<#list postalAddresses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.address1)/>
		row['contactMechId'] = '${item.contactMechId}';
		row['description'] = '${description}';
		pstAddrData[${item_index}] = row;
	</#list>
	
	<#assign prodStores = delegator.findList("ProductStore", null, null, null, null, false)>
	var prodStoreData = new Array();
	<#list prodStores as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.storeName?if_exists)/>
		row['productStoreId'] = '${item.productStoreId?if_exists}';
		row['description'] = '${description?if_exists}';
		prodStoreData[${item_index}] = row;
	</#list>
	
	<#assign facis = delegator.findList("Facility", null, null, null, null, false)>
	var faciData = new Array();
	<#list facis as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.facilityId?if_exists}';
		row['ownerPartyId']= '${item.ownerPartyId?if_exists}'
		row['description'] = '${description?if_exists}';
		row['productStoreId'] = '${item.productStoreId?if_exists}';
		faciData[${item_index}] = row;
	</#list>
	
	<#assign deliveryTypes = delegator.findList("DeliveryType", null, null, null, null, false)>
	var deliveryTypeData = new Array();
	<#list deliveryTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['deliveryTypeId'] = '${item.deliveryTypeId?if_exists}';
		row['description'] = '${description?if_exists}';
		deliveryTypeData[${item_index}] = row;
	</#list>
</script>
<div id="deliveries-tab" class="tab-pane">
	<#assign columnlist="{ text: '${uiLabelMap.DeliveryId}', dataField: 'deliveryId', width: 150, filtertype:'input', editable:false, 
					cellsrenderer: function(row, column, value){
						 return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + '> ' + value  + '</a></span>'
					 }
					},
					{ text: '${uiLabelMap.deliveryTypeId}', dataField: 'deliveryTypeId', width: 150, editable:false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < deliveryTypeData.length; i++){
								if(deliveryTypeData[i].deliveryTypeId == value){
									return '<span title=' + value + '>' + deliveryTypeData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 }, 
					{ text: '${uiLabelMap.Status}', dataField: 'statusId', width: 150, editable:false, columntype: 'dropdownlist',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						},
						cellbeginedit: function (row, datafield, columntype) {
							var data = $('#jqxgrid2').jqxGrid('getrowdata', row);
							if(data.deliveryStatusId == 'DLV_CREATED'){
								tmpEditable = false;
								return true;
							}else{
								tmpEditable = true;
								return false;
							}
						},
						createeditor: function(row, value, editor){
							var statusData = new Array();
							var row = {};
							row['statusId'] = 'DLV_APPROVED';
							row['description'] = 'Delivery approved';
							statusData[0] = row;
							
							var row = {};
							row['statusId'] = 'DLV_CANCELED';
							row['description'] = 'Delivery canceled';
							statusData[1] = row;
							
							editor.jqxDropDownList({ source: statusData, displayMember: 'statusId', valueMember: 'statusId',
								renderer: function(index, label, value) {
									for(var i = 0; i < statusData.length; i++){
										if(value == statusData[i].statusId){
											return '<span>' + statusData[i].description + '</span>'
										}
									}
								}
							});
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.Receiver}', dataField: 'partyIdTo', width: 150, editable:false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < partyData.length; i++){
								if(partyData[i].partyId == value){
									return '<span title=' + value + '>' + partyData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.address}', dataField: 'destContactMechId', width: 250, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.partyIdFrom}', dataField: 'partyIdFrom', width: 150, editable:false,
							cellsrenderer: function(row, column, value){
								for(var i = 0; i < partyData.length; i++){
									if(partyData[i].partyId == value){
										return '<span title=' + value + '>' + partyData[i].description + '</span>'
									}
								}
							},
							filtertype: 'input'
						 },
						 { text: '${uiLabelMap.originContactMechId}', dataField: 'originContactMechId', width: 250, editable:false,
							 cellsrenderer: function(row, column, value){
								 for(var i = 0; i < pstAddrData.length; i++){
									 if(pstAddrData[i].contactMechId == value){
										 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
									 }
								 }
							 },
							 filtertype: 'input'
						 },
					 { text: '${uiLabelMap.OrderId}', dataField: 'orderId', width: 150, filtertype: 'input', editable:false},
					 { text: '${uiLabelMap.productStore}',dataField: 'originProductStoreId', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < prodStoreData.length; i++){
								 if(prodStoreData[i].productStoreId == value){
									 return '<span title=' + value + '>' + prodStoreData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.facility}', dataField: 'originFacilityId', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.destFacilityId}', dataField: 'destFacilityId', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.createDate}', dataField: 'createDate', width: 150, cellsformat: 'd', filtertype: 'range', editable:false},
					 { text: '${uiLabelMap.deliveryDate}', dataField: 'deliveryDate', width: 150, cellsformat: 'd', filtertype: 'range', editable:false},
					 { text: '${uiLabelMap.totalAmount}', dataField: 'totalAmount', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 return '<span>' + formatcurrency(value) + '</span>';
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.noNumber}', dataField: 'no', width: 150, filtertype: 'input', editable:false}
					 "/>
	<#assign dataField="[{ name: 'deliveryId', type: 'string' },
					{ name: 'deliveryTypeId', type: 'string' },
					{ name: 'statusId', type: 'string' },
                 	{ name: 'partyIdTo', type: 'string' },
                 	{ name: 'destContactMechId', type: 'string' },
                 	{ name: 'partyIdFrom', type: 'string' },
					{ name: 'originContactMechId', type: 'string' },
					{ name: 'orderId', type: 'string' },
                 	{ name: 'originProductStoreId', type: 'string' },
                 	{ name: 'originFacilityId', type: 'string' },
                 	{ name: 'destFacilityId', type: 'string' },
					{ name: 'createDate', type: 'date', other: 'Timestamp' },
					{ name: 'deliveryDate', type: 'date', other: 'Timestamp' },
					{ name: 'totalAmount', type: 'number' },
					{ name: 'no', type: 'string' },
		 		 	]"/>
<#if security.hasPermission("DELIVERY_CREATE", userLogin) >
	<@jqGrid filtersimplemode="true" id="jqxgrid" addrefresh="true" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" filterable="true" alternativeAddPopup="alterpopupWindow" editable="true" 
		 url="jqxGeneralServicer?sname=getListDelivery&orderId=${parameters.orderId}&deliveryTypeId=DELIVERY_SALES" createUrl="jqxGeneralServicer?sname=createDelivery&jqaction=C" editmode="dblclick"
		 addColumns="listOrderItems(java.util.List);orderId;currencyUomId;statusId;destFacilityId;originProductStoreId;partyIdTo;partyIdFrom;createDate(java.sql.Timestamp);destContactMechId;originContactMechId;originFacilityId;deliveryDate(java.sql.Timestamp);deliveryTypeId[DELIVERY_SALES];no" 	 
		 updateUrl="jqxGeneralServicer?sname=updateDelivery&jqaction=U" editColumns="deliveryId;statusId" functionAfterAddRow="afterAdd()"
		/>
<#else>
	<@jqGrid filtersimplemode="true" id="jqxgrid" addrefresh="true" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false" filterable="true" alternativeAddPopup="alterpopupWindow" editable="true" 
		 url="jqxGeneralServicer?sname=getListDelivery&orderId=${parameters.orderId}" createUrl="jqxGeneralServicer?sname=createDelivery&jqaction=C" editmode="dblclick"
		 addColumns="listOrderItems(java.util.List);orderId;currencyUomId;statusId;destFacilityId;originProductStoreId;partyIdTo;partyIdFrom;createDate(java.sql.Timestamp);destContactMechId;originContactMechId;originFacilityId;deliveryDate(java.sql.Timestamp);deliveryTypeId[DELIVERY_SALES];no" 	 
		 updateUrl="jqxGeneralServicer?sname=updateDelivery&jqaction=U" editColumns="deliveryId;statusId"
		/>
</#if>
</div>
			
<div id="alterpopupWindow">
	<div>${uiLabelMap.accCreateNew}</div>
	<div style="overflow: hidden;">
	<div>
	
		<input type="hidden" name="orderId"></input>
		<input type="hidden" name="currencyUomId"></input>
		<input type="hidden" name="statusId"></input>
		<input type="hidden" name="orderDate"></input>
		<h4 class="row header smaller lighter blue" style="margin-left: 20px !important">
			${uiLabelMap.Delivery}
		</h4>
		<div class="row-fluid">
			<div class="span3" style="text-align: right;">${uiLabelMap.OrderId}:</div>
			<div class="span3"><div type='text' id="orderId"></div></div>
		</div>
		<div class="row-fluid">
			<div class="span3" style="text-align: right;">${uiLabelMap.originFacilityId}:</div>
			<div class="span3"><div type='text' id="originFacilityId"></div></div>
			<div class="span2" style="text-align: right;">${uiLabelMap.destFacilityId}:</div>
			<div class="span4"><div type='text' id="destFacilityId"></div></div>
		</div>
		<div class="row-fluid">
			<div class="span3" style="text-align: right;">${uiLabelMap.deliveryDate}:</div>
			<div class="span3"><div type='text' id="deliveryDate"></div></div>
			<div class="span2" style="text-align: right;">${uiLabelMap.createDate}:</div>
			<div class="span4"><div type='text' id="createDate"></div></div>
		</div>
		<div class="row-fluid">
			<div class="span3" style="text-align: right;">${uiLabelMap.Receiver}:</div>
			<div class="span3"><div type='text' id="partyIdTo"></div></div>
			<div class="span2" style="text-align: right;">${uiLabelMap.customerAddress}:</div>
			<div class="span4"><div type='text' id="destContactMechId"></div></div>
		</div>
		<div class="row-fluid">
			<div class="span3" style="text-align: right;">${uiLabelMap.Sender}:</div>
			<div class="span3"><div type='text' id="partyIdFrom"></div></div>
			<div class="span2" style="text-align: right;">${uiLabelMap.OriginAddress}:</div>
			<div class="span4"><div type='text' id="originContactMechId"></div></div>
		</div>
		<div class="row-fluid">
			<div class="span3" style="text-align: right;">${uiLabelMap.productStore}:</div>
			<div class="span3"><div type='text' id="originProductStoreId"></div></div>
			<div class="span2" style="text-align: right;">${uiLabelMap.noNumber}:</div>
			<div class="span4"><input type='text' id="no"/></div>
		</div>
		<div class="row-fluid">
			<div style="margin-left: 20px"><#include "listOrderItemDelivery.ftl" /></div>
		</div>
		<div class="row-fluid" style="text-align: center;">
			<input type="button" id="alterSave" value="${uiLabelMap.CommonSave}" />
			<input style="margin-right: 5px;" id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" />
		</div>
	</div>
</div>
</div>

<div id="popupDeliveryDetailWindow">
<div>${uiLabelMap.DeliveryDetail}</div>
	<div style="overflow: hidden;">
	<table>
		<tr>
			<td style="max-width: 100%; display: block;">
				<h4 class="row header smaller lighter blue" style="margin-left: 50px !important">
					${uiLabelMap.Delivery}
					<a id="printPDF" target="_blank" data-rel="tooltip" title="Xuất ra PDF" data-placement="bottom" data-original-title="Xuất ra PDF"><i class="fa-file-pdf-o"></i></a>
				</h4>
			</td>
		</tr>
		<tr>
			<td align="right">
				${uiLabelMap.deliveryIdDT}:
			</td>
			<td align="left">
		       <div id="deliveryIdDT" style="width: 200px" class="green-label"></div>
		    </td>
		   
		    <td align="right" style="min-width: 200px; padding-right: 15px;">
		    	${uiLabelMap.statusIdDT}:
			</td>
			<td align="left">
				<div id="statusIdDT" class="green-label">
				</div>
			</td>
		</tr>
		<tr>
			<td align="right">
				${uiLabelMap.OrderId}:
			</td>
			<td align="left">
		       <div id="orderIdDT" style="width: 200px" class="green-label"></div>
		    </td>
		   
		    <td align="right" style="min-width: 200px; padding-right: 15px;">
		    	${uiLabelMap.facility}:
			</td>
			<td align="left">
				<div id="originFacilityIdDT" class="green-label">
				</div>
			</td>
		</tr>
		<tr>
		    <td align="right" >
	    		${uiLabelMap.productStore}:
	    	</td>
	    	<td align="left">
				<div id="originProductStoreIdDT" style="width: 200px;" class="green-label">
				</div>
			</td>
			
			<td align="right" style="min-width: 200px; padding-right: 15px;">
				${uiLabelMap.createDate}:
			</td>
			<td align="left">
				<div id="createDateDT" class="green-label"></div>
			</td>
		</tr>
		<tr>
			<td align="right" >
				${uiLabelMap.Receiver}:
			</td>
			<td align="left">
				<div id="partyIdToDT" style="width: 200px;" class="green-label">
				</div>
			</td>
			<td align="right" style="min-width: 200px; padding-right: 15px;">
				${uiLabelMap.customerAddress}:
			</td>
			<td align="left">
				<div id="destContactMechIdDT" class="green-label"></div>
			</td>
		</tr>
		<tr>
			<td align="right" >
				${uiLabelMap.Sender}:
			</td>
			<td align="left">
				<div id="partyIdFromDT" style="width: 200px;" class="green-label">
				</div>
			</td>
			
			<td align="right" style="min-width: 200px; padding-right: 15px;">
				${uiLabelMap.OriginAddress}:
			</td>
			<td align="left">
				<div id="originContactMechIdDT" class="green-label"></div>
			</td>
		</tr>
		<tr>
			<td align="right" >
				${uiLabelMap.deliveryDate}:
			</td>
			<td align="left">
				<div id="deliveryDateDT" style="width: 200px;" class="green-label"></div>
			</td>
			<td align="right" style="min-width: 200px; padding-right: 15px;">
				${uiLabelMap.noNumber}:
			</td>
			<td align="left">
				<div id="noDT" class="green-label"></div>
			</td>
		</tr>
		<tr>
			<td style="max-width: 100%;">
				<div style="margin-left: 50px"><#include "listDeliveryItem.ftl" /></div>
			</td>
		</tr>
		<tr>
	</table>
</div>
</div>

<script type="text/javascript">
	
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;

	//Create orderId 
	$("#orderId").text('${parameters.orderId}');
	$('#alterpopupWindow input[name=orderId]').val('${parameters.orderId?if_exists}');
	
	//Set Value for statusId
	$('#alterpopupWindow input[name=statusId]').val('DLV_CREATED');
	
	//Create CurrencyUom
	$('#alterpopupWindow input[name=currencyUomId]').val('${orderHeader.currencyUom?if_exists}');
	
	//Create orderDate
	$('#alterpopupWindow input[name=orderDate]').val('${orderHeader.orderDate?if_exists}');
	
	
	//Create ProductStore
	var proStoreData = new Array();
	<#list listProStore as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.storeName) >
		row['productStoreId'] = '${item.productStoreId}';
		row['description'] = '${description}';
		prodStoreData[${item_index}] = row;
	</#list>
	$("#originProductStoreId").jqxDropDownList({source: prodStoreData, selectedIndex: 0, displayMember: 'description', valueMember: 'productStoreId'});
	
	//Create Order date
	<#assign orderDateDisplay = StringUtil.wrapString(Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(orderHeader.orderDate?if_exists, "dd/MM/yyyy", locale, timeZone))>
	$('#orderDateDisplay').text('${orderDateDisplay?if_exists}');
	
	//Create partyIdTo Input
	var partyToData = new Array();
	<#list listPartyTo as item>
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + StringUtil.wrapString(item.middleName?if_exists) + StringUtil.wrapString(item.lastName?if_exists) + StringUtil.wrapString(item.groupName?if_exists))>
		var row = {};
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description}';
		partyToData[${item_index}] = row;
	</#list>
	$("#partyIdTo").jqxDropDownList({selectedIndex: 0, width: 200, source: partyToData, theme: theme, displayMember: 'description', valueMember: 'partyId'});
	
	//Create partyIdFrom Input
	var partyFromData = new Array();
	<#list listPartyFrom as item>
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + StringUtil.wrapString(item.middleName?if_exists) + StringUtil.wrapString(item.lastName?if_exists) + StringUtil.wrapString(item.groupName?if_exists))>
		var row = {};
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description}';
		partyFromData[${item_index}] = row;
	</#list>
	$("#partyIdFrom").jqxDropDownList({selectedIndex: 0, width: 200, source: partyFromData, theme: theme, displayMember: 'description', valueMember: 'partyId'});
	
	//Create Origin Facility
	facilityData = new Array();
	var index = 0;
	for(var i = 0; i < faciData.length; i++){
		if(prodStoreData[0].productStoreId == faciData[i].productStoreId){
			var row = {};
			row['facilityId'] = faciData[i].facilityId;
			row['description'] = faciData[i].description;
			facilityData[index] = row;
			index++;
		}
	}
	$('#originFacilityId').jqxDropDownList({selectedIndex: 0, width: 200, source: facilityData, theme: theme, displayMember: 'description', valueMember: 'facilityId'});
	
	//Load data grid for jqxGrid1
	alterData.pagenum = "0";
    alterData.pagesize = "20";
    alterData.noConditionFind = "Y";
    alterData.conditionsFind = "N";
    alterData.orderId = '${parameters.orderId?if_exists}';
    alterData.facilityId = facilityData[0].facilityId;
    $("#jqxgrid1").jqxGrid("updatebounddata");
	
	//Create Destination Facility
	var destFacilitySource = new Array();
	var index = 0;
	for(var i = 0; i < faciData.length; i++){
		for(var j = 0; j < partyToData.length; j++){
			if(faciData[i].ownerPartyId == partyToData[j].partyId){
				destFacilitySource[index] = faciData[i];
				index +=index;
			}
		}
	}
	$('#destFacilityId').jqxDropDownList({selectedIndex: 0, width: 200, source: destFacilitySource, theme: theme, displayMember: 'description', valueMember: 'facilityId'});
	
	//Create OrderItemType
	var orderItemTypeData = new Array();
	<#list listOrderItemTypes as item>
		var row = {};
		<#assign orderItemType = delegator.findOne("OrderItemType", {"orderItemTypeId" : item}, true)>
		<#assign description = StringUtil.wrapString(orderItemType.description?if_exists) >
		row['orderItemTypeId'] = '${item}';
		row['description'] = '${description}';
		orderItemTypeData[${item_index}] = row;
	</#list>
	
	//Create createDate
	$('#createDate').jqxDateTimeInput({width: 200});
	
	//Create destContactMechId
	var destContactData = new Array();
	<#list destContacts as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.address1?if_exists) >
		row['contactMechId'] = '${item.contactMechId?if_exists}';
		row['description'] = '${description?if_exists}';
		destContactData[${item_index}] = row;
	</#list>
	$('#destContactMechId').jqxDropDownList({source: destContactData, selectedIndex: 0, width: 200, theme: theme, displayMember: 'description', valueMember: 'contactMechId'});
	
	//Create originContactMechId
	var originContactData = new Array();
	<#list listPartyFrom as item>
		<#assign mapCondition = Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", item.partyId, "contactMechTypeId", "POSTAL_ADDRESS", "contactMechPurposeTypeId", "BILLING_LOCATION")>
		<#assign originContacts = delegator.findList("PartyContactDetailByPurpose", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(mapCondition), null, null, null, false)>
		<#list originContacts as contact>
			var row = {};
			<#assign description = StringUtil.wrapString(contact.address1?if_exists) >
			row['contactMechId'] = '${contact.contactMechId?if_exists}';
			row['description'] = '${description}';
			originContactData[${contact_index}] = row;
		</#list>
	</#list>
	$('#originContactMechId').jqxDropDownList({source: originContactData, selectedIndex: 0, width: 200, theme: theme, displayMember: 'description', valueMember: 'contactMechId'});
	
	//Create deliveryDate
	$("#deliveryDate").jqxDateTimeInput({width: 200});
	
	//Create noNumber
	$('#no').jqxInput({width: 195});
	$("#alterSave").jqxButton({width: 100, theme: theme});
	$("#alterCancel").jqxButton({width: 100, theme: theme});
	
	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		var row;
		//Get List Order Item
		var selectedIndexs = $('#jqxgrid1').jqxGrid('getselectedrowindexes');
		var listOrderItems = new Array();
		for(var i = 0; i < selectedIndexs.length; i++){
			var data = $('#jqxgrid1').jqxGrid('getrowdata', i);
			var map = {};
			map['orderItemSeqId'] = data.orderItemSeqId;
			map['orderId'] = data.orderId;
			map['quantity'] = data.resQuantity;
			listOrderItems[i] = map;
		}
		var listOrderItems = JSON.stringify(listOrderItems);
		row = { 
				orderId:$('#alterpopupWindow input[name=orderId]').val(),
				currencyUomId:$('#alterpopupWindow input[name=currencyUomId]').val(),
				statusId:$('#alterpopupWindow input[name=statusId]').val(),
				originContactMechId:$('#originContactMechId').val(),
				destFacilityId:$('#destFacilityId').val(),
				originProductStoreId:$('#originProductStoreId').val(),
				partyIdTo:$('#partyIdTo').val(),
				partyIdFrom:$('#partyIdFrom').val(),
				createDate:$('#createDate').jqxDateTimeInput('getDate'),	
				destContactMechId:$('#destContactMechId').val(),
				originFacilityId:$('#originFacilityId').val(),
				deliveryDate:$('#deliveryDate').jqxDateTimeInput('getDate'),
				no:$('#no').val(),
				listOrderItems:listOrderItems
    	  };
		$("#jqxgrid").jqxGrid('addRow', null, row, "first");
		// select the first row and clear the selection.
		$("#jqxgrid").jqxGrid('clearSelection');                        
		$("#jqxgrid").jqxGrid('selectRow', 0);  
    	$("#alterpopupWindow").jqxWindow('close');
	});
	
	//handle on change originProductStoreId
	$("#originProductStoreId").on('change', function(event){
		 var args = event.args;
		 var item;
		 if(args){
			var item = args.item;
		 }
		 var facilityData = new Array();
		 var index = 0;
		 for(var i = 0; i < faciData.length; i++){
			 if(item.value == faciData[i].productStoreId){
				 var row = {};
				 row['facilityId'] = faciData[i].facilityId;
				 row['description'] = faciData[i].description;
				 facilityData[index] = row;
				 index++;
			 }
		 }
		 $('#originFacilityId').jqxDropDownList('clear');
		 $('#originFacilityId').jqxDropDownList({source: facilityData, selectedIndex: 0});
	});
	
	//handle on change originFacilityId
	$("#originFacilityId").on('change', function(event){
		 var args = event.args;
		 var item;
		 if(args){
			var item = args.item;
			//Create Grid
			alterData.pagenum = "0";
	        alterData.pagesize = "20";
	        alterData.noConditionFind = "Y";
	        alterData.conditionsFind = "N";
	        alterData.orderId = '${parameters.orderId?if_exists}';
	        alterData.facilityId = item.value;
	        $("#jqxgrid1").jqxGrid("updatebounddata");
		 }
	});
</script>

<script type="text/javascript">
	function afterAdd(){
		$("#jqxgrid1").jqxGrid('updatebounddata');
	}

	function showDetailPopup(deliveryId){
		var deliveryDT;
		
		//Create theme
		$.jqx.theme = 'olbius';
		theme = $.jqx.theme;
		
		//Cache delivery
		$.ajax({
	           type: "POST",
	           url: "getDeliveryById",
	           data: {'deliveryId': deliveryId},
	           dataType: "json",
	           async: false,
	           success: function(response){
	        	   deliveryDT = response;
	           },
	           error: function(response){
	             alert("Error:" + response);
	           }
	    });
		//Set deliveryId for target print pdf
		var href = "/delys/control/delivery.pdf?deliveryId=";
		href += deliveryId
		$("#printPDF").attr("href", href);
		
		//Create deliveryIdDT
		$("#deliveryIdDT").text(deliveryDT.deliveryId);
		
		//Create statusIdDT
		$("#statusIdDT").text(deliveryDT.statusId);
		
		//Create orderIdDT 
		$("#orderIdDT").text(deliveryDT.orderId);
		
		//Create originFacilityIdDT
		$("#originFacilityIdDT").text(deliveryDT.originFacilityId);
		
		//Create originProductStoreIdDT
		var originProductStoreId = deliveryDT.originProductStoreId;
		var productStoreName;
		for(var i = 0; i < prodStoreData.length; i++){
			if(originProductStoreId == prodStoreData[i].productStoreId){
				productStoreName = prodStoreData[i].description;
				break;
			}
		}
		$("#originProductStoreIdDT").text(productStoreName);
		
		
		
		//Create createDateDT
		var createDate = formatDate(deliveryDT.createDate);
		$("#createDateDT").text(createDate);
		
		//Create partyIdToDT
		var partyIdTo = deliveryDT.partyIdTo;
		var partyNameTo;
		for(var i = 0; i < partyData.length; i++){
			if(partyIdTo == partyData[i].partyId){
				partyNameTo = partyData[i].description;
				break;
			}
		}
		$("#partyIdToDT").text(partyNameTo);
		
		//Create destContactMechIdDT
		var destContactMechId = deliveryDT.destContactMechId;
		var destContactMech;
		for(var i = 0; i < pstAddrData.length; i++){
			if(destContactMechId == pstAddrData[i].contactMechId){
				destContactMechId = pstAddrData[i].description;
				break;
			}
		}
		$("#destContactMechIdDT").text(destContactMechId);
		//Create partyIdFromDT
		var partyIdFrom = deliveryDT.partyIdFrom;
		var partyNameFrom;
		for(var i = 0; i < partyData.length; i++){
			if(partyIdFrom == partyData[i].partyId){
				partyNameFrom = partyData[i].description;
				break;
			}
		}
		$("#partyIdFromDT").text(partyNameFrom);
		
		//Create originContactMechIdDT
		var originAddr;
		for(var i = 0; i < pstAddrData.length; i++){
			if(deliveryDT.originContactMechId == pstAddrData[i].contactMechId){
				originAddr = pstAddrData[i].description;
				break;
			}
		}
		$("#originContactMechIdDT").text(originAddr);
		
		//Create deliveryDateDT
		var deliveryDate = formatDate(deliveryDT.deliveryDate);
		$("#deliveryDateDT").text(deliveryDate);
		
		//Create noDT
		$("#noDT").text(deliveryDT.no);
		
		//Create Grid
		alterData.pagenum = "0";
        alterData.pagesize = "20";
        alterData.noConditionFind = "Y";
        alterData.conditionsFind = "N";
        alterData.deliveryId = deliveryId;
        $("#jqxgrid2").jqxGrid("updatebounddata");
		//Open Window
		$("#popupDeliveryDetailWindow").jqxWindow('open');
	}
	
</script>

<style>
	#popupDeliveryDetailWindow .jqx-window-content table tr {
		display: block;
		margin: 7.5px 0;
	}
	
	#popupDeliveryDetailWindow .jqx-window-content table tr td:first-child {
		max-width: 235px;
		min-width: 235px;
		padding-right: 15px;
	}
	
	#popupDeliveryDetailWindow #alterSave, #popupDeliveryDetailWindow #alterCancel {
		padding: 5px 10px;
		border-radius: 5px;
		-webkit-border-radius: 5px;
		-moz-border-radius: 5px;
	}
	
	#popupDeliveryDetailWindow input.jqx-input {
		padding: 2px 0 2px 5px !important;
	}
</style>
