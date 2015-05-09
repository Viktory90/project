<script type="text/javascript" src="/delys/images/js/util/DateUtil.js" ></script>
<script>
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
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description}';
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
	<#if parameters.deliveryTypeId == 'DELIVERY_SALES'>
		<#if security.hasPermission("DELIVERY_UPDATE", userLogin)>
			<#assign columnlist="{ text: '${uiLabelMap.DeliveryId}', dataField: 'deliveryId', width: 150, filtertype:'input', editable:false, 
				cellsrenderer: function(row, column, value){
					 return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
				 }
				},
				{ text: '${uiLabelMap.DeliveryType}', dataField: 'deliveryTypeId', width: 150, editable:false,
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < deliveryTypeData.length; i++){
							if(deliveryTypeData[i].deliveryTypeId == value){
								return '<span title=' + value + '>' + deliveryTypeData[i].description + '</span>'
							}
						}
					}
				},
				createeditor: function(row, value, editor){
					if(value == 'DLV_DELIVERED'){
						return editor.jqxDropDownList({ source: statusData, displayMember: 'description', valueMember: 'statusId' });
					}else{
						return ;
					}
				},
				cellbeginedit: function (row, datafield, columntype) {
					var data = $('#jqxgridDlv').jqxGrid('getrowdata', row);
					if(data.statusId == 'DLV_DELIVERED'){
						tmpEditable = false;
						return true;
					}else{
						tmpEditable = true;
						return false;
					}
			    },
				filtertype: 'input'
			 },
			 { text: '${uiLabelMap.Receiver}', dataField: 'partyIdTo', width: 150, editable:false,
				cellsrenderer: function(row, column, value){
					for(var i = 0; i < partyData.length; i++){
						if(partyData[i].partyId == value){
							return '<span title=' + value + '>' + partyData[i].description + '</span>'
					},
					filtertype: 'input'
				 }, 
				{ text: '${uiLabelMap.Status}', dataField: 'statusId', width: 150, editable:true, columntype: 'custom',
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < statusData.length; i++){
							if(statusData[i].statusId == value){
								return '<span title=' + value + '>' + statusData[i].description + '</span>'
							}
						}
					},
					createeditor: function(row, value, editor){
						if(value == 'DELIVERY_DELIVERED'){
							return editor.jqxDropDownList({ source: statusData, displayMember: 'description', valueMember: 'statusId' });
						}else{
							return ;
						}
					},
					cellbeginedit: function (row, datafield, columntype) {
						var data = $('#jqxgridDlv').jqxGrid('getrowdata', row);
						if(data.statusId == 'DELIVERY_DELIVERED'){
							tmpEditable = false;
							return true;
						}else{
							tmpEditable = true;
							return false;
						}
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
				 { text: '${uiLabelMap.ProductStoreFrom}', dataField: 'originProductStoreId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < prodStoreData.length; i++){
							 if(prodStoreData[i].productStoreId == value){
								 return '<span title=' + value + '>' + prodStoreData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 },
				 { text: '${uiLabelMap.FacilityFrom}', dataField: 'originFacilityId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < faciData.length; i++){
							 if(faciData[i].facilityId == value){
								 return '<span title=' + value + '>' + faciData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 },
				 { text: '${uiLabelMap.ProductStoreTo}',dataField: 'destProductStoreId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < prodStoreData.length; i++){
							 if(prodStoreData[i].productStoreId == value){
								 return '<span title=' + value + '>' + prodStoreData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 },
				 
				 { text: '${uiLabelMap.FacilityTo}', dataField: 'destFacilityId', width: 150, editable:false,
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
		<#else>
			<#assign columnlist="{ text: '${uiLabelMap.DeliveryId}', dataField: 'deliveryId', width: 150, filtertype:'input', editable:false, 
				cellsrenderer: function(row, column, value){
					 return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
				 }
				},
				{ text: '${uiLabelMap.DeliveryType}', dataField: 'deliveryTypeId', width: 150, editable:false,
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
					createeditor: function(row, value, editor){
						editor.jqxDropDownList({ source: statusData, displayMember: 'description', valueMember: 'statusId' });
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
				 { text: '${uiLabelMap.ProductStoreFrom}',dataField: 'originProductStoreId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < prodStoreData.length; i++){
							 if(prodStoreData[i].productStoreId == value){
								 return '<span title=' + value + '>' + prodStoreData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 },
				 { text: '${uiLabelMap.FacilityFrom}', dataField: 'originFacilityId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < faciData.length; i++){
							 if(faciData[i].facilityId == value){
								 return '<span title=' + value + '>' + faciData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 },
				 { text: '${uiLabelMap.ProductStoreTo}',dataField: 'destProductStoreId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < prodStoreData.length; i++){
							 if(prodStoreData[i].productStoreId == value){
								 return '<span title=' + value + '>' + prodStoreData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 },
				 { text: '${uiLabelMap.FacilityTo}', dataField: 'destFacilityId', width: 150, editable:false,
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
		</#if>
	<#else>
		<#if parameters.deliveryTypeId == 'DELIVERY_TRANSFER'>
			<#if security.hasPermission("DELIVERY_UPDATE", userLogin)>
				<#assign columnlist="{ text: '${uiLabelMap.DeliveryId}', dataField: 'deliveryId', width: 150, filtertype:'input', editable:false, 
					cellsrenderer: function(row, column, value){
						 return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
					 }
					},
					{ text: '${uiLabelMap.DeliveryType}', dataField: 'deliveryTypeId', width: 150, editable:false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < deliveryTypeData.length; i++){
								if(deliveryTypeData[i].deliveryTypeId == value){
									return '<span title=' + value + '>' + deliveryTypeData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 }, 
					{ text: '${uiLabelMap.Status}', dataField: 'statusId', width: 150, editable:true, columntype: 'custom',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						},
						createeditor: function(row, value, editor){
							if(value == 'DELIVERY_DELIVERED'){
								return editor.jqxDropDownList({ source: statusData, displayMember: 'description', valueMember: 'statusId' });
							}else{
								return ;
							}
						},
						cellbeginedit: function (row, datafield, columntype) {
							var data = $('#jqxgridDlv').jqxGrid('getrowdata', row);
							if(data.statusId == 'DELIVERY_DELIVERED'){
								tmpEditable = false;
								return true;
							}else{
								tmpEditable = true;
								return false;
							}
					    },
						filtertype: 'input'
					 },
					 
					 { text: '${uiLabelMap.FacilityFrom}', dataField: 'originFacilityId', width: 150, editable:false,
					 cellsrenderer: function(row, column, value){
						 for(var i = 0; i < faciData.length; i++){
							 if(faciData[i].facilityId == value){
								 return '<span title=' + value + '>' + faciData[i].description + '</span>'
							 }
						 }
					 },
					 filtertype: 'input'
				 	},
					 { text: '${uiLabelMap.OriginContactMech}', dataField: 'originContactMechId', width: 250, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 
					 
					 { text: '${uiLabelMap.FacilityTo}', dataField: 'destFacilityId', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.DestinationContactMech}', dataField: 'destContactMechId', width: 250, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.createDate}', dataField: 'createDate', width: 150, cellsformat: 'd', filtertype: 'range', editable:false},
					 { text: '${uiLabelMap.deliveryDate}', dataField: 'deliveryDate', width: 150, cellsformat: 'd', filtertype: 'range', editable:false},
					 "/>
			<#else>
				<#assign columnlist="{ text: '${uiLabelMap.DeliveryId}', dataField: 'deliveryId', width: 150, filtertype:'input', editable:false, 
					cellsrenderer: function(row, column, value){
						 return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
					 }
					},
					{ text: '${uiLabelMap.DeliveryType}', dataField: 'deliveryTypeId', width: 150, editable:false,
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
						createeditor: function(row, value, editor){
							editor.jqxDropDownList({ source: statusData, displayMember: 'description', valueMember: 'statusId' });
						},
						filtertype: 'input'
					 },
					 
					 { text: '${uiLabelMap.FacilityFrom}', dataField: 'originFacilityId', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.OriginContactMech}', dataField: 'originContactMechId', width: 250, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 
					 { text: '${uiLabelMap.FacilityTo}', dataField: 'destFacilityId', width: 150, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.DestinationContactMech}', dataField: 'destContactMechId', width: 250, editable:false,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.createDate}', dataField: 'createDate', width: 150, cellsformat: 'd', filtertype: 'range', editable:false},
					 { text: '${uiLabelMap.deliveryDate}', dataField: 'deliveryDate', width: 150, cellsformat: 'd', filtertype: 'range', editable:false},
					 "/>
			</#if>
		</#if>
	</#if>
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
                 	{ name: 'destProductStoreId', type: 'string' },
                 	{ name: 'destFacilityId', type: 'string' },
					{ name: 'createDate', type: 'date', other: 'Timestamp' },
					{ name: 'deliveryDate', type: 'date', other: 'Timestamp' },
					{ name: 'totalAmount', type: 'number' },
					{ name: 'no', type: 'string' },
		 		 	]"/>
	<@jqGrid filtersimplemode="true" id="jqxgridDlv" sortdirection="desc" defaultSortColumn="createDate" sortable="true" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" filterable="true" alternativeAddPopup="alterpopupWindow" 
		 url="jqxGeneralServicer?sname=getListDelivery&deliveryTypeId=${deliveryTypeId?if_exists}&deliveryId=${parameters.deliveryId?if_exists}&statusId=${statusId?if_exists}" editable="true" 
		 updateUrl="jqxGeneralServicer?sname=updateDelivery&jqaction=U" editColumns="deliveryId;statusId"
		/>
</div>

<div id="popupDeliveryDetailWindow">
	<div>${uiLabelMap.DeliveryDetail}</div>
	<div style="overflow: hidden;">
	<#if 'DELIVERY_SALES' == parameters.deliveryTypeId>
		<table>
			<tr>
				<td style="max-width: 100%; display: block;">
					<h4 class="row header smaller lighter blue" style="margin-left: 50px !important">
						${uiLabelMap.Delivery}
						<a id="printPDF" target="_blank" data-rel="tooltip" title="${uiLabelMap.PrintToPDF}" data-placement="bottom" data-original-title="${uiLabelMap.PrintToPDF}"><i class="fa-file-pdf-o"></i></a>
					</h4>
				</td>
			</tr>
			<tr>
				<td align="right">
					${uiLabelMap.DeliveryId}:
				</td>
				<td align="left">
			       <div id="deliveryIdDT" style="width: 200px" class="green-label"></div>
			    </td>
			   
			    <td align="right" style="min-width: 200px; padding-right: 15px;">
			    	${uiLabelMap.Status}:
				</td>
				<td align="left">
					<div id="statusIdDT" class="green-label">
					</div>
				</td>
			</tr>
			<tr id="storeAndFacilityId">
			    <td align="right" >
		    		${uiLabelMap.productStore}:
		    	</td>
		    	<td align="left">
					<div id="productStoreIdDT" style="width: 200px;" class="green-label">
					</div>
				</td>
				<td align="right" style="min-width: 200px; padding-right: 15px;">
			    	${uiLabelMap.facility}:
				</td>
				<td align="left">
					<div id="facilityIdDT" class="green-label">
					</div>
				</td>
			</tr>
			<tr id="orderAndCreateDateId">
				<td align="right">
					${uiLabelMap.OrderId}:
				</td>
				<td align="left">
			       <div id="orderIdDT" style="width: 200px" class="green-label"></div>
			    </td>
			   <td align="right" style="min-width: 200px; padding-right: 15px;">
					${uiLabelMap.createDate}:
				</td>
				<td align="left">
					<div id="createDateDT" class="green-label"></div>
				</td>
			    
			</tr>
			<tr id="originAndDestStoreId">
			    <td align="right" >
		    		${uiLabelMap.ProductStoreFrom}:
		    	</td>
		    	<td align="left">
					<div id="originProductStoreIdDT" style="width: 200px;" class="green-label">
					</div>
				</td>
				<td align="right" >
		    		${uiLabelMap.ProductStoreTo}:
		    	</td>
		    	<td align="left">
					<div id="destProductStoreIdDT" style="width: 200px;" class="green-label">
					</div>
				</td>
			</tr>
			<tr id="originAndDestFacilityId">
				<td align="right">
					${uiLabelMap.FacilityFrom}:
				</td>
				<td align="left">
			       <div id="originFacilityIdDT" style="width: 200px" class="green-label"></div>
			    </td>
			   
			    <td align="right" style="min-width: 200px; padding-right: 15px;">
			    	${uiLabelMap.FacilityTo}:
				</td>
				<td align="left">
					<div id="destFacilityIdDT" class="green-label">
					</div>
				</td>
			</tr>
			
			<tr id="receiverId">
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
			<tr id="senderId">
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
	<#else>
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
	</#if>
</div>
</div>

<script type="text/javascript">
	var alterData = new Object();
	var deliveryDT;
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
		$("#orderIdDT").text(deliveryDT.orderId);
		
		//Create transferIdDT 
		$("#transferId").val(deliveryDT.transferId);
		
		//Create originFacilityIdDT, destFacilityIdDT
		
		var originProductStoreId = deliveryDT.originProductStoreId;
		var productStoreName;
		var originStoreName;
		for(var i = 0; i < prodStoreData.length; i++){
			if(originProductStoreId == prodStoreData[i].productStoreId){
				originStoreName = prodStoreData[i].description;
				productStoreName = prodStoreData[i].description;
				break;
			}
		}
		$("#originProductStoreIdDT").text(originStoreName);
		$("#productStoreIdDT").text(productStoreName);
		
		var destProductStoreId = deliveryDT.destProductStoreId;
		var destStoreName;
		for(var i = 0; i < prodStoreData.length; i++){
			if(destProductStoreId == prodStoreData[i].productStoreId){
				destStoreName = prodStoreData[i].description;
				break;
			}
		}
		$("#destProductStoreIdDT").text(destStoreName);		
		
		var originFacilityId = deliveryDT.originFacilityId;
		var facilityName;
		var originFacilityName;
		for(var i = 0; i < faciData.length; i++){
			if(originFacilityId == faciData[i].facilityId){
				originFacilityName = faciData[i].description;
				facilityName = faciData[i].description;
				break;
			}
		}
		$("#originFacilityIdDT").text(originFacilityName);
		$("#facilityIdDT").text(facilityName);
		
		var destFacilityId = deliveryDT.destFacilityId;
		var destFacilityName;
		for(var i = 0; i < faciData.length; i++){
			if(destFacilityId == faciData[i].facilityId){
				destFacilityName = faciData[i].description;
				break;
			}
		}
		$("#destFacilityIdDT").text(destFacilityName);		
		
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
		deliveryTypeIdDT = deliveryDT.deliveryTypeId;
		if ("DELIVERY_SALES" == deliveryTypeIdDT){
			$("#orderAndCreateDateId").show();
			$("#originAndDestFacilityId").hide();
			$("#storeAndFacilityId").show();
			$("#receiverId").show();
			$("#senderId").show();
			$("#originAndDestStoreId").hide();
		}
		if ("DELIVERY_TRANSFER" == deliveryTypeIdDT){
			$("#headerSalesDiliveryId").hide();
			$("#orderAndCreateDateId").hide();
			$("#originAndDestFacilityId").show();
			$("#storeAndFacilityId").hide();
			$("#receiverId").hide();
			$("#senderId").hide();
			$("#originAndDestStoreId").show();
		}
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
