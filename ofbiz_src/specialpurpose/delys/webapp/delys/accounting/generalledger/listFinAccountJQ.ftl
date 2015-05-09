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
	
	//Prepare uom data
	<#assign uoms = delegator.findList("Uom", null, null, null, null, false) />
	var uomData = new Array();
	<#list uoms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists + "-" + item.uomId?if_exists)/>
		row['uomId'] = '${item.uomId}';
		row['description'] = '${description}';
		uomData[${item_index?if_exists}] = row;
	</#list>
	
	//Yes No data
	var isRefundableData = new Array();
	var row0 = {};
	row0['isRefundable'] = 'Y';
	row0['description'] = '${uiLabelMap.FormFieldTitle_Yes}';
	isRefundableData[0] = row0;
	var row1 = {};
	row1['isRefundable'] = 'N';
	row1['description'] = '${uiLabelMap.FormFieldTitle_No}';
	isRefundableData[1] = row1;
</script>
<#assign columnlist="{ text: '${uiLabelMap.finAccountId}', dataField: 'finAccountId',width: '150px', editable:false, filterable: true,
						cellsrenderer: function(row, column, value){
							return '<span><a href=EditFinAccountRoles?finAccountId=' + value + '>' + value + '</a></span>'
							}
						},
					 { text: '${uiLabelMap.finAccountTypeId}', dataField: 'finAccountTypeId',width: '150px', editable:true, filtertype: 'checkedlist', columntype: 'template',filterable: true,
						cellsrenderer: function(row, column, value){
							for(i = 0; i < finAccTypeData.length; i++){
								if(finAccTypeData[i].finAccountTypeId == value){
									return '<span title=' + value + '>' + finAccTypeData[i].description + '</span>'
								}
							}
							return ;
						},
						createeditor: function(row, cellvalue, editor){
							editor.jqxDropDownList({ source: finAccTypeData, selectedIndex: 0, width: '150px', height: '25px', displayMember: 'finAccountTypeId', valueMember:'finAccountTypeId'});
						},
						createfilterwidget: function(column, columnElement, widget){
							var filterAccTypeDataAdapter = new $.jqx.dataAdapter(finAccTypeData, {
								autoBind: true
							});
							var records = filterAccTypeDataAdapter.records;
							records.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
							widget.jqxDropDownList({source: records, displayMember: 'finAccountTypeId', valueMember: 'finAccountTypeId',
								renderer: function(index, label, value){
									for(var i = 0; i < finAccTypeData.length; i++){
										if(finAccTypeData[i].finAccountTypeId == value){
											return '<span>' + finAccTypeData[i].description + '</span>';
										}
									}
									return value;
								}
							});
							widget.jqxDropDownList('checkAll');
						}
					 },
					 { text: '${uiLabelMap.statusId}', dataField: 'statusId', editable:true, width: '150px', columntype: 'template',filterable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < statusData.length; i++){
								 if(statusData[i].statusId == value){
									 return '<span title=' + value + '>' + statusData[i].description + '</span>'
								 }
							 }
							 return ;
						 },
						 createeditor: function(row, cellvalue, editor){
							 editor.jqxDropDownList({source:statusData, selectedIndex: 0, width: '150px', height:'25px', displayMember: 'statusId', valueMember: 'statusId'});
						 }
					 },
					 { text: '${uiLabelMap.finAccountName}', dataField: 'finAccountName',width: '150px', editable: true, filterable: true},
					 { text: '${uiLabelMap.finAccountCode}', dataField: 'finAccountCode',width: '150px', editable: true, filterable: false},
					 { text: '${uiLabelMap.finAccountPin}', dataField: 'finAccountPin',width: '150px', editable: true, filterable: false},
					 { text: '${uiLabelMap.currencyUomId}', dataField: 'currencyUomId',width: '150px', editable: true, columntype: 'template', filterable: false,
						 createeditor: function(row, cellvalue, editor){
							 editor.jqxDropDownList({ source: uomData, selectedIndex: 0, width: '150px', height: '25px', displayMember: 'uomId', valueMember:'uomId'});
						 }
					 },
					 { text: '${uiLabelMap.organizationPartyId}', dataField: 'organizationPartyId',width: '150px', editable: true, columntype: 'template', filterable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < partyData.length; i++){
								 if(partyData[i].partyId == value){
									 return '<span>' + partyData[i].description + '<a href=viewprofile?partyId=' + value + '>[' + value + ']</a></span>'
								 }
							 }
							 return ;
						 },
						 createeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
	                            editor.append('<div id=\"jqxGridParty\"></div>');
	                            editor.jqxDropDownButton({width: '150'});
	                            // prepare the data
							    var sourceParty = { datafields: [
							      { name: 'partyId', type: 'string' },
							      { name: 'partyTypeId', type: 'string' },
							      { name: 'firstName', type: 'string' },
							      { name: 'lastName', type: 'string' },
							      { name: 'groupName', type: 'string' }
							    ],
								cache: false,
								root: 'results',
								datatype: 'json',
								
								beforeprocessing: function (data) {
					    			sourceParty.totalrecords = data.TotalRows;
								},
								filter: function () {
					   				// update the grid and send a request to the server.
					   				$(\"#jqxGridParty\").jqxGrid('updatebounddata');
								},
								sort: function () {
					  				$(\"#jqxGridParty\").jqxGrid('updatebounddata');
								},
								sortcolumn: 'partyId',
	               				sortdirection: 'asc',
								type: 'POST',
								data: {
									noConditionFind: 'Y',
									conditionsFind: 'N',
								},
								pagesize:5,
								contentType: 'application/x-www-form-urlencoded',
								url: 'jqxGeneralServicer?sname=getFromParty',
								};
							    var dataAdapterParty = new $.jqx.dataAdapter(sourceParty,
							    {
							    	formatData: function (data) {
								    	if (data.filterscount) {
				                            var filterListFields = \"\";
				                            for (var i = 0; i < data.filterscount; i++) {
				                                var filterValue = data[\"filtervalue\" + i];
				                                var filterCondition = data[\"filtercondition\" + i];
				                                var filterDataField = data[\"filterdatafield\" + i];
				                                var filterOperator = data[\"filteroperator\" + i];
				                                filterListFields += \"|OLBIUS|\" + filterDataField;
				                                filterListFields += \"|SUIBLO|\" + filterValue;
				                                filterListFields += \"|SUIBLO|\" + filterCondition;
				                                filterListFields += \"|SUIBLO|\" + filterOperator;
				                            }
				                            data.filterListFields = filterListFields;
				                        }
				                         data.$skip = data.pagenum * data.pagesize;
				                         data.$top = data.pagesize;
				                         data.$inlinecount = \"allpages\";
				                        return data;
				                    },
				                    loadError: function (xhr, status, error) {
					                    alert(error);
					                },
					                downloadComplete: function (data, status, xhr) {
					                        if (!sourceParty.totalRecords) {
					                            sourceParty.totalRecords = parseInt(data[\"odata.count\"]);
					                        }
					                }, 
					                beforeLoadComplete: function (records) {
					                	for (var i = 0; i < records.length; i++) {
					                		if(typeof(records[i])==\"object\"){
					                			for(var key in records[i]) {
					                				var value = records[i][key];
					                				if(value != null && typeof(value) == \"object\" && typeof(value) != null){
					                					var date = new Date(records[i][key][\"time\"]);
					                					records[i][key] = date;
					                				}
					                			}
					                		}
					                	}
					                }
							    });
					            $(\"#jqxGridParty\").jqxGrid({
					            	width:400,
					                source: dataAdapterParty,
					                filterable: true,
					                virtualmode: true, 
					                sortable:true,
					                editable: false,
					                autoheight:true,
					                pageable: true,
					                rendergridrows: function(obj)
									{
										return obj.data;
									},
					                columns: [
					                  { text: 'partyId', datafield: 'partyId'},
					                  { text: 'partyTypeId', datafield: 'partyTypeId'},
					                  { text: 'firstName', datafield: 'firstName'},
					                  { text: 'lastName', datafield: 'lastName'},
					                  { text: 'groupName', datafield: 'groupName'}
					                ]
					            });
					            isSelectedOrg = false;
					            $(\"#jqxGridParty\").on('rowselect', function (event) {
		                                var args = event.args;
		                                var row = $(\"#jqxGridParty\").jqxGrid('getrowdata', args.rowindex);
		                                var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['partyId'] +'</div>';
		                                isSelectedOrg = true;
		                                selectedorganizationPartyId = row.partyId;
		                                editor.jqxDropDownButton('setContent', dropDownContent);
		                            });
		                      },
		                      geteditorvalue: function (row, cellvalue, editor) {
		                          // return the editor's value.
		                          if(!isSelectedOrg){
		                        	  selectedorganizationPartyId = cellvalue;
		                          }
		                    	  editor.jqxDropDownButton(\"close\");
		                          return selectedorganizationPartyId;
		                      }
					 },
					 { text: '${uiLabelMap.ownerPartyId}', dataField: 'ownerPartyId',width: '150px', editable: true, columntype: 'template', filterable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < partyData.length; i++){
								 if(partyData[i].partyId == value){
									 return '<span>' + partyData[i].description + '<a href=viewprofile?partyId=' + value + '>[' + value + ']</a></span>'
								 }
							 }
							 return ;
						 },
						 createeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
	                            editor.append('<div id=\"jqxGridOwnerParty\"></div>');
	                            editor.jqxDropDownButton({width: '150'});
	                            // prepare the data
							    var sourceParty = { datafields: [
							      { name: 'partyId', type: 'string' },
							      { name: 'partyTypeId', type: 'string' },
							      { name: 'firstName', type: 'string' },
							      { name: 'lastName', type: 'string' },
							      { name: 'groupName', type: 'string' }
							    ],
								cache: false,
								root: 'results',
								datatype: 'json',
								
								beforeprocessing: function (data) {
					    			sourceParty.totalrecords = data.TotalRows;
								},
								filter: function () {
					   				// update the grid and send a request to the server.
					   				$(\"#jqxGridOwnerParty\").jqxGrid('updatebounddata');
								},
								sort: function () {
					  				$(\"#jqxGridOwnerParty\").jqxGrid('updatebounddata');
								},
								sortcolumn: 'partyId',
	               				sortdirection: 'asc',
								type: 'POST',
								data: {
									noConditionFind: 'Y',
									conditionsFind: 'N',
								},
								pagesize:5,
								contentType: 'application/x-www-form-urlencoded',
								url: 'jqxGeneralServicer?sname=getFromParty',
								};
							    var dataAdapterParty = new $.jqx.dataAdapter(sourceParty,
							    {
							    	formatData: function (data) {
								    	if (data.filterscount) {
				                            var filterListFields = \"\";
				                            for (var i = 0; i < data.filterscount; i++) {
				                                var filterValue = data[\"filtervalue\" + i];
				                                var filterCondition = data[\"filtercondition\" + i];
				                                var filterDataField = data[\"filterdatafield\" + i];
				                                var filterOperator = data[\"filteroperator\" + i];
				                                filterListFields += \"|OLBIUS|\" + filterDataField;
				                                filterListFields += \"|SUIBLO|\" + filterValue;
				                                filterListFields += \"|SUIBLO|\" + filterCondition;
				                                filterListFields += \"|SUIBLO|\" + filterOperator;
				                            }
				                            data.filterListFields = filterListFields;
				                        }
				                         data.$skip = data.pagenum * data.pagesize;
				                         data.$top = data.pagesize;
				                         data.$inlinecount = \"allpages\";
				                        return data;
				                    },
				                    loadError: function (xhr, status, error) {
					                    alert(error);
					                },
					                downloadComplete: function (data, status, xhr) {
					                        if (!sourceParty.totalRecords) {
					                            sourceParty.totalRecords = parseInt(data[\"odata.count\"]);
					                        }
					                }, 
					                beforeLoadComplete: function (records) {
					                	for (var i = 0; i < records.length; i++) {
					                		if(typeof(records[i])==\"object\"){
					                			for(var key in records[i]) {
					                				var value = records[i][key];
					                				if(value != null && typeof(value) == \"object\" && typeof(value) != null){
					                					var date = new Date(records[i][key][\"time\"]);
					                					records[i][key] = date;
					                				}
					                			}
					                		}
					                	}
					                }
							    });
					            $(\"#jqxGridOwnerParty\").jqxGrid({
					            	width:400,
					                source: dataAdapterParty,
					                filterable: true,
					                virtualmode: true, 
					                sortable:true,
					                editable: false,
					                autoheight:true,
					                pageable: true,
					                rendergridrows: function(obj)
									{
										return obj.data;
									},
					                columns: [
					                  { text: 'partyId', datafield: 'partyId'},
					                  { text: 'partyTypeId', datafield: 'partyTypeId'},
					                  { text: 'firstName', datafield: 'firstName'},
					                  { text: 'lastName', datafield: 'lastName'},
					                  { text: 'groupName', datafield: 'groupName'}
					                ]
					            });
					            isSelectedOwner = false;
					            $(\"#jqxGridOwnerParty\").on('rowselect', function (event) {
		                                var args = event.args;
		                                var row = $(\"#jqxGridOwnerParty\").jqxGrid('getrowdata', args.rowindex);
		                                var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['partyId'] +'</div>';
		                                selectedownerPartyId = row.partyId;
		                                isSelectedOwner = true;
		                                editor.jqxDropDownButton('setContent', dropDownContent);
		                            });
		                      },
		                      geteditorvalue: function (row, cellvalue, editor) {
		                          // return the editor's value.
		                          editor.jqxDropDownButton(\"close\");
		                          if(!isSelectedOwner){
		                        	  selectedownerPartyId = cellvalue;
		                          }
		                          return selectedownerPartyId;
		                      }
					 },
					 { text: '${uiLabelMap.postToGlAccountId}', dataField: 'postToGlAccountId',width: '150px', editable: true, filterable: false, columntype: 'template',
						 createeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
	                            editor.append('<div id=\"jqxGridGlAccount\"></div>');
	                            editor.jqxDropDownButton({width: '150'});
	                            // prepare the data
							    var sourceGlAcc = { datafields: [
							      { name: 'glAccountId', type: 'string' },
							      { name: 'accountName', type: 'string' },
							      { name: 'glAccountTypeId', type: 'string' },
							      { name: 'glAccountClassId', type: 'string' }
							    ],
								cache: false,
								root: 'results',
								datatype: 'json',
								
								beforeprocessing: function (data) {
									sourceGlAcc.totalrecords = data.TotalRows;
								},
								filter: function () {
					   				// update the grid and send a request to the server.
					   				$('#jqxGridGlAccount').jqxGrid('updatebounddata');
								},
								sort: function () {
					  				$('#jqxGridGlAccount').jqxGrid('updatebounddata');
								},
								sortcolumn: 'glAccountId',
	               				sortdirection: 'asc',
								type: 'POST',
								data: {
									noConditionFind: 'Y',
									conditionsFind: 'N',
								},
								pagesize:5,
								contentType: 'application/x-www-form-urlencoded',
								url: 'jqxGeneralServicer?sname=JQListGlAccount',
								};
							    var dataAdapterGlAcc = new $.jqx.dataAdapter(sourceGlAcc,
							    {
							    	formatData: function (data) {
								    	if (data.filterscount) {
				                            var filterListFields = \"\";
				                            for (var i = 0; i < data.filterscount; i++) {
				                                var filterValue = data[\"filtervalue\" + i];
				                                var filterCondition = data[\"filtercondition\" + i];
				                                var filterDataField = data[\"filterdatafield\" + i];
				                                var filterOperator = data[\"filteroperator\" + i];
				                                filterListFields += \"|OLBIUS|\" + filterDataField;
				                                filterListFields += \"|SUIBLO|\" + filterValue;
				                                filterListFields += \"|SUIBLO|\" + filterCondition;
				                                filterListFields += \"|SUIBLO|\" + filterOperator;
				                            }
				                            data.filterListFields = filterListFields;
				                        }
				                         data.$skip = data.pagenum * data.pagesize;
				                         data.$top = data.pagesize;
				                         data.$inlinecount = \"allpages\";
				                        return data;
				                    },
				                    loadError: function (xhr, status, error) {
					                    alert(error);
					                },
					                downloadComplete: function (data, status, xhr) {
					                        if (!sourceGlAcc.totalRecords) {
					                        	sourceGlAcc.totalRecords = parseInt(data[\"odata.count\"]);
					                        }
					                }, 
					                beforeLoadComplete: function (records) {
					                	for (var i = 0; i < records.length; i++) {
					                		if(typeof(records[i])==\"object\"){
					                			for(var key in records[i]) {
					                				var value = records[i][key];
					                				if(value != null && typeof(value) == \"object\" && typeof(value) != null){
					                					var date = new Date(records[i][key][\"time\"]);
					                					records[i][key] = date;
					                				}
					                			}
					                		}
					                	}
					                }
							    });
					            $('#jqxGridGlAccount').jqxGrid({
					            	width:400,
					                source: dataAdapterGlAcc,
					                filterable: true,
					                virtualmode: true, 
					                sortable:true,
					                editable: false,
					                autoheight:true,
					                pageable: true,
					                rendergridrows: function(obj)
									{
										return obj.data;
									},
					                columns: [
					                  { text: 'glAccountId', datafield: 'glAccountId'},
					                  { text: 'accountName', datafield: 'accountName'},
					                  { text: 'glAccountTypeId', datafield: 'glAccountTypeId'},
					                  { text: 'glAccountClassId', datafield: 'glAccountClassId'}
					                ]
					            });
					            isSelectedGlAcc = false;
					            $('#jqxGridGlAccount').on('rowselect', function (event) {
		                                var args = event.args;
		                                var row = $('#jqxGridGlAccount').jqxGrid('getrowdata', args.rowindex);
		                                var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['glAccountId'] +'</div>';
		                                isSelectedGlAcc = true;
		                                selectedGlAcc = row.glAccountId;
		                                editor.jqxDropDownButton('setContent', dropDownContent);
		                            });
		                      },
		                      geteditorvalue: function (row, cellvalue, editor) {
		                          // return the editor's value.
		                          editor.jqxDropDownButton(\"close\");
		                          if(!isSelectedGlAcc){
		                        	  selectedGlAcc = cellvalue;
		                          }
		                          return selectedGlAcc;
		                      }
		             },
					 { text: '${uiLabelMap.fromDate}', dataField: 'fromDate',width: '150px', filterable: false, cellsformat: 'dd/MM/yyyy', columntype: 'template',
		            	 createeditor: function(row, cellvalue, editor){
		            		 editor.jqxDateTimeInput({ width: '150px', height: '25px'});
		            	 }
					 },
					 { text: '${uiLabelMap.thruDate}', dataField: 'thruDate',width: '150px', filterable: false, cellsformat: 'dd/MM/yyyy', columntype: 'template',
		            	 createeditor: function(row, cellvalue, editor){
		            		 editor.jqxDateTimeInput({ width: '150px', height: '25px'});
		            	 }
					 },
					 { text: '${uiLabelMap.isRefundable}', dataField: 'isRefundable', filterable: false, width: '150px', columntype: 'template',
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < isRefundableData.length; i++){
								 if(isRefundableData[i].isRefundable == value){
									 return '<span title=' + value + '>' + isRefundableData[i].description + '</span>'
								 }
							 }
							 return ;
						 },
						 createeditor: function(row, cellvalue, editor){
							 editor.jqxDropDownList({width: '150px', source: isRefundableData, displayMember: 'isRefundable', valueMember: 'isRefundable'});
						 }
					 },
					 { text: '${uiLabelMap.replenishPaymentId}', dataField: 'replenishPaymentId', filterable: false, width: '150px',},
					 { text: '${uiLabelMap.replenishLevel}', dataField: 'replenishLevel', filterable: false, width: '150px',},
					 { text: '${uiLabelMap.actualBalance}', dataField: 'actualBalance', filterable: false, width: '150px',},
					 { text: '${uiLabelMap.availableBalance}', dataField: 'availableBalance', filterable: false, width: '150px'}
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
                 	{ name: 'postToGlAccountId', type: 'string'},
                 	{ name: 'fromDate', type: 'date'},
                 	{ name: 'thruDate', type: 'date'},
                 	{ name: 'isRefundable', type: 'string'},
                 	{ name: 'replenishPaymentId', type: 'string'},
                 	{ name: 'replenishLevel', type: 'number'},
                 	{ name: 'actualBalance', type: 'number'},
                 	{ name: 'availableBalance', type: 'number'}
		 		 	]"/>
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false" filterable="true" alternativeAddPopup="alterpopupWindow" deleterow="true" editable="true" 
		 url="jqxGeneralServicer?sname=JQListFinAccount" id="jqxgrid" removeUrl="jqxGeneralServicer?sname=deleteFinAccount&jqaction=D" deleteColumn="finAccountId"
		 updateUrl="jqxGeneralServicer?sname=updateFinAccount&jqaction=U" editColumns="finAccountId;isRefundable;replenishPaymentId;replenishLevel(java.math.BigDecimal);fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);finAccountTypeId;statusId;finAccountName;finAccountCode;finAccountPin;currencyUomId;organizationPartyId;ownerPartyId;postToGlAccountId"
	/>