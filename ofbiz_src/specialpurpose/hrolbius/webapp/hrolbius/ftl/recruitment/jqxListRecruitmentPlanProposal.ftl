<script>
	//Create theme
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	
	//Prepare for party data
	<#assign listParties = delegator.findList("PartyNameView", null, null, null, null, false) />
	var partyData = new Array();
	<#list listParties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.groupName?if_exists) + " " + StringUtil.wrapString(item.firstName?if_exists) + " " + StringUtil.wrapString(item.middleName?if_exists) + " " + StringUtil.wrapString(item.lastName?if_exists)>
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description}';
		partyData[${item_index}] = row;
	</#list>

	//Prepare for status data
	<#assign listStatus = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "RPH_STATUS"), null, null, null, false)>
	var statusData = new Array();
	<#list listStatus as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description)>
		row['statusId'] = '${item.statusId}';
		row['description'] = '${description}';
		statusData[${item_index}] = row;
	</#list>

	 <#assign listEmplPositionTypes = delegator.findList("DepPositionTypeView", null, null, null, null, false) >
	    var positionTypeData = new Array();
		<#list listEmplPositionTypes as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description?if_exists) />
			row['partyId'] = '${item.deptId}';
			row['emplPositionTypeId'] = '${item.emplPositionTypeId}';
			row['description'] = '${description}';
			positionTypeData[${item_index}] = row;
		</#list>
</script>

<#assign dataField="[{ name: 'partyId', type: 'string' },
					 { name: 'year', type: 'number' },
					 { name: 'scheduleDate', type: 'date', other: 'Timestamp' },
					 { name: 'statusId', type: 'string' }
					 ]"/>

<#assign columnlist="{ text: '${uiLabelMap.Department}', datafield: 'partyId', editable: false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < partyData.length; i++){
								if(value == partyData[i].partyId){
									return '<span title=' + value + '>' + partyData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						}
					 },
                     { text: '${uiLabelMap.Year}', datafield: 'year', width: 150, editable: false},
                     { text: '${uiLabelMap.sheduleDate}', datafield: 'scheduleDate', width: 150, cellsformat:'d', filtertype: 'range', editable: false},
                     { text: '${uiLabelMap.Status}', datafield: 'statusId', width: 150, editable: true, columntype: 'dropdownlist',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(value == statusData[i].statusId){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						},
						createeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
					        editor.jqxDropDownList({source: tmpCreateStatusData, valueMember: 'statusId', displayMember:'description' });
					    }
                     }
					 "/>

<@jqGrid addrow="false" id="jqxgrid" addType="popup" selectionmode="checkbox" editable="true" filtersimplemode="true" addrow="false" showtoolbar="true" clearfilteringbutton="true"
		 url="jqxGeneralServicer?sname=JQGetListRecruitmentPlanProposal" dataField=dataField columnlist=columnlist alternativeAddPopup="alterpopupNewRPH"
		 createUrl="jqxGeneralServicer?sname=createRecruitmentPlanHeader&jqaction=C" addColumns="partyId;year;scheduleDate(java.sql.Timestamp)"
		 initrowdetails="true" initrowdetailsDetail="initrowdetails" updateUrl="jqxGeneralServicer?sname=updateRecruitmentPlanHeader&jqaction=U" editColumns="partyId;year;statusId"
		 mouseRightMenu="true" contextMenuId="contextMenu"
		/>
<#--====================================================Create new context menu==========================================================-->
<div id='contextMenu'>
	<ul>
	    <li>${uiLabelMap.HRCommonProposal}</li>
	</ul>
</div>
<#--====================================================/Create new context menu==========================================================-->
<script>
	$(document).ready(function(){
	    //Create Context Menu
	    var contextMenu = $("#contextMenu").jqxMenu({ width: 200, height: 58, autoOpenPopup: false, mode: 'popup'});
        // handle context menu clicks.
        $("#contextMenu").on('itemclick', function (event) {
        	var selectedIndexs = $('#jqxgrid').jqxGrid('getselectedrowindexes');
        	var paraPRP = {};
        	for(var i = 0; i < selectedIndexs.length; i++){
        		var row = {};
        		var rowData = $("#jqxgrid").jqxGrid("getrowdata", selectedIndexs[i]);
        		paraPRP['partyId_o_' + i] = rowData.partyId;
        		paraPRP['year_o_' + i] = rowData.year;
        		paraPRP['statusId_o_' + i] = 'RPH_PROPOSED';
        	}
        	//update status proposal
        	$.ajax({
                url: "proposeRecruitmentPlan",
                type: "POST",
                cache: false,
                datatype: 'json',
                data: paraPRP,
                success: function (data, status, xhr) {
	                if(data.responseMessage == "error"){
	                	$('#jqxNotificationjqxgrid').jqxNotification({ template: 'error'});
                    	$("#jqxNotificationjqxgrid").text(data.errorMessage);
                    	$("#jqxNotificationjqxgrid").jqxNotification("open");
	                }else{
	                	var messData = {};
	                	<#assign ceoId = Static["com.olbius.util.PartyUtil"].getCEO(delegator)>
	                	var ceoId = '${ceoId}';
	                	messData['partyId'] = ceoId;
	                	messData['header'] = 'Phê duyệt kế hoạch tuyển dụng năm ' + rowData.year;
	                	messData['action'] = 'FindRecruitmentPlan';
	                	messData['state'] = 'open';
	                	messData['targetLink'] = 'year='+rowData.year;
	                	$.ajax({
	                		url: "createNotification",
	                        type: "POST",
	                        cache: false,
	                        datatype: 'json',
	                        data: messData
	                	});
	                	$('#jqxNotificationjqxgrid').jqxNotification({ template: 'info'});
                    	$("#jqxNotificationjqxgrid").text("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
                    	$("#jqxNotificationjqxgrid").jqxNotification("open");
	                }
                }
            });
        });
	});

    //Create row detail
    var initrowdetails = function (index, parentElement, gridElement, datarecord) {
	var jqxgridDetail = $($(parentElement).children()[0]);
	var partyId = datarecord.partyId;
	var year = datarecord.year;
	var statusId = datarecord.statusId;
	var id = datarecord.uid.toString();
	var getUrl = "getRecruitmentPlanDetail";
	var idGrid = "jqxgridDetail_" + id;
	var cellEditable = true;
	$(jqxgridDetail).attr('id', idGrid);
	var detailSource = {
			datafields: [
					{name: 'emplPositionTypeId', type: 'string'},
			            {name: 'firstMonth', type: 'number'},
			            {name: 'secondMonth', type: 'number'},
			            {name: 'thirdMonth', type: 'number'},
			            {name: 'fourthMonth', type: 'number'},
			            {name: 'fifthMonth', type: 'number'},
			            {name: 'sixthMonth', type: 'number'},
			            {name: 'seventhMonth', type: 'number'},
			            {name: 'eighthMonth', type: 'number'},
			            {name: 'ninthMonth', type: 'number'},
			            {name: 'tenthMonth', type: 'number'},
			            {name: 'eleventhMonth', type: 'number'},
			            {name: 'twelfthMonth', type: 'number'}
					],
		cache: false,
		datatype: 'json',
		type: 'POST',
		data: {partyId: partyId, year: year},
		url: getUrl
	};
	var dataAdapter = new $.jqx.dataAdapter(detailSource);
	if(jqxgridDetail && jqxgridDetail.length){
		jqxgridDetail.jqxGrid(
	         {
	             width: '95%',
	             autoHeight: true,
	             source: dataAdapter,
	             showtoolbar: false,
	             selectionmode: 'singlecell',
	             pageable: true,
	             editable: false,
	             columnsresize: true,
	             columnsresize: true,
	             theme: theme,
	             columns: [
	               { text: '${uiLabelMap.Position}', datafield: 'emplPositionTypeId', columntype: 'dropdownlist', width: '15%',
                       createeditor: function (row, value, editor) {
						   var source = new Array();
						   var index = 0;
						   for(var i = 0; i < positionTypeData.length; i++){
							   if(positionTypeData[i].partyId == partyId){
								   source[index] = positionTypeData[i];
								   index++;
							   }
						   }
						   editor.jqxDropDownList({ source: source, displayMember: 'description', autoDropDownHeight: true, dropDownWidth: 250, valueMember: 'emplPositionTypeId' });
                       },
                       cellbeginedit: function(row, datafield, columntype, value){
								if(value && value.length) return false;
                       },
					   cellsrenderer: function(row, column, value){
							for(var i = 0; i < positionTypeData.length; i++){
								if(value == positionTypeData[i].emplPositionTypeId){
									return '<span title=' + value + '>' + positionTypeData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
					   }
	               },
	               { text: '${uiLabelMap.FirstMonth}', datafield: 'firstMonth', width: '7%' },
	               { text: '${uiLabelMap.SecondMonth}', datafield: 'secondMonth', width: '7%' },
	               { text: '${uiLabelMap.ThirdMonth}', datafield: 'thirdMonth', width: '7%' },
	               { text: '${uiLabelMap.FourthMonth}', datafield: 'fourthMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.FifthMonth}', datafield: 'fifthMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.SixthMonth}', datafield: 'sixthMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.SeventhMonth}', datafield: 'seventhMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.EighthMonth}', datafield: 'eighthMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.NinthMonth}', datafield: 'ninthMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.TenthMonth}', datafield: 'tenthMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.EleventhMonth}', datafield: 'eleventhMonth', minwidth: '7%' },
	               { text: '${uiLabelMap.TwelfthMonth}', datafield: 'twelfthMonth', minwidth: '7%' }
	           ]
	         });
        }

    }
</script>