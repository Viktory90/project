<script>
	<#assign roleTypes = delegator.findList("RoleType", null, null, null, null, false) />
	var roleTypeData = new Array();
	<#list roleTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['roleTypeId'] = '${item.roleTypeId?if_exists}';
		row['description'] = '${description?if_exists}';
		roleTypeData[${item_index?if_exists}] = row;
	</#list>
	
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
<#assign columnlist="{ text: '${uiLabelMap.roleTypeId}', dataField: 'roleTypeId', editable:false,
		              cellsrenderer: function(row, column, value){
		            	  for(i = 0; i < roleTypeData.length; i++){
		            		  if(roleTypeData[i].roleTypeId == value){
		            			  return '<span title' + value + '>' + roleTypeData[i].description +'</span>'
		            		  }
		            	  }
		            	  return ;
		               }
					 },
					 { text: '${uiLabelMap.partyId}', dataField: 'partyId', editable:false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < partyData.length; i++){
								 if(partyData[i].partyId == value){
									 return '<span title=' + value + '>' + partyData[i].description +'</span>'
								 }
							 }
							 return ;
						 }
					 },
					 { text: '${uiLabelMap.fromDate}', dataField: 'fromDate', editable:false, cellsformat: 'dd/MM/yyyy'},
					 { text: '${uiLabelMap.thruDate}', dataField: 'thruDate', editable:true, cellsformat: 'dd/MM/yyyy',width: '150', columntype: 'template',
						 createeditor: function(row, cellvalue, editor){
							 editor.jqxDateTimeInput({width: '150'});
						 }
					 }
					" />
<#assign dataField="[{ name: 'finAccountId', type: 'string' },
                 	{ name: 'roleTypeId', type: 'string' },
                 	{ name: 'partyId', type: 'string' },
					{ name: 'fromDate', type: 'date' },
					{ name: 'thruDate', type: 'date' }
		 		 	]"/>
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" filterable="false" alternativeAddPopup="alterpopupWindow" deleterow="true" editable="true" 
		 url="jqxGeneralServicer?sname=JQListFinAccountRole&finAccountId=${parameters.finAccountId}" id="jqxgrid" updateUrl="jqxGeneralServicer?sname=updateFinAccountRole&jqaction=U" editColumns="finAccountId;roleTypeId;partyId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp)"
		 createUrl="jqxGeneralServicer?sname=createFinAccountRole&jqaction=C&finAccountId=${parameters.finAccountId}" addColumns="roleTypeId;partyId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);finAccountId[${parameters.finAccountId}]"
		 addrefresh = "true" removeUrl="jqxGeneralServicer?sname=deleteFinAccountRole&jqaction=D&finAccountId=${parameters.finAccountId}" deleteColumn="finAccountId;partyId;roleTypeId;fromDate(java.sql.Timestamp)"
	/>

<!--HTML for add form -->
<div id="alterpopupWindow">
<div>${uiLabelMap.accCreateNew}</div>
<div style="overflow: hidden;">
    <table>
	 	<tr>
	 		<td align="right">${uiLabelMap.partyId}:</td>
 			<td align="left">
 				<div id="partyIdAdd">
 					<div id="jqxPartyGrid"/>
 				</div>
 			</td>
	 	</tr>
	 	<tr>
	 		<td align="right">${uiLabelMap.roleTypeId}:</td>
 			<td align="left"><div id="roleTypeIdAdd"></div></td>
	 	</tr>
	 	<tr>
	 		<td align="right">${uiLabelMap.fromDate}:</td>
 			<td align="left"><div id="fromDateAdd"/></td>
	 	</tr>
	 	<tr>
	 		<td align="right">${uiLabelMap.thruDate}:</td>
 			<td align="left"><div id="thruDateAdd"/></td>
	 	</tr>
        <tr>
            <td align="right"></td>
            <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
        </tr>
    </table>
</div>
</div>
<script>
	//Create theme
	$.jqx.theme='olbius';
	theme = $.jqx.theme;
	
	//Create Window popup
	$('#alterpopupWindow').jqxWindow({width: 500, height: 300, autoOpen: false, cancelButton: $('#alterCancel'), modalOpacity: 0.7});
	
	//Create partyId
	var sourceP =
	{
			datafields:
				[
				 { name: 'partyId', type: 'string' },
				 { name: 'partyTypeId', type: 'string' },
				 { name: 'firstName', type: 'string' },
				 { name: 'lastName', type: 'string' },
				 { name: 'groupName', type: 'string' }
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceP.totalrecords = data.TotalRows;
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
			url: 'jqxGeneralServicer?sname=getFromParty',
	};
	var dataAdapterP = new $.jqx.dataAdapter(sourceP);
	$("#partyIdAdd").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxPartyGrid").jqxGrid({
		source: dataAdapterP,
		filterable: false,
		virtualmode: true, 
    	sortable:true,
    	theme: theme,
    	editable: false,
    	autoheight:true,
    	pageable: true,
    	rendergridrows: function(obj)
    	{
    		return obj.data;
    	},
    columns: [
      { text: '${uiLabelMap.partyId}', datafield: 'partyId'},
      { text: '${uiLabelMap.partyTypeId}', datafield: 'partyTypeId'},
      { text: '${uiLabelMap.firstName}', datafield: 'firstName'},
      { text: '${uiLabelMap.lastName}', datafield: 'lastName'},
      { text: '${uiLabelMap.groupName}', datafield: 'groupName'}
    ]
	});
	$("#jqxPartyGrid").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxPartyGrid").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['partyId'] +'</div>';
		$('#partyIdAdd').jqxDropDownButton('setContent', dropDownContent);
	});
	
	//Create roleType
	$('#roleTypeIdAdd').jqxDropDownList({width: 200, source: roleTypeData, selectedIndex: 0, valueMember: 'roleTypeId', displayMember: 'description', theme: theme});
	
	//Create fromDate
	$('#fromDateAdd').jqxDateTimeInput({width: '200', formatString: 'dd/MM/yyyy'});
	
	//Create thruDate
	$('#thruDateAdd').jqxDateTimeInput({width: '200', formatString: 'dd/MM/yyyy'});
	
	//Create button
	$('#alterSave').jqxButton({theme: theme});
	$('#alterCancel').jqxButton({theme: theme});
	
	$('#alterSave').click(function(){
		var row = {
				partyId: $('#partyIdAdd').val(),
				roleTypeId: $('#roleTypeIdAdd').val(),
				fromDate: $('#fromDateAdd').jqxDateTimeInput('getDate').getTime(),
				thruDate: $('#thruDateAdd').jqxDateTimeInput('getDate').getTime()
		};
		$('#jqxgrid').jqxGrid("addRow", null, row, 'first');
		$('#jqxgrid').jqxGrid("clearSelection");
		$('#alterpopupWindow').jqxWindow('close');
	});
</script>