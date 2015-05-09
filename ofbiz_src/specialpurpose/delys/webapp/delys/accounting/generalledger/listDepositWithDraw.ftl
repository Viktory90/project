<script>
	<#assign parties = delegator.findList("PartyNameView", null, null, null, null, false)/>
	var partyData = new Array();
	<#list parties as item>
		var row = {}; 
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + StringUtil.wrapString(item.middleName?if_exists) + StringUtil.wrapString(item.lastName?if_exists) + StringUtil.wrapString(item.groupName?if_exists)) >
		row['partyId'] = '${item.partyId?if_exists}';
		row['description'] = '${description?if_exists}';
		partyData[${item_index}] = row;
	</#list>
</script>
<#assign columnlist="{ text: '${uiLabelMap.paymentId}', dataField: 'paymentId', editable: false},
                     { text: '${uiLabelMap.paymentTypeDesc}', dataField: 'paymentTypeDesc', editable: false},
                     { text: '${uiLabelMap.partyIdFrom}', dataField: 'partyIdFrom', editable: false,
						cellsrenderer: function(row, column, value){
							for(i = 0; i < partyData.length; i++){
								if(partyData[i].partyId == value){
									return '<span title=' + value + '>' + partyData[i].description + '</span>'
								}
							}
						}
                     },
                     { text: '${uiLabelMap.partyIdTo}', dataField: 'partyIdTo', editable: false,
                    	 cellsrenderer: function(row, column, value){
 							for(i = 0; i < partyData.length; i++){
 								if(partyData[i].partyId == value){
 									return '<span title=' + value + '>' + partyData[i].description + '</span>'
 								}
 							}
 						}
                     },
					 { text: '${uiLabelMap.amount}', dataField: 'amount', editable: false, 
                    	 cellsrenderer: function(row, column, value){
                    		 var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                    		 return '<span>' + formatcurrency(data.amount,data.currencyUomId) + '</span>';
                    	 }
					 },
					 { text: '${uiLabelMap.effectiveDate}', dataField: 'effectiveDate', editable: false, cellsformat: 'dd/MM/yyyy'}
                     "/>

<#assign dataField="[{ name: 'paymentId', type: 'string' },
                 	{ name: 'paymentTypeDesc', type: 'string' },
                 	{ name: 'partyIdFrom', type: 'string' },
                 	{ name: 'partyIdTo', type: 'string' },
                 	{ name: 'amount', type: 'number' },
                 	{ name: 'currencyUomId', type: 'string' },
                 	{ name: 'effectiveDate', type: 'date' }
                 	]
		 		  	"/>
<@jqGrid filtersimplemode="true" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false" deleterow="false" filterable="true" alternativeAddPopup="alterpopupWindow" editable="true"
		 url="jqxGeneralServicer?sname=JQListDepositWithDraw&finAccountId=${parameters.finAccountId}&organizationPartyId=${defaultOrganizationPartyId}"
		/>