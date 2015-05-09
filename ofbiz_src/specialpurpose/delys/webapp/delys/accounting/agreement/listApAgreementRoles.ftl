<script>
	<#assign roleTypeList = delegator.findList("RoleType",  Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("roleTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["AGENT", "CUSTOMER", "SUPPLIER", "CONSUMER", "DISTRIBUTOR", "BUYER",  "VENDOR", "CONTRUCTOR", "PARTNER", "PERSON_ROLE", "ORGANIZATION_ROLE"]), null, null, null, false) />
	var rtData = new Array();
	<#list roleTypeList as item >
		var row = {};
		row['roleTypeId'] = '${item.roleTypeId?if_exists}';
		row['description'] = '${item.description?if_exists}';
		rtData[${item_index}] = row;
	</#list>
</script>

<#assign dataField="[{ name: 'partyId', type: 'string' },
					 { name: 'roleTypeId', type: 'string'}
					 ]"/>
<#assign columnlist="{ text: '${uiLabelMap.accAgreementPartyId}', width: '50%', datafield: 'partyId'},
					 { text: '${uiLabelMap.roleTypeId}', datafield: 'roleTypeId'}"/>
<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow" editable="false"
		 url="jqxGeneralServicer?sname=JQListAgreementRoles&agreementId=${parameters.agreementId}"
		 createUrl="jqxGeneralServicer?sname=createAgreementRole&jqaction=C&agreementId=${parameters.agreementId}"
		 removeUrl="jqxGeneralServicer?sname=deleteAgreementRole&jqaction=D&agreementId=${parameters.agreementId}"
		 addColumns="agreementId[${parameters.agreementId}];partyId;roleTypeId"
		 deleteColumn="agreementId[${parameters.agreementId}];partyId;roleTypeId"
		 />
<div id="alterpopupWindow" style="display:none;">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accAgreementPartyId}:</td>
	 			<td align="left">
	 				<div id="partyIdAdd">
						<div style="border-color: transparent;" id="jqxPartyGrid"></div>	 				
	 				</div>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.roleTypeId}:</td>
	 			<td align="left">
	 				<div id="roleTypeIdAdd">
	 				</div>
	 			</td>
    	 	</tr>
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script>
	//Create theme
 	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	var sourcePG = { datafields: [
						      { name: 'partyId', type: 'string' },
						      { name: 'partyTypeId', type: 'string' },
						      { name: 'lastName', type: 'string' },
						      { name: 'firstName', type: 'string' },
						      { name: 'groupName', type: 'string' },
						    ],
				cache: false,
				root: 'results',
				datatype: "json",
				updaterow: function (rowid, rowdata) {
					// synchronize with the server - send update command   
				},
				beforeprocessing: function (data) {
				    sourcePG.totalrecords = data.TotalRows;
				},
				filter: function () {
				   // update the grid and send a request to the server.
				   $("#jqxPartyGrid").jqxGrid('updatebounddata');
				},
				pager: function (pagenum, pagesize, oldpagenum) {
				  // callback called when a page or page size is changed.
				},
				sort: function () {
				  $("#jqxPartyGrid").jqxGrid('updatebounddata');
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
				url: 'jqxGeneralServicer?sname=JQGetListParties',
			};
			
    var dataAdapterPG = new $.jqx.dataAdapter(sourcePG,
    {
    	autoBind: true,
    	formatData: function (data) {
    		if (data.filterscount) {
                var filterListFields = "";
                for (var i = 0; i < data.filterscount; i++) {
                    var filterValue = data["filtervalue" + i];
                    var filterCondition = data["filtercondition" + i];
                    var filterDataField = data["filterdatafield" + i];
                    var filterOperator = data["filteroperator" + i];
                    filterListFields += "|OLBIUS|" + filterDataField;
                    filterListFields += "|SUIBLO|" + filterValue;
                    filterListFields += "|SUIBLO|" + filterCondition;
                    filterListFields += "|SUIBLO|" + filterOperator;
                }
                data.filterListFields = filterListFields;
            }
            return data;
        },
        loadError: function (xhr, status, error) {
            alert(error);
        },
        downloadComplete: function (data, status, xhr) {
                if (!sourcePG.totalRecords) {
                    sourcePG.totalRecords = parseInt(data['odata.count']);
                }
        }
    });			
			
	$("#partyIdAdd").jqxDropDownButton({ width: 215, height: 25});
	$("#jqxPartyGrid").jqxGrid({
	width:400,
	source: dataAdapterPG,
	filterable: true,
	virtualmode: true, 
	showfilterrow: true,
	sortable:true,
	editable: false,
	autoheight:true,
	pageable: true,
	rendergridrows: function(obj)
	{	
		return obj.data;
	},
	columns: 
	[
		{ text: '${uiLabelMap.accPartyId}', datafield: 'partyId', width:'20%'},
		{ text: '${uiLabelMap.accPartyTypeId}', datafield: 'partyTypeId', width:'20%'},
		{ text: '${uiLabelMap.accFirstName}', datafield: 'lastName', width:'20%'},
		{ text: '${uiLabelMap.accLastName}', datafield: 'firstName', width:'20%'},
		{ text: '${uiLabelMap.accGroupName}', datafield: 'groupName'}
	]
	});
	$("#jqxPartyGrid").on('rowselect', function (event) {
                var args = event.args;
                var row = $("#jqxPartyGrid").jqxGrid('getrowdata', args.rowindex);
                var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['partyId'] + '</div>';
                $("#partyIdAdd").jqxDropDownButton('setContent', dropDownContent);
            });
            
    //Create roleType
    $("#roleTypeIdAdd").jqxDropDownList({ selectedIndex: 0, source: rtData, displayMember: "description", valueMember: "roleTypeId", width: 215, height: 25});
    
	//Create Popup Add
	$("#alterpopupWindow").jqxWindow({
        width: 600, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7          
    });
    $("#alterCancel").jqxButton();
    $("#alterSave").jqxButton();

    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
    	var row;
        row = { 
        		partyId:$('#partyIdAdd').val(), 
        		roleTypeId:$('#roleTypeIdAdd').val()
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
        // select the first row and clear the selection.
        $("#jqxgrid").jqxGrid('clearSelection');                        
        $("#jqxgrid").jqxGrid('selectRow', 0);  
        $("#alterpopupWindow").jqxWindow('close');
    });        
</script>