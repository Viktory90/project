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
	<#assign columnlist="{ text: '${uiLabelMap.TransferNoteId}', dataField: 'deliveryId', width: 150, filtertype:'input', editable:false, 
					cellsrenderer: function(row, column, value){
						 return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + '> ' + value  + '</a></span>'
					 }
					},
					{ text: '${uiLabelMap.Status}', dataField: 'statusId', width: 170, editable:true, columntype: 'dropdownlist',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						},
						createeditor: function(row, value, editor){
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
					 { text: '${uiLabelMap.FacilityFrom}', dataField: 'originFacilityId', width: 200, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.FacilityTo}', dataField: 'destFacilityId', editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.createDate}', dataField: 'createDate', width: 200, cellsformat: 'd', filtertype: 'range', editable:false},
					 { text: '${uiLabelMap.TransferDate}', dataField: 'deliveryDate', width: 200, cellsformat: 'd', filtertype: 'range', editable:false},
					 "/>
	<#assign dataField="[{ name: 'deliveryId', type: 'string' },
					{ name: 'statusId', type: 'string' },
                 	{ name: 'originFacilityId', type: 'string' },
                 	{ name: 'destFacilityId', type: 'string' },
					{ name: 'createDate', type: 'date', other: 'Timestamp' },
					{ name: 'deliveryDate', type: 'date', other: 'Timestamp' },
		 		 	]"/>
	<@jqGrid filtersimplemode="true" id="jqxgrid" addrefresh="true" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false" filterable="true" alternativeAddPopup="alterpopupWindow" editable="true" 
		 url="jqxGeneralServicer?sname=getListTransferDelivery&transferId=${parameters.transferId?if_exists}&statusId=${statusId?if_exists}" createUrl="" editmode="dblclick"
		 addColumns="listTransferItems(java.util.List);transferId;statusId;destFacilityId;originFacilityId;deliveryDate(java.sql.Timestamp);deliveryTypeId[DELIVERY_TRANSFER];" 	 
		 updateUrl="jqxGeneralServicer?sname=updateTransferDelivery&jqaction=U" editColumns="statusId" functionAfterAddRow=""
		/>
</div>
<div id="popupDeliveryDetailWindow" class="hide">
	<div>${uiLabelMap.DeliveryDetail}</div>
	<div style="overflow: hidden;">
		<div style="overflow: scroll; height: 500px;">
			<div class='row-fluid' style="margin-left: 30px">
				<div class='span12'>
					<h4 class="row header smaller lighter blue">
						${uiLabelMap.GeneralInfo}
						<a id="printPDF" target="_blank" data-rel="tooltip" title="${uiLabelMap.PrintToPDF}" data-placement="bottom" data-original-title="${uiLabelMap.PrintToPDF}"><i class="fa-file-pdf-o"></i></a>
					</h4>
				</div>
			</div>
			<div class='row-fluid' style="margin-left: 30px">
				<div class='span3' style="text-align: right;">
					${uiLabelMap.deliveryIdDT}:
				</div>
				<div class='span3 green-label'>
					<div id="deliveryIdDT">
					</div>
				</div>
				<div class='span2' style="text-align: right;">
					${uiLabelMap.statusIdDT}:
				</div>
				<div class='span4 green-label'>
					<div id="statusIdDT">
					</div>
				</div>
			</div>
			<div class='row-fluid' style="margin-left: 30px">
				<div class='span3' style="text-align: right;">
					${uiLabelMap.FacilityFrom}:
				</div>
				<div class='span3 green-label'>
					<div id="originFacilityIdDT">
					</div>
				</div>
				<div class='span2' style="text-align: right;">
					${uiLabelMap.FacilityTo}:
				</div>
				<div class='span4 green-label'>
					<div id="destFacilityIdDT">
					</div>
				</div>
			</div>
			<div class='row-fluid' style="margin-left: 30px">
				<div class='span3' style="text-align: right; ">
					${uiLabelMap.OriginContactMech}:
				</div>
				<div class='span3 green-label'>
					<div id="originContactMechIdDT">
					</div>
				</div>
				<div class='span2' style="text-align: right;">
					${uiLabelMap.DestinationContactMech}:
				</div>
				<div class='span4 green-label'>
					<div id="destContactMechIdDT">
					</div>
				</div>
			</div>
			<div class='row-fluid' style="margin-left: 30px">
				<div class='span3' style="text-align: right;">
					${uiLabelMap.createDate}:
				</div>
				<div class='span3 green-label'>
					<div id="createDateDT">
					</div>
				</div>
				<div class='span2' style="text-align: right;">
					${uiLabelMap.deliveryDate}:
				</div>
				<div class='span4 green-label'>
					<div id="deliveryDateDT">
					</div>
				</div>
			</div>
			<div class='row-fluid'>
				<div class='span12'>
					<div style="margin-left: 30px"><#include "component://delys/webapp/delys/accounting/appr/listDeliveryItem.ftl" /></div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	
	function functionAfterUpdate(){
		$.ajax({
	           type: "POST",
	           url: "getDeliveryById",
	           data: {'deliveryId': selectedDlvId},
	           dataType: "json",
	           async: false,
	           success: function(response){
	        	   deliveryDT = response;
	           },
	           error: function(response){
	             alert("Error:" + response);
	           }
	    });
		//Create statusIdDT
		var statusDT;
		for(var i = 0; i < statusData.length; i++){
			if(deliveryDT.statusId == statusData[i].statusId){
				statusDT = 	statusData[i].description;
				break;
			}
		}
		$("#statusIdDT").text(statusDT);
		
		$("#jqxgrid2").jqxGrid('updatebounddata');
	}
	function showDetailPopup(deliveryId){
		selectedDlvId = deliveryId;
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
		var statusDT;
		for(var i = 0; i < statusData.length; i++){
			if(deliveryDT.statusId == statusData[i].statusId){
				statusDT = 	statusData[i].description;
				break;
			}
		}
		$("#statusIdDT").text(statusDT);
		
		//Create orderIdDT 
		$("#transferIdDT").text(deliveryDT.transferId);
		
		//Create originFacilityIdDT
		var originFacilityDT;
		for(var i = 0; i < faciData.length; i++){
			if(deliveryDT.originFacilityId == faciData[i].facilityId){
				originFacilityDT = 	faciData[i].description;
				break;
			}
		}
		$("#originFacilityIdDT").text(originFacilityDT);
		
		//Create destFacilityIdDT
		var destFacilityDT;
		for(var i = 0; i < faciData.length; i++){
			if(deliveryDT.destFacilityId == faciData[i].facilityId){
				destFacilityDT = 	faciData[i].description;
				break;
			}
		}
		$("#destFacilityIdDT").text(destFacilityDT);
		
		//Create createDateDT
		var createDate = formatDate(deliveryDT.createDate);
		$("#createDateDT").text(createDate);
		
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