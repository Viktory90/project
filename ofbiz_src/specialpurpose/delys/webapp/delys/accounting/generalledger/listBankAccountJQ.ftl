<script>
	//Prepare finAccountType data
	<#assign finAccountTypes = delegator.findList("FinAccountType", null, null, null, null, false)/>
	var finAccTypeData = new Array();
	<#list finAccountTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['finAccountTypeId'] = '${item.finAccountTypeId?if_exists}';
		row['description'] = '${description?if_exists}';
		finAccTypeData[${item_index?if_exists}] = row;
	</#list>
	
	//Prepare status data
	<#assign statuses = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "FINACCT_STATUS"), null, null, null, false) />
	var statusData = new Array();
	<#list statuses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['statusId'] = '${item.statusId?if_exists}';
		row['description'] = '${description?if_exists}';
		statusData[${item_index?if_exists}] = row;
	</#list>
	
	//Prepare party data
	<#assign parties = delegator.findList("PartyNameView", null, null, null, null, false) />
	var partyData = new Array();
	<#list parties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + StringUtil.wrapString(item.middleName?if_exists) + StringUtil.wrapString(item.lastName?if_exists) + StringUtil.wrapString(item.groupName?if_exists)) />
		row['partyId'] = '${item.partyId?if_exists}';
		row['description'] = '${description?if_exists}';
		partyData[${item_index?if_exists}] = row;
	</#list>
</script>
<#assign columnlist="{ text: '${uiLabelMap.finAccountId}', dataField: 'finAccountId', width: '150',
						cellsrenderer: function(row, column, value){
							return '<span><a href=EditFinAccountRoles?finAccountId=' + value + '>' + value + '</a></span>'
							}
						},
					 { text: '${uiLabelMap.finAccountTypeId}', dataField: 'finAccountTypeId', width: '150',
						cellsrenderer: function(row, column, value){
							for(i = 0; i < finAccTypeData.length; i++){
								if(finAccTypeData[i].finAccountTypeId == value){
									return '<span title=' + value + '>' + finAccTypeData[i].description + '</span>'
								}
							}
							return ;
						}
					 },
					 { text: '${uiLabelMap.statusId}', dataField: 'statusId', width: '150',
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < statusData.length; i++){
								 if(statusData[i].statusId == value){
									 return '<span title=' + value + '>' + statusData[i].description + '</span>'
								 }
							 }
							 return ;
						 }
					 },
					 { text: '${uiLabelMap.finAccountName}', dataField: 'finAccountName', width: '150'},
					 { text: '${uiLabelMap.finAccountCode}', dataField: 'finAccountCode', width: '150'},
					 { text: '${uiLabelMap.finAccountPin}', dataField: 'finAccountPin', width: '150'},
					 { text: '${uiLabelMap.currencyUomId}', dataField: 'currencyUomId', width: '150'},
					 { text: '${uiLabelMap.organizationPartyId}', dataField: 'organizationPartyId',width: '150',
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < partyData.length; i++){
								 if(partyData[i].partyId == value){
									 return '<span>' + partyData[i].description + '<a href=viewprofile?partyId=' + value + '>[' + value + ']</a></span>'
								 }
							 }
							 return ;
						 }
					 },
					 { text: '${uiLabelMap.ownerPartyId}', dataField: 'ownerPartyId', width: '150',
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < partyData.length; i++){
								 if(partyData[i].partyId == value){
									 return '<span>' + partyData[i].description + '<a href=viewprofile?partyId=' + value + '>[' + value + ']</a></span>'
								 }
							 }
							 return ;
						 }
					 },
					 { text: '${uiLabelMap.fromDate}', dataField: 'fromDate', cellsformat: 'dd/MM/yyyy', width: '150'},
					 { text: '${uiLabelMap.thruDate}', dataField: 'thruDate', cellsformat: 'dd/MM/yyyy', width: '150'},
					 { text: '${uiLabelMap.isRefundable}', dataField: 'isRefundable', width: '150'},
					 { text: '${uiLabelMap.replenishPaymentId}', dataField: 'replenishPaymentId', width: '150'},
					 { text: '${uiLabelMap.replenishLevel}', dataField: 'replenishLevel', width: '150',},
					 { text: '${uiLabelMap.actualBalance}', dataField: 'actualBalance', width: '150'},
					 { text: '${uiLabelMap.availableBalance}', dataField: 'availableBalance', width: '150'},
					"/>
<#assign dataField="[{ name: 'finAccountId', type: 'string' },
                 	{ name: 'finAccountTypeId', type: 'string' },
                 	{ name: 'statusId', type: 'string' },
					{ name: 'finAccountName', type: 'string' },
					{ name: 'finAccountCode', type: 'string' },
                 	{ name: 'finAccountPin', type: 'string' },
                 	{ name: 'currencyUomId', type: 'string' }, 
                 	{ name: 'organizationPartyId', type: 'string'},
                 	{ name: 'ownerPartyId', type: 'string'},
                 	{ name: 'fromDate', type: 'date'},
                 	{ name: 'thruDate', type: 'date'},
                 	{ name: 'isRefundable', type: 'string'},
                 	{ name: 'replenishPaymentId', type: 'string'},
                 	{ name: 'replenishLevel', type: 'number'},
                 	{ name: 'actualBalance', type: 'number'},
                 	{ name: 'availableBalance', type: 'number'}
		 		 	]"/>
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false" filterable="false" alternativeAddPopup="alterpopupWindow" deleterow="true" editable="false" 
		 url="jqxGeneralServicer?sname=JQListBankAccount" id="jqxgrid" removeUrl="jqxGeneralServicer?sname=deleteFinAccount&jqaction=D" deleteColumn="finAccountId"
		/>