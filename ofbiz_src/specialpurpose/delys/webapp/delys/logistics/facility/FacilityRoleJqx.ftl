<@jqGridMinimumLib/>
<#assign addPerm = "false">
<#if security.hasPermission("LOGISTICS_CREATE", session) || security.hasPermission("FACILITY_CREATE", session) || security.hasPermission("FACILITY_ADMIN", session) || security.hasPermission("LOGISTICS_ADMIN", session)>
<#assign addPerm = "true">
</#if>
<#assign dataField="[{ name: 'partyId', type: 'string'},
					 { name: 'firstName', type: 'string'},
					 { name: 'middleName', type: 'string'},
					 { name: 'roleTypeId', type: 'string'},
					 { name: 'lastName', type: 'string'},
					 { name: 'description', type: 'string'},
					 { name: 'fromDate', type: 'date', other: 'Timestamp'},
					 { name: 'thruDate', type: 'date', other: 'Timestamp'}
				   ]"/>
<#assign columnlist="{ text: '${StringUtil.wrapString(uiLabelMap.faPartyId)}', datafield: 'partyId', minwidth: 100, editable: false},
					 { text: '${StringUtil.wrapString(uiLabelMap.faFullName)}', minwidth: 100, editable: false, cellsrenderer:
					       function(row, colum, value){
					        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					        var firstName = data.firstName;
					        var middleName = data.middleName;
					        var lastName = data.lastName;
					        if(firstName == null){
					        	firstName = \"\";
					        }
					        if(middleName == null){
					        	middleName = \"\";
					        }
					        if(lastName == null){
					        	lastName = \"\";
					        }
			        		return '<span>' + firstName + '&nbsp;' + middleName + '&nbsp;' + lastName + '</span>';
			         }},
			         { text: '${StringUtil.wrapString(uiLabelMap.faPerm)}', datafield: 'description',minwidth: 200, editable: false},
			         { text: '${StringUtil.wrapString(uiLabelMap.fromDate)}', datafield: 'fromDate', filtertype: 'range',cellsformat: 'dd/MM/yyyy', minwidth: 100, editable: false},
			         { text: '${StringUtil.wrapString(uiLabelMap.thruDate)}', columntype: 'datetimeinput', datafield: 'thruDate', filtertype: 'range',cellsformat: 'dd/MM/yyyy', minwidth: 100, editable: true,
			        	 validation: function (cell, value) {
			        		 var data = $('#jqxgrid').jqxGrid('getrowdata', cell.row);
			        		 if(value == null || value == ''){
			        			 return true;
			        		 }
			        		 if(data.fromDate.getTime() > value.getTime()){
			        			 return { result: false, message: \"${StringUtil.wrapString(uiLabelMap.faFromDateLTThruDate)}\" };
			        		 }
			        			 return true;
			             }
		        	 }
					"/>				   
<@jqGrid filtersimplemode="true" id="jqxgrid" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
	showtoolbar="true" addrow=addPerm deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true"
	url="jqxGeneralServicer?sname=facilityPartyDetailList&facilityId=${parameters.facilityId}" addColumns="fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);facilityId;partyId;roleTypeId"
	editColumns="fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);facilityId;partyId;roleTypeId"
	updateUrl="jqxGeneralServicer?sname=updateFacilityPartyDetail&jqaction=U&facilityId=${parameters.facilityId}&passParameters=true"
	createUrl="jqxGeneralServicer?sname=createFacilityPartyDetail&jqaction=C" jqGridMinimumLibEnable="false" addrefresh="true"
/>	
<div id="alterpopupWindow" style="display:none;">
	<div>${uiLabelMap.faNewPerm}</div>
	<div style="overflow: hidden;">
	    <table style="width:100%;">
		 	<tr>
		 		<td align="right">${uiLabelMap.Owner}</td>
	 			<td align="left"><div id="partyId"/></td>
	 			<td align="right">${uiLabelMap.roleTypeId}</td>
	 			<td align="left"><div id="roleTypeIdDiv"/></td>
			</tr>
			<tr>
		 		<td align="right">${uiLabelMap.fromDate}</td>
	 			<td align="left"><div id="fromDate"></div></td>
	 			<td align="right">${uiLabelMap.thruDate}</td>
	 			<td align="left"><div id="thruDate"></div></td>
		 	</tr>
	        <tr>
	        	<td></td>
	        	<td></td>
	            <td align="left"><div style="margin: 0px;"><input type="button" id="alterSave" value="${uiLabelMap.CommonSave}"/><input style="margin-left:10px;" id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div></td>
	        	<td></td>
	        </tr>
	    </table>
	</div>
</div>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcombobox.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator2.js"></script>
<script type="text/javascript">
	function expireRole(partyId, roleTypeId, fromDate){
		
	}
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
                url: "facilityManagerableList"
            };
            var dataAdapter = new $.jqx.dataAdapter(source,
                {
                    formatData: function (data) {
                        if ($("#partyId").jqxComboBox('searchString') != undefined) {
                            data.searchKey = $("#partyId").jqxComboBox('searchString');
                            return data;
                        }
                    }
                }
            );
            $("#partyId").jqxComboBox(
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
                        var label = item.groupName + "(" + item.partyId + ")";
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
            $('#alterpopupWindow').jqxValidator({
            	rules: 
        		[	{
	            		input: '#thruDate', message: '${StringUtil.wrapString(uiLabelMap.faFromDateLTThruDate)}', action: 'blur', rule: function (input, commit) {
		            		if(input.jqxDateTimeInput('getDate') == null){
		            			return true;
		            		}
		            		if(input.jqxDateTimeInput('getDate') < $('#fromDate').jqxDateTimeInput('getDate')){
		            			return false;
		            		}
		            		return true;
	            		}
					},
					{	input: '#partyId', message: '${StringUtil.wrapString(uiLabelMap.faRoleNotEmpty)}', action: 'blur', rule: function (input, commit) {
							if($('#partyId').val() == null || $('#partyId').val()==''){
								return false;
							}
							return true;
						}
					}
            	]
            });
        });
</script>
<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	var source = [<#list listRole as item>{key: '${item.roleTypeId}', value: '${item.description}'}<#if item_index!=(listRole?size)>,</#if></#list>];
	$("#fromDate").jqxDateTimeInput({width: '208px', height: '25px'});
	$("#thruDate").jqxDateTimeInput({width: '208px', height: '25px'});
	$("#thruDate").jqxDateTimeInput("val",null);
	
	$("#alterpopupWindow").jqxWindow({
	    width: 800, height: 190, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme         
	});
	$("#roleTypeIdDiv").jqxDropDownList({ source: source, displayMember: 'value', valueMember: 'key', theme: theme, selectedIndex: 1, width: '208', height: '25'});
	$("#alterCancel").jqxButton();
	$("#alterSave").jqxButton();
	
	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		var row;
	    row = { 
	    		fromDate:$('#fromDate').jqxDateTimeInput('getDate'),
	    		partyId:$('#partyId').val(),
	    		facilityId:'${parameters.facilityId}',
	    		roleTypeId:$('#roleTypeIdDiv').val(),
	    		thruDate: $('#thruDate').jqxDateTimeInput('getDate')      
	    	  };
	    if($('#alterpopupWindow').jqxValidator('validate')){
	    	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
		    // select the first row and clear the selection.
		    $("#jqxgrid").jqxGrid('clearSelection');                        
		    $("#jqxgrid").jqxGrid('selectRow', 0);  
	    	$("#alterpopupWindow").jqxWindow('close');
	    }
	});
</script>