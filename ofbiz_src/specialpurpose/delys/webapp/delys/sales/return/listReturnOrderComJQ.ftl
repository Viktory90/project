<script type="text/javascript">
	<#assign statusList = delegator.findByAnd("StatusItem", {"statusTypeId" : "ORDER_RETURN_STTS"}, null, false) />
	var statusData = new Array();
	<#list statusList as statusItem>
		<#assign description = StringUtil.wrapString(statusItem.get("description", locale)) />
		var row = {};
		row['statusId'] = '${statusItem.statusId}';
		row['description'] = "${description}";
		statusData[${statusItem_index}] = row;
	</#list>
	
	<#assign reasonList = delegator.findByAnd("ReturnReason", null, null, false) />
	var reasonData = new Array();
	<#list reasonList as reasonItem>
		<#assign description = StringUtil.wrapString(reasonItem.get("description", locale)) />
		var row = {};
		row['reasonId'] = '${reasonItem.returnReasonId}';
		row['description'] = "${description}";
		reasonData[${reasonItem_index}] = row;
	</#list>
</script>
<#assign uomList = delegator.findByAnd("Uom", {"uomTypeId" : "PRODUCT_PACKING"}, null, false)/>
<script type="text/javascript">
	var uomData = new Array();
	<#list uomList as uomItem>
		<#assign description = StringUtil.wrapString(uomItem.get("description", locale)) />
		var row = {};
		row['uomId'] = '${uomItem.uomId}';
		row['description'] = "${description?default('')}";
		uomData[${uomItem_index}] = row;
	</#list>
	
	<#assign returnHeaderTypeList = delegator.findByAnd("ReturnHeaderType", null, null, false)/>
	var returnHeaderTypeData = new Array();
	<#list returnHeaderTypeList as item>
		<#assign description = StringUtil.wrapString(item.get("description", locale)) />
		var row = {};
		row['typeId'] = '${item.returnHeaderTypeId}';
		row['description'] = "${description?default('')}";
		returnHeaderTypeData[${item_index}] = row;
	</#list>
</script>

<#assign dataField="[{ name: 'returnId', type: 'string'},
					{name: 'returnHeaderTypeId', type: 'string'},
	             	{name: 'statusId', type: 'string'},
	             	{name: 'createdBy', type: 'string'},
	             	{name: 'fromPartyId', type: 'string'},
					{name: 'toPartyId', type: 'string'},
	             	{name: 'paymentMethodId', type: 'string'},
	             	{name: 'finAccountId', type: 'string'},
	             	{name: 'billingAccountId', type: 'string'},
	             	{name: 'entryDate', type: 'date', other: 'Timestamp'},
					{name: 'originContactMechId', type: 'string'},
					{name: 'destinationFacilityId', type: 'string'},
					{name: 'needsInventoryReceive', type: 'string'},
					{name: 'currencyUomId', type: 'string'},
					{name: 'supplierRmaId', type: 'string'},
	 		 	]"/>
	 		 	
<#assign columnlist="{text: '${uiLabelMap.DAReturnOrderId}', dataField: 'returnId', width: 150,
						cellsrenderer: function(row, colum, value) {
                        	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                        	return \"<span><a href='/delys/control/viewReturnOrderGeneral?returnId=\" + data.returnId + \"'>\" + data.returnId + \"</a></span>\";
                        }
					},
					{text: '${uiLabelMap.DAReturnHeaderTypeId}', dataField: 'returnHeaderTypeId', width: 150, filtertype: 'checkedlist', 
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < returnHeaderTypeData.length; i++){
								if(returnHeaderTypeData[i].typeId == value){
									return '<span title=' + value + '>' + returnHeaderTypeData[i].description + '</span>'
								}
							}
						}, 
					 	createfilterwidget: function (column, columnElement, widget) {
							var filterDataAdapter = new $.jqx.dataAdapter(returnHeaderTypeData, {
								autoBind: true
							});
							var records = filterDataAdapter.records;
							records.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
							widget.jqxDropDownList({source: records, displayMember: 'typeId', valueMember: 'typeId',
								renderer: function(index, label, value){
									for(var i = 0; i < returnHeaderTypeData.length; i++){
										if(returnHeaderTypeData[i].typeId == value){
											return '<span>' + returnHeaderTypeData[i].description + '</span>';
										}
									}
									return value;
								}
							});
							widget.jqxDropDownList('checkAll');
			   			}
					},
				 	{text: '${uiLabelMap.DAStatus}', dataField: 'statusId', width: 150, filtertype: 'checkedlist', 
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						}, 
					 	createfilterwidget: function (column, columnElement, widget) {
							var filterDataAdapter = new $.jqx.dataAdapter(statusData, {
								autoBind: true
							});
							var records = filterDataAdapter.records;
							records.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
							widget.jqxDropDownList({source: records, displayMember: 'statusId', valueMember: 'statusId',
								renderer: function(index, label, value){
									for(var i = 0; i < statusData.length; i++){
										if(statusData[i].statusId == value){
											return '<span>' + statusData[i].description + '</span>';
										}
									}
									return value;
								}
							});
							widget.jqxDropDownList('checkAll');
			   			}
				 	},
				 	{text: '${uiLabelMap.DACreatedBy}', dataField: 'createdBy', width: 150},
				 	{text: '${uiLabelMap.DAFromPartyId}', dataField: 'fromPartyId', width: 150},
				 	{text: '${uiLabelMap.DAToPartyId}', dataField: 'toPartyId', width: 150, filterable: false, sortable: false},
				 	{text: '${uiLabelMap.DAEntryDate}', dataField: 'entryDate', width: 150, cellsformat: 'd', filtertype: 'range'},
				 	{text: '${uiLabelMap.DAOriginContactMechId}', dataField: 'originContactMechId', width: 150},
				 	{text: '${uiLabelMap.DACurrencyUomId}', dataField: 'currencyUomId', width: 150},
				 "/>
				 
<@jqGrid url="jqxGeneralServicer?sname=JQGetListReturnOrderToCompany" dataField=dataField columnlist=columnlist filterable="true" clearfilteringbutton="true"
		 showtoolbar="true" alternativeAddPopup="alterpopupWindow" filtersimplemode="true" addType="popup" deleterow="false" defaultSortColumn="entryDate" sortdirection="desc" 
		 mouseRightMenu="true" contextMenuId="contextMenu" 
		 />
<div id='contextMenu' style="display:none">
	<ul>
	    <li><i class="icon-refresh open-sans"></i>${StringUtil.wrapString(uiLabelMap.DARefresh)}</li>
	    <li><i class="fa fa-search"></i>${StringUtil.wrapString(uiLabelMap.DAViewDetail)}</li>
	</ul>
</div>

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script type="text/javascript" src="/aceadmin/assets/js/bootbox.min.js"></script>
<script type="text/javascript">
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	$("#contextMenu").jqxMenu({ width: 200, autoOpenPopup: false, mode: 'popup', theme: theme});
	$("#contextMenu").on('itemclick', function (event) {
		var args = event.args;
        var rowindex = $("#jqxgrid").jqxGrid('getselectedrowindex');
        var tmpKey = $.trim($(args).text());
        if (tmpKey == "${StringUtil.wrapString(uiLabelMap.DARefresh)}") {
        	$("#jqxgrid").jqxGrid('updatebounddata');
        } else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.DAViewDetail)}") {
        	var data = $("#jqxgrid").jqxGrid("getrowdata", rowindex);
			if (data != undefined && data != null) {
				var returnId = data.returnId;
				var url = 'viewReturnOrderGeneral?returnId=' + returnId;
				var win = window.open(url, '_blank');
				win.focus();
			}
        }
	});
</script>
