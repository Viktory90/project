 <script type="text/javascript" src="/delys/images/js/import/miscUtil.js"></script>
 <script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>
<#assign dataField="[{ name: 'requirementId', type: 'string'},
					   { name: 'agreementId', type: 'string'},
					   { name: 'orderId', type: 'string'},
					   { name: 'containerId', type: 'string'},
					   { name: 'productStoreId', type: 'string'},
					   { name: 'facilityId', type: 'string'},
					   { name: 'contactMechId', type: 'string'},
					   { name: 'requiredByDate', type: 'date', other: 'Timestamp'},
					   { name: 'requirementDate',type: 'date', other: 'Timestamp'},
					   { name: 'statusId', type: 'string'},
					   { name: 'task', type: 'string'},
					   ]"/>

  <#assign columnlist="{ text: '${uiLabelMap.requirementId}', datafield: 'requirementId', width: 90, editable: false,
						  cellclassname: function (row, column, value, data) {
								    var mod = row % 2;
								    if(mod == 0){
								    	return 'green1';
								    }
								}						
						},
  						{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', width: 90, editable: false, cellsrenderer:
							   function(row, colum, value){
							        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							        var agreementId = data.agreementId;
							        var link = 'detailPurchaseAgreement?agreementId=' + agreementId;
							        return '<span><a href=\"' + link + '\">' + agreementId + '</a></span>';
  						},
  						cellclassname: function (row, column, value, data) {
	   					    var mod = row % 2;
	   					    if(mod == 0){
	   					    	return 'green1';
	   					    }
	   					}
						},
  						{ text: '${uiLabelMap.OrderId}', datafield: 'orderId', width: 90, editable: false,
							cellclassname: function (row, column, value, data) {
		   					    var mod = row % 2;
		   					    if(mod == 0){
		   					    	return 'green1';
		   					    }
		   					}
  						},
  						{ text: '${uiLabelMap.ContainerId}', datafield: 'containerId', width: 80, editable: false,
  							cellclassname: function (row, column, value, data) {
		   					    var mod = row % 2;
		   					    if(mod == 0){
		   					    	return 'green1';
		   					    }
		   					}
  						},
  						{ text: '${uiLabelMap.productStore}', datafield: 'productStoreId', width: 90, editable: false, filtertype: 'checkedlist', cellsrenderer:
							function(row, colum, value){
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								var productStoreId = data.productStoreId;
								var productStore = getProductStore(productStoreId);
								return '<span>' + productStore + '</span>';
						},
						cellclassname: function (row, column, value, data) {
	   					    var mod = row % 2;
	   					    if(mod == 0){
	   					    	return 'green1';
	   					    }
	   					},
						createfilterwidget: 
							function(row, column, editor){
							editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(productStore), displayMember: 'productStoreId', valueMember: 'productStoreId' ,
							    renderer: function (index, label, value) {
							    	if (index == 0) {
	                            		return value;
									}
								    return getProductStore(value);
							    } });
							editor.jqxDropDownList('checkAll');
						}
	   					},
  						{ text: '${uiLabelMap.facility}', datafield: 'facilityId', width: 90, editable: false, filtertype: 'checkedlist', cellsrenderer:
							function(row, colum, value){
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								var facilityId = data.facilityId;
								var facility = getFacility(facilityId);
								return '<span>' + facility + '</span>';
  						},
  						cellclassname: function (row, column, value, data) {
	   					    var mod = row % 2;
	   					    if(mod == 0){
	   					    	return 'green1';
	   					    }
	   					},
  						createfilterwidget: 
							function(row, column, editor){
  							editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(facility), displayMember: 'facilityId', valueMember: 'facilityId' ,
  	                            renderer: function (index, label, value) {
  	                            	if (index == 0) {
  	                            		return value;
  									}
  								    return getFacility(value);
  				                } });
							editor.jqxDropDownList('checkAll');
						}},
  						{ text: '${uiLabelMap.FacilityAddress}', datafield: 'contactMechId', width: 150, editable: false,
							cellclassname: function (row, column, value, data) {
		   					    var mod = row % 2;
		   					    if(mod == 0){
		   					    	return 'green1';
		   					    }
		   					}
  						},
  						{ text: '${uiLabelMap.RequiredByDate}', datafield: 'requiredByDate', width: 120, editable: false, filtertype: 'range', cellsformat: 'dd/MM/yyyy',
  							cellclassname: function (row, column, value, data) {
		   					    var mod = row % 2;
		   					    if(mod == 0){
		   					    	return 'green1';
		   					    }
		   					}
  						},
  						{ text: '${uiLabelMap.ReceiveDate}', datafield: 'requirementDate', width: 120, editable: false, filtertype: 'range', cellsformat: 'dd/MM/yyyy',
  							cellclassname: function (row, column, value, data) {
		   					    var mod = row % 2;
		   					    if(mod == 0){
		   					    	return 'green1';
		   					    }
		   					}
  						},
  						{ text: '${uiLabelMap.Status}', datafield: 'statusId', width: 120, editable: false, columntype: 'dropdownlist', filtertype: 'checkedlist', cellsrenderer:
							function(row, colum, value){
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								var statusId = data.statusId;
								var status = getStatus(statusId);
								return '<span>' + status + '</span>';
						},
						cellclassname: function (row, column, value, data) {
	   					    var mod = row % 2;
	   					    if(mod == 0){
	   					    	return 'green1';
	   					    }
	   					},
						createfilterwidget: 
							function(row, column, editor){
							editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(statusList), displayMember: 'statusId', valueMember: 'statusId' ,
	                            renderer: function (index, label, value) {
	                            	if (index == 0) {
	                            		return value;
									}
								    return getStatus(value);
				                } });
							editor.jqxDropDownList('checkAll');
							}},
							{ text: '${uiLabelMap.Task}', datafield: 'task', width: 150, align: 'center', editable: true, filterable: false,
			                	   cellsrenderer: function(row, colum, value){
			                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			                		   var statusId = data.statusId;
			                		   data = toString(data);
			                		   if (statusId == 'REQ_CREATED') {
			                			   return '<span><button class=\"btn btn-small btn-primary\" onclick=approvedClick(\"' + data + '\") >\' + \'<i class=\"icon-ok\"></i>${uiLabelMap.Approved}\' + \'</button></span>';
			                		   }
			                		   if (statusId == 'REQ_APPROVED') {
			                			   return '<span><button name=\"btn_APPROVED\" class=\"btn btn-small btn-primary\" onclick=sentClick(\"' + data + '\") >\' + \'<i class=\"icon-arrow-right\"></i>${uiLabelMap.CommonSend}\' + \'</button></span>';
			                		   }
			                		   if (statusId == 'REQ_ACCEPTED') {
			                			   return '<span><button class=\"btn btn-small btn-primary\" onclick=showCost() >\' + \'<i class=\"icon-edit\"></i>${uiLabelMap.CreateReceiptNote}\' + \'</button></span>';
			                		   }
			                		   return '';
			                	   },
			                	   cellclassname: function (row, column, value, data) {
				   					    var mod = row % 2;
				   					    if(mod == 0){
				   					    	return 'green1';
				   					    }
				   					}
			                },
						"/>

<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" initrowdetails="false"
					showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false"
						customcontrol1="icon-plus-sign open-sans@${uiLabelMap.CommonCreateNew}@editReceiptRequirement"
					url="jqxGeneralServicer?sname=JQGetListReceiptRequirements" updateUrl="jqxGeneralServicer?sname=updateAgreementStatus&jqaction=U"
					otherParams="containerId:S-getContainerID(orderId)<containerId>"
				/>
			          
    <div id="showPopup"></div>
  	<#assign productStore = delegator.findList("ProductStore", null, null, null, null, false) />
  	<#assign facility = delegator.findList("Facility", null, null, null, null, false) />
  	<#assign status = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "REQUIREMENT_STATUS"), null, null, null, false) />
  	
  	
  	<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>
  	<script type="text/javascript">
  		function showCost(){
  			var rowindex = $('#jqxgrid').jqxGrid('getselectedrowindex');
  			var data = $('#jqxgrid').jqxGrid('getrowdata', rowindex);
  			var orderId = data.orderId;
  			var reqDate = new Date(data.requirementDate).getTime();
  			var reqByDate = new Date(data.requiredByDate).getTime();
//  			console.log(rr);
//  			data = toString(data);
//  			$('#orderIdInp').val(data.orderId);
//	  		$('#window').jqxWindow('open');
  			$.ajax({
  				url: 'showOrderCost?orderId='+orderId+'&organizationPartyId=IMPORT_ADMIN&requirementId='+data.requirementId+'&agreementId='+data.agreementId+'&containerId='+data.containerId+'&productStoreId='+data.productStoreId+'&facilityId='+data.facilityId+'&contactMechId='+data.contactMechId+'&requiredByDate='+reqByDate+'&requirementDate='+reqDate+'&statusId='+data.statusId,
  		    	type: "POST",
  		    	data: {},
  		    	async: false,
  		    	success: function(data2) {
  		    		$("#showPopup").html(data2);
  		    		$('#window').jqxWindow('open');
  		    	},
  		    	error: function(data2){
  		    	}
  				});
  		}
  		
//  			$('#window').jqxWindow({
//                showCollapseButton: false, theme:'olbius', resizable: true,
//                isModal: true, autoOpen: false, height: 500, width: '90%', maxWidth: '90%'
//            });
  			
//			$('#window').on('open', function (event) {
//  				initGridgridCost();
//  				var tmpS = $("#gridCost").jqxGrid('source');
//  				var curFacilityId = $("#orderIdInp").val();
//  				tmpS._source.url = "jqxGeneralServicer?sname=JQGetCostForOrder&orderId=" + curFacilityId;
//  				$("#gridCost").jqxGrid('source', tmpS);
//  			});
			
//				$("#windowContent").jqxPanel({ width: "100%", height: 500});
				
  	</script>
    <script>
    function fixSelectAll(dataList) {
	    	var sourceST = {
			        localdata: dataList,
			        datatype: "array"
			    };
			var filterBoxAdapter2 = new $.jqx.dataAdapter(sourceST, {autoBind: true});
			var uniqueRecords2 = filterBoxAdapter2.records;
			uniqueRecords2.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
			return uniqueRecords2;
    }
    function toString(myJSObject) {
    	myJSObject = JSON.stringify(myJSObject);
    	myJSObject = myJSObject.replaceAll('"', "'");
    	return myJSObject;
	}
    function approvedClick(data) {
    	data = data.toJson();
    	executeTask(data, "approveReceiptRequirement");
	}
    function sentClick(data) {
    	data = data.toJson();
    	data.partyIdTo = "LOG_SPECIALIST";
    	data.action = "getReceiptRequirements";
    	data.sendMessage = "${uiLabelMap.NewReceiptRequirement}";
    	executeTask(data, "sendReceiptRequirement");
    }
    function createReceiptNoteClick(data) {
    	data = data.toJson();
    	data.requiredByDate = new Date(data.requiredByDate).toTimeStamp();
    	data.requirementDate = new Date(data.requirementDate).toTimeStamp();
    	executeTask(data, "createReceiptFromRequirement");
    }
    function executeTask(data, url) {
    	var requirementId;
    	jQuery.ajax({
			url: url,
			type: "POST",
			data: data,
			success: function(res) {
				requirementId = res["requirementId"];
	        }
		}).done(function() {
			if (requirementId != undefined || requirementId != "") {
				var message = "<div id='contentMessages' class='alert alert-success' onclick='hiddenClick()'>" +
				"<p id='thisP'>" + '${uiLabelMap.DAUpdateSuccessful}' + "</p></div>";
		    	$("#myAlert").html(message);
			}else {
				message = "<div id='contentMessages' class='alert alert-error' onclick='hiddenClick()'>" +
    			"<p id='thisP'>" + '${uiLabelMap.DAUpdateError}' + "</p></div>";
    	    	$("#myAlert").html(message);
			}
			$("#clearfilteringbuttonjqxgrid").click();
		});
	}
    function hiddenClick() {
    	$('#contentMessages').css('display','none');
    }
    
  	var productStore = new Array();
	<#if productStore?exists>
		<#list productStore as item>
			var row = {};
			row['storeName'] = '${item.storeName?if_exists}';
			row['productStoreId'] = '${item.productStoreId?if_exists}';
			productStore[${item_index}] = row;
		</#list>
	</#if>
	function getProductStore(productStoreId) {
		if (productStoreId != null) {
			for ( var x in productStore) {
				if (productStoreId == productStore[x].productStoreId) {
					return productStore[x].storeName;
				}
			}
		} else {
			return "";
		}
	}
	
	var facility = new Array();
	<#if facility?exists>
		<#list facility as item>
			var row = {};
			row['facilityName'] = '${item.facilityName?if_exists}';
			row['facilityId'] = '${item.facilityId?if_exists}';
			facility[${item_index}] = row;
		</#list>
	</#if>
	function getFacility(facilityId) {
		if (facilityId != null) {
			for ( var x in facility) {
				if (facilityId == facility[x].facilityId) {
					return facility[x].facilityName;
				}
			}
		} else {
			return "";
		}
	}
	
	var statusList = new Array();
	<#if status?exists>
		<#list status as item>
			var row = {};
			row['description'] = '${item.get("description", locale)?if_exists}';
			row['statusId'] = '${item.statusId?if_exists}';
			statusList[${item_index}] = row;
		</#list>
	</#if>
	function getStatus(statusId) {
		if (statusId != null) {
			for ( var x in statusList) {
				if (statusId == statusList[x].statusId) {
					return statusList[x].description;
				}
			}
		} else {
			return "";
		}
	}
	</script>
	<style type="text/css">
		
	</style>
	
	<style>     
    .green1 {
        color: #black;
        background-color: #F0FFFF;
    }
    .yellow1 {
        color: black\9;
        background-color: yellow\9;
    }
    .red1 {
        color: black\9;
        background-color: #e83636\9;
    }
    .green1:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected), .jqx-widget .green:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected) {
        color: black;
        background-color: #F0FFFF;
    }
    .yellow1:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected), .jqx-widget .yellow:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected) {
        color: black;
        background-color: yellow;
    }
    .red1:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected), .jqx-widget .red:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected) {
        color: black;
        background-color: #e83636;
    }
    
    #pagerjqxgridDetail{
    	display: none;
    }
</style>