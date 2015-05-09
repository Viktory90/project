<#assign dataFields = "[{name: 'partyId', type: 'string'},
						{name: 'emplName', type: 'string'},
						{name: 'currDept', type: 'string'},
						{name: 'emplPositionTypeId', type: 'string'},
						{name: 'totalParameters', type: 'number'}
						]" />
<script type="text/javascript" src="/hrolbius/js/formatCurrency.js"></script>						
<script type="text/javascript">
	var emplPosTypeArr = new Array();	
	<#list emplPosType as posType>
		var row = {};
		row["emplPositionTypeId"] = "${posType.emplPositionTypeId}";
		row["description"] = "${StringUtil.wrapString(posType.description)}";
		emplPosTypeArr[${posType_index}] = row;
	</#list>
	
	
	
	var dataParty = new Array();
	<#list listDepartment as department>
		var row = {};
		row["partyId"] = "${department.partyId}";
		row["groupName"] = "${StringUtil.wrapString(department.groupName?if_exists)}";
		dataParty[${department_index}] = row;
	</#list>
		 
	 
	<#assign columnlist = "{text: '${uiLabelMap.EmployeeId}', datafield: 'partyId', filterable: false, editable: false, cellsalign: 'left', width: 130},
							{text: '${uiLabelMap.EmployeeName}', datafield: 'emplName', filterable: false, editable: false, cellsalign: 'left', width: 150},
							{text: '${uiLabelMap.EmployeeCurrentDept}', datafield: 'currDept', filterable: true,editable: false, cellsalign: 'left', width: 200, 
								filtertype:'list',
								createfilterwidget: function(column, columnElement, widget){
									
									var sourcePartyGroup = {
								        localdata: dataParty,
								        datatype: 'array'
								    };		
									var filterBoxAdapter = new $.jqx.dataAdapter(sourcePartyGroup, {autoBind: true});
								    var dataSoureList = filterBoxAdapter.records;
								    //var selectAll = {'trainingTypeId': 'selectAll', 'description': '(Select All)'};
								    //dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
								    widget.jqxDropDownList({ source: dataSoureList,selectedIndex: -1, displayMember: 'groupName', valueMember : 'partyId', checkboxes: false, 
								    	dropDownHeight: 250, autoDropDownHeight: false, searchMode: 'containsignorecase', incrementalSearch: false, filterable:true,
										renderer: function (index, label, value) {
											for(i=0; i < dataParty.length; i++){
												if(dataParty[i].partyId == value){
													return dataParty[i].groupName;
												}
											}
										    return value;
										}
									});									
								}
							},
							{text: '${uiLabelMap.EmplPositionTypeId}',  datafield: 'emplPositionTypeId', filterable: false,editable: false,
								cellsalign: 'left', filtertype: 'checkedlist',
								cellsrenderer: function (row, column, value){
									for(var i = 0; i < emplPosTypeArr.length; i++){
										if(emplPosTypeArr[i].emplPositionTypeId == value){
											return '<div style=\"\">' + emplPosTypeArr[i].description + '</div>';		
										}
									}
								},
								createfilterwidget: function(column, columnElement, widget){
									var sourceEmplPosType = {
								        localdata: emplPosTypeArr,
								        datatype: 'array'
								    };		
									var filterBoxAdapter = new $.jqx.dataAdapter(sourceEmplPosType, {autoBind: true});
								    var dataSoureList = filterBoxAdapter.records;
								    //var selectAll = {'trainingTypeId': 'selectAll', 'description': '(Select All)'};
								    dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
								    widget.jqxDropDownList({ source: dataSoureList,  displayMember: 'description', valueMember : 'emplPositionTypeId', 
								    	height: '25px', autoDropDownHeight: false, searchMode: 'containsignorecase', incrementalSearch: true, filterable:false,
										renderer: function (index, label, value) {
											for(i=0; i < emplPosTypeArr.length; i++){
												if(emplPosTypeArr[i].emplPositionTypeId == value){
													return emplPosTypeArr[i].description;
												}
											}
										    return value;
										}
									});									
								}
							},
							{text: '${uiLabelMap.TotalParametersSet}', datafield: 'totalParameters', filterable: false,editable: false, cellsalign: 'right', width: '170px'}" />

$(document).ready(function () {
	
	jQuery("#jqxgrid").on('rowDoubleClick', function (event){
		var boundIndex = args.rowindex;
		var rowData = jQuery("#jqxgrid").jqxGrid('getrowdata', boundIndex);
		var partyId = rowData.partyId;
		jQuery.ajax({
			url: '<@ofbizUrl>getListParameterEmpl</@ofbizUrl>',
			type: 'POST',
			data: {partyId: partyId},
			async: true,
			success: function(data){
				jQuery("#listParameterEmpl").html(data);
			}
		});
		jQuery('#jqxParametersWindow').jqxWindow('setTitle', '${uiLabelMap.ListParametersOf} ' + rowData.emplName);
		jQuery("#jqxParametersWindow").jqxWindow('open');
	});
	jQuery("#jqxParametersWindow").jqxWindow({showCollapseButton: false, maxHeight: 500, autoOpen: false, theme: 'olbius',
											maxWidth: '80%', minHeight: 500,  height: 500, width: '80%', isModal: true});
	jQuery("#jqxParametersWindow").on('close', function (event) {
		jQuery("#listParameterEmpl").empty();
	});
});

function refreshAfterDelete(){
	$("#jqxgrid").jqxGrid('updatebounddata');
}
</script>				
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataFields columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" 
		 filterable="true" alternativeAddPopup="popupWindowAddPartyAttend" deleterow="false" editable="false" addrow="false"
		 url="jqxGeneralServicer?hasrequest=Y&sname=JQListEmplPayrollParameters" id="jqxgrid"
		 removeUrl="" deleteColumn="" updateUrl="" editColumns="" selectionmode="singlerow"
	/>		
<div class="row-fluid">
	<div class="span12">
		<div id="jqxParametersWindow">
			<div id="windowHeader">
				
			</div>
			<div style="overflow: hidden;" id="windowContent">
				<div id="listParameterEmpl">
					
				</div>
			</div>
		</div>
	</div>
</div>	