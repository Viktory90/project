<script type="text/javascript">
	<#assign partyNameList = delegator.findList("PartyNameView", null, null, null, null, false) />
	var dataPartyNameView = new Array();

	<#list partyNameList as item >
		var row = {};
		row['partyId'] = '${item.partyId?if_exists}';
		row['partyName'] = '${item.groupName?if_exists} ${item.firstName?if_exists} ${item.middleName?if_exists} ${item.lastName?if_exists}';
		dataPartyNameView[${item_index}] = row;
	</#list>
</script>
<#assign hasPerm = true>
<#assign addPerm = "false">
<#assign params="jqxGeneralServicer?sname=listFacilityJqx&facilityTypeId=WAREHOUSE">
<#if security.hasPermission("LOGISTICS_ADMIN", session) || security.hasPermission("FACILITY_ADMIN", session)>
	<#assign addPerm = "true">
<#elseif !security.hasPermission("LOGISTICS_VIEW", session) && !security.hasPermission("FACILITY_VIEW", session) && !security.hasPermission("FACILITY_ROLE_VIEW", session)>
	<#assign hasPerm = false>
</#if>
<#if security.hasPermission("LOGISTICS_CREATE", session) || security.hasPermission("FACILITY_CREATE", session)>
	<#assign addPerm = "true">
</#if>

<#if hasPerm = false>
	<div class="alert alert-danger">
		<strong>
			<i class="ace-icon fa fa-times"></i>
			${uiLabelMap.noViewPerm}
		</strong>
	</div>
<#else>
	<#assign dataField="[{ name: 'facilityId', type: 'string'},
						 { name: 'facilityName', type: 'string'},
						 { name: 'facilitySize', type: 'string'},
						 { name: 'facilitySizeUomId', type: 'string'},
						 { name: 'descriptionType', type: 'string'},
						 { name: 'facilityNameP', type: 'string'},
						 { name: 'facilityGroupName', type: 'string'},
						 { name: 'facilitySizeUomId', type: 'string'},
						 { name: 'partyManagerId', type: 'string'},
						 { name: 'partySKId', type: 'string'},
						 { name: 'uomDesc', type: 'string'},
						 { name: 'fromDate', type: 'date', other: 'Timestamp'},
						 { name: 'thruDate', type: 'date', other: 'Timestamp'},
						 { name: 'fromDateManager', type: 'date', other: 'Timestamp'},
						 { name: 'thruDateManager', type: 'date', other: 'Timestamp'},
						 { name: 'ownerPartyId', type: 'string'}
					   ]"/>
	<#assign columnlist="{ text: '${StringUtil.wrapString(uiLabelMap.facilityId)}', datafield: 'facilityId', width: 150, cellsrenderer:
					       function(row, colum, value){
						        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
				        		return '<span><a href=\"' + 'editFacilityInfo?facilityId=' + data.facilityId + '\">' + data.facilityId + '</a></span>';
				         }},
						 { text: '${StringUtil.wrapString(uiLabelMap.FormFieldTitle_facilityName)}', datafield: 'facilityName', width: 150},
						 { text: '${StringUtil.wrapString(uiLabelMap.facilityOwner)}', datafield: 'ownerPartyId', minwidth: 350,
						 	cellsrenderer: function (row, colum, value){
							 	for (var i = 0; i < dataPartyNameView.length; i++){
							 		if (dataPartyNameView[i].partyId == value){
							 			return '<span title=' + value + '>' + dataPartyNameView[i].partyName + '</span>';
							 		}
							 	}
						 	} 
						 },
						 { text: '${StringUtil.wrapString(uiLabelMap.ChildOfFacility)}', datafield: 'facilityNameP', width: 150},
						 { text: '${StringUtil.wrapString(uiLabelMap.FacilitySize)}', datafield: 'facilitySizeUomId', width: 150, cellsrenderer: function (row, columnfield, value, defaulthtml, columnproperties) {
						 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
						 		var tmpSize = data.facilitySize;
						 		var tmpUom = data.facilitySizeUomId;
						 		if(tmpSize==null){
						 			return '<span></span>';
						 		}else if(tmpUom==null){
						 			return '<span>' + data.facilitySize + '</span>';
						 		}
				        		return '<span>' + data.facilitySize + '&nbsp;' + data.uomDesc + '</span>';
						 }}
						"/>
	<div id='menuForFacility' style="display:none;">
		<ul>
		    <li><i class="fa-check"></i>&nbsp;&nbsp;${uiLabelMap.PhysicalInventory}</li>
		    <li><i class="fa-truck"></i>&nbsp;&nbsp;${uiLabelMap.Shipment}</li>
		</ul>
	</div>
	
	<@jqGridMinimumLib/>
	<script type="text/javascript">
		$.jqx.theme = "olbius";
		theme = $.jqx.theme;
		$("#menuForFacility").jqxMenu({ width: 150, autoOpenPopup: false, mode: 'popup', theme: theme});
		$("#menuForFacility").on('itemclick', function (event) {
			var data = $('#jqxgrid').jqxGrid('getRowData', $("#jqxgrid").jqxGrid('selectedrowindexes'));
			var tmpStr = $.trim($(args).text());
			if(tmpStr == '${StringUtil.wrapString(uiLabelMap.PhysicalInventory)}'){
				window.location.href = "FindPhysicalInventory?facilityId=" + data.facilityId;
			}else if(tmpStr == '${StringUtil.wrapString(uiLabelMap.Shipment)}'){
				window.location.href = "getShipmentByFacility?facilityId=" + data.facilityId;
			}
		});
	</script>
	<@jqGrid filtersimplemode="true" id="jqxgrid" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
		showtoolbar="true" addrow=addPerm deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" addrefresh="true"
		otherParams="partyIdFromName:M-org.ofbiz.party.party.PartyHelper(getPartyName)<partyIdFrom>"
		url=params addColumns="facilityId;primaryFacilityGroupId;facilityName;facilityTypeId;managerPartyId;ownerPartyId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);fromDateManager(java.sql.Timestamp);thruDateManager(java.sql.Timestamp);facilitySize(java.math.BigDecimal);facilitySizeUomId"
		createUrl="jqxGeneralServicer?sname=createFacilityJqx&jqaction=C" mouseRightMenu="true" contextMenuId="menuForFacility" jqGridMinimumLibEnable="false"
		showlist="true"
	/>	
	<div id="alterpopupWindow" style="display:none;">
	    <div>${uiLabelMap.ProductNewFacility}</div>
	    <div style="overflow: hidden;">
	        <table style="width:85%;">
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.FacilityName}</td>
		 			<td align="left"><input id="facilityName"/></td>
	    	 		<td align="right">${uiLabelMap.facilityId}</td>
		 			<td align="left"><input id="facilityId"/></td>
	 			</tr>
	 			<tr>
	 				<td align="right"></td>
		 			<td align="left"><div id="facilityTypeId"></div></td>
		 			<td align="right"></td>
		 			<td align="left"><div id="primaryFacilityGroupId"></div></td>
	    	 	</tr>
	    	 	<tr style="border-bottom:1px solid #CCC;margin:10px 40px 0px 40px;">
	    	 		<td colspan="4"></td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.Owner}</td>
		 			<td align="left"><div id="ownerPartyId"/></td>
		 			<td style="width:10px;" colspan="3"></td>
	 			</tr>
	 			<tr>
	    	 		<td align="right">${uiLabelMap.fromDate}</td>
		 			<td align="left"><div id="fromDate"></div></td>
		 			<td align="right">${uiLabelMap.thruDate}</td>
		 			<td align="left"><div id="thruDate"></div></td>
	    	 	</tr>
	    	 	<tr style="border-bottom:1px solid #CCC;margin:10px 40px 0px 40px;">
	    	 		<td colspan="4"></td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.Manager}</td>
		 			<td align="left"><div id="managerPartyId"/></td>
		 			<td colspan="3"></td>
	 			</tr>
	 			<tr>
	    	 		<td align="right">${uiLabelMap.fromDate}</td>
		 			<td align="left"><div id="fromDateManager"></div></td>
	    	 		<td align="right">${uiLabelMap.thruDate}</td>
		 			<td align="left"><div id="thruDateManager"></div></td>
	    	 	</tr>
	    	 	<tr style="border-bottom:1px solid #CCC;margin:10px 40px 0px 40px;">
	    	 		<td colspan="4"></td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.SquareFootage}</td>
		 			<td align="left"><input id="facilitySize"/></td>
	    	 		<td align="right">${uiLabelMap.facilitySizeUomId}</td>
		 			<td align="left"><div id="facilitySizeUomId"/></td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td colspan="4"></td>
	    	 	</tr>
	            <tr>
	            	<td></td>
	                <td align="right" colspan="2"><div style="width: 300px;"><input type="button" id="alterSave" value="${uiLabelMap.CommonSave}"/><input style="margin-left:10px;" id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div></td>
	            	<td></td>
	            </tr>
	        </table>
	    </div>
	</div>
	<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcombobox2.js"></script>
	<script type="text/javascript">
		$(document).ready(function () {
			var source =
	            {
	                datatype: "json",
	                datafields: [
	                    { name: 'partyId' },
	                    { name: 'groupName' }
	                ],
	                type: "POST",
	                root: "listParties",
	                contentType: 'application/x-www-form-urlencoded',
	                url: "facilityOwnerableList"
	            };
	            var dataAdapter = new $.jqx.dataAdapter(source,
	                {
	                    formatData: function (data) {
	                        if ($("#ownerPartyId").jqxComboBox('searchString') != undefined) {
	                            data.searchKey = $("#ownerPartyId").jqxComboBox('searchString');
	                            return data;
	                        }
	                    }
	                }
	            );
	            $("#ownerPartyId").jqxComboBox(
	            {
	                width: 208,
	                placeHolder: "${StringUtil.wrapString(uiLabelMap.wmparty)}",
	                dropDownWidth: 500,
	                height: 25,
	                source: dataAdapter,
	                remoteAutoComplete: true,
	                autoDropDownHeight: true,               
	                selectedIndex: 0,
	                displayMember: "groupName",
	                valueMember: "partyId",
	                renderer: function (index, label, value) {
	                	
	                    var item = dataAdapter.records[index];
	                    if (item != null) {
	                        var label = item.groupName + " (" + item.partyId + ")";
	                        return label;
	                    }
	                    return "";
	                },
	                renderSelectedItem: function(index, item)
	                {
	                    var item = dataAdapter.records[index];
	                    if (item != null) {
	                        var label = item.groupName;
	                        return label;
	                    }
	                    return "";   
	                },
	                search: function (searchString) {
	                    dataAdapter.dataBind();
	                }
	            });
			var sourceMNG =
	            {
	                datatype: "json",
	                datafields: [
	                    { name: 'partyId' },
	                    { name: 'firstName' },
	                    { name: 'middleName' },
	                    { name: 'lastName' },
	                    { name: 'fullName' }
	                ],
	                type: "POST",
	                root: "listParties",
	                contentType: 'application/x-www-form-urlencoded',
	                url: "facilityManagerableList"
	            };
	            var dataAdapterMNG = new $.jqx.dataAdapter(sourceMNG,
	                {
	                    formatData: function (data) {
	                        if ($("#managerPartyId").jqxComboBox('searchString') != undefined) {
	                            data.searchKey = $("#managerPartyId").jqxComboBox('searchString');
	                            return data;
	                        }
	                    }
	                }
	            );
	            $("#managerPartyId").jqxComboBox(
	            {
	                width: 208,
	                placeHolder: "${StringUtil.wrapString(uiLabelMap.wmparty)}",
	                dropDownWidth: 500,
	                height: 25,
	                source: dataAdapterMNG,
	                remoteAutoComplete: true,
	                autoDropDownHeight: true,               
	                selectedIndex: 0,
	                displayMember: "fullName",
	                valueMember: "partyId",
	                renderer: function (index, label, value) {
	                    var item = dataAdapterMNG.records[index];
	                    if (item != null) {
	                    	var label;
	                    	if(item.fullName != null){
	                    		label = item.firstName + "&nbsp;" + item.middleName + "&nbsp;" + item.lastName;
	                    	}else if(item.firstLast != null){
	                    		label = item.firstName + "&nbsp;" + lastName;
	                    	}else if(item.firstMiddle != null){
	                    		label = item.firstName + "&nbsp;" + item.middleName;
	                    	}else if(item.middleLast != null){
	                    		label = item.middleName + "&nbsp;" + item.lastName;
	                    	}
	                        label += " (" + item.partyId + ")";
	                        return label;
	                    }
	                    return "";
	                },
	                renderSelectedItem: function(index, item)
	                {
	                    var item = dataAdapterMNG.records[index];
	                    if (item != null) {
	                        var label;
	                    	if(item.fullName != null){
	                    		label = item.firstName + " " + item.middleName + " " + item.lastName;
	                    	}else if(item.firstLast != null){
	                    		label = item.firstName + " " + lastName;
	                    	}else if(item.firstMiddle != null){
	                    		label = item.firstName + " " + item.middleName;
	                    	}else if(item.middleLast != null){
	                    		label = item.middleName + " " + item.lastName;
	                    	}
	                        return label;
	                    }
	                    return "";   
	                },
	                search: function (searchString) {
	                    dataAdapterMNG.dataBind();
	                }
	            });
            });
	</script>
	<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/globalization/globalize.culture.vi-VN.js"></script>
	<script type="text/javascript">
		$.jqx.theme = 'olbius';  
		theme = $.jqx.theme;
//		var source = [<#list listFG as item>{key: '${item.facilityGroupId}', value: '${item.facilityGroupName}'}<#if item_index!=(listFG?size)>,</#if></#list>];
		var sourceUom = [<#list listUoms as item>{key: '${item.uomId}', value: '${item.description}'}<#if item_index!=(listUoms?size)>,</#if></#list>];
//		var sourceFT = [<#list listFT as item>{key: '${item.facilityTypeId}', value: '${item.description}'}<#if item_index!=(listFT?size)>,</#if></#list>];
		var tmpLcl = '${locale}';
		if(tmpLcl=='vi'){
			tmpLcl = 'vi-VN';
		}else{
			tmpLcl = 'en-EN';
		}
		$("#fromDate").jqxDateTimeInput({width: '208px', height: '25px', culture: tmpLcl});
		$("#thruDate").jqxDateTimeInput({width: '208px', height: '25px', culture: tmpLcl});
		$("#thruDate").jqxDateTimeInput("val",null);
		$("#fromDateManager").jqxDateTimeInput({width: '208px', height: '25px', culture: tmpLcl});
		$("#thruDateManager").jqxDateTimeInput({width: '208px', height: '25px', culture: tmpLcl});
		$("#thruDateManager").jqxDateTimeInput("val",null);
//		$("#primaryFacilityGroupId").jqxDropDownList({ source: source, displayMember: 'value', valueMember: 'key', theme: theme, selectedIndex: 1, width: '208', height: '25'});
//		$("#facilityTypeId").jqxDropDownList({ source: sourceFT, displayMember: 'value', valueMember: 'key', theme: theme, selectedIndex: 1, width: '208', height: '25'});
		$("#facilitySizeUomId").jqxDropDownList({ source: sourceUom, displayMember: 'value', valueMember: 'key', theme: theme, selectedIndex: 1, width: '208', height: '25'});
		$("#alterpopupWindow").jqxWindow({
	        width: 1000, height: 430, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme         
	    });
	
	    $("#alterCancel").jqxButton();
	    $("#alterSave").jqxButton();
	
	    // update the edited row when the user clicks the 'Save' button.
	    $("#alterSave").click(function () {
	    	var row;
	        row = { 
	        		fromDate:$('#fromDate').jqxDateTimeInput('getDate'),
	        		fromDateManager:$('#fromDateManager').jqxDateTimeInput('getDate'),
	        		ownerPartyId:$('#ownerPartyId').val(),
	        		primaryFacilityGroupId:'_NA_',
	        		managerPartyId:$('#managerPartyId').val(),
	        		facilityName:$('#facilityName').val(),
	        		facilityId:$('#facilityId').val(),
	        		facilitySize:$('#facilitySize').val(),
	        		facilitySizeUomId:$('#facilitySizeUomId').val(),
	        		facilityTypeId: 'WAREHOUSE',
	        		periodTypeId:$('#periodTypeId').val(),
	        		thruDate: $('#thruDate').jqxDateTimeInput('getDate'),            
	        		thruDateManager: $('#thruDateManager').jqxDateTimeInput('getDate')            
	        	  };
		   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	        // select the first row and clear the selection.
	        $("#jqxgrid").jqxGrid('clearSelection');                        
	        $("#jqxgrid").jqxGrid('selectRow', 0);  
	        $("#alterpopupWindow").jqxWindow('close');
	    });
	</script>
</#if>