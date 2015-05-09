<script type="text/javascript">
	var contactMechDataColumn = new Array();
	<#assign facilities = delegator.findList("Facility", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("ownerPartyId", "company"), null, null, null, false)>
	var facilityData = new Array();
	<#list facilities as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.facilityId?if_exists}';
		row['description'] = '${description?if_exists}';
		facilityData[${item_index}] = row;
	</#list>
	
	<#assign statusItems = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "RECEIPT_STATUS"), null, null, null, false)>
	var statusData = new Array();
	<#list statusItems as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['statusId'] = '${item.statusId?if_exists}';
		row['description'] = '${description?if_exists}';
		statusData[${item_index}] = row;
	</#list>
	
	<#assign postalAddress = delegator.findList("FacilityContactMechDetail", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("contactMechPurposeTypeId", "SHIPPING_LOCATION"), null, null, null, false) />
	var postalAddressData = new Array();
	<#list postalAddress as item>
		var row = {};
		row['contactMechId'] = '${item.contactMechId}';
		row['description'] = '${item.address1}';
		postalAddressData[${item_index}] = row;
	</#list>
</script>

<#assign dataField="[{ name: 'receiptId', type: 'string'},
			   { name: 'facilityId', type: 'string'},
			   { name: 'agreementId', type: 'string'},
			   { name: 'orderId', type: 'string'},
			   { name: 'contactMechId', type: 'string'},
			   { name: 'no', type: 'string'},
			   { name: 'createDate', type: 'date', other: 'Timestamp' },
			   { name: 'receiptDate', type: 'date', other: 'Timestamp' },
			   { name: 'statusId', type: 'string'},
			   
			   ]"/>

<#assign columnlist="{ text: '${StringUtil.wrapString(uiLabelMap.ReceiptId)}', datafield: 'receiptId', width: 100, align: 'center', cellsrenderer:
			       		function(row, colum, value){
							return '<a style = \"margin-left: 10px\" href=' + 'getDetailReceipts?receiptId=' + value + '>' +  value + '</a>'
			        	} 
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.AgreementId)}', datafield: 'agreementId', width: 150, align: 'center',
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.ReceiveDate)}', datafield: 'receiptDate', width: 150, align: 'center', cellsformat: 'd', editable: false, cellsformat: 'dd/MM/yyyy',},
					{ text: '${StringUtil.wrapString(uiLabelMap.ReceiptToFacility)}', datafield: 'facilityId', minwidth: 250, align: 'center',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < facilityData.length; i++){
								if(facilityData[i].facilityId == value){
									return '<span title=' + value + '>' + facilityData[i].description + '</span>'
								}
							}
						},
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.FacilityAddress)}', datafield: 'contactMechId', minwidth: 150, align: 'center',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < postalAddressData.length; i++){
								if(postalAddressData[i].contactMechId == value){
									return '<span title=' + value + '>' + postalAddressData[i].description + '</span>'
								}
							}
						},
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.createDate)}', datafield: 'createDate', width: 150, align: 'center', cellsformat: 'd', editable: false, cellsformat: 'dd/MM/yyyy',},
					{ text: '${StringUtil.wrapString(uiLabelMap.Status)}', datafield: 'statusId', width: 150, align: 'center',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						}
					},
					"/>
			   
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
	showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false"
	url="jqxGeneralServicer?sname=getListReceipts"
/>
			  