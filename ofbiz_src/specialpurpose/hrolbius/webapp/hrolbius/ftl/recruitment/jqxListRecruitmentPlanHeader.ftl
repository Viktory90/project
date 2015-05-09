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
		row['description'] = "${description}";
		partyData[${item_index}] = row;
	</#list>

	//Prepare for status data
	<#assign listStatus = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "RPH_STATUS"), null, null, null, false)>
	var statusData = new Array();
	<#list listStatus as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description)>
		row['statusId'] = '${item.statusId}';
		row['description'] = "${description}";
		statusData[${item_index}] = row;
	</#list>

	//Set status data for head of department
	var isHeadOfDept = false;
	var isAdmin = false;
	var isCeo = false;
	<#if !Static["com.olbius.util.PartyUtil"].isAdmin(userLogin.partyId, delegator) && !Static["com.olbius.util.PartyUtil"].isCEO(delegator, userLogin)>
		isHeadOfDept = true;
		var tmpCreateStatusData = new Array();
		var index = 0;
		for(var i = 0; i < statusData.length; i++){
			if('RPH_SCHEDULED' == statusData[i].statusId || 'RPH_REJECTED' == statusData[i].statusId || 'RPH_INIT' == statusData[i].statusId){
				tmpCreateStatusData[index] = statusData[i];
				index++;
			}
		}
	<#elseif Static["com.olbius.util.PartyUtil"].isAdmin(userLogin.partyId, delegator)>
		isAdmin = true;
		var tmpCreateStatusData = new Array();
		var index = 0;
		for(var i = 0; i < statusData.length; i++){
			if('RPH_ACCEPTED' == statusData[i].statusId || 'RPH_REJECTED' == statusData[i].statusId){
				tmpCreateStatusData[index] = statusData[i];
				index++;
			}
		}
	<#elseif Static["com.olbius.util.PartyUtil"].isCEO(delegator, userLogin)>
		isCeo = true
		var tmpCreateStatusData = new Array();
		var index = 0;
		for(var i = 0; i < statusData.length; i++){
			if('RPH_APPROVED' == statusData[i].statusId || 'RPH_REJECTED' == statusData[i].statusId){
				tmpCreateStatusData[index] = statusData[i];
				index++;
			}
		}
	</#if>
	
	 <#assign listEmplPositionTypes = delegator.findList("DepPositionTypeView", null, null, null, null, false) >
	    var positionTypeData = new Array();
		<#list listEmplPositionTypes as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description?if_exists) />
			row['partyId'] = '${item.deptId}';
			row['emplPositionTypeId'] = '${item.emplPositionTypeId}';
			row['description'] = "${description}";
			positionTypeData[${item_index}] = row;
		</#list>
		
		var deptColumnFilter = function () {
	         var filtergroup = new $.jqx.filter();
	         var filter_or_operator = 1;
	         var filtervalue = '${parameters.partyId?if_exists}';
	         var filtercondition = 'contains';
	         var filter = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
	         filtergroup.addfilter(filter_or_operator, filter);
	         return filtergroup;
	     }();
	     
	     var yearColumnFilter = function () {
	         var filtergroup = new $.jqx.filter();
	         var filter_or_operator = 1;
	         var filtervalue = '${parameters.year?if_exists}';
	         var filtercondition = 'contains';
	         var filter = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
	         filtergroup.addfilter(filter_or_operator, filter);
	         return filtergroup;
	     }();
</script>

<#assign dataField="[{ name: 'partyId', type: 'string' },
					 { name: 'year', type: 'string' },
					 { name: 'scheduleDate', type: 'date', other: 'Timestamp' },
					 { name: 'reason', type: 'string' },
					 { name: 'statusId', type: 'string' }
					 ]"/>

<#assign columnlist="{ text: '${uiLabelMap.Department}', datafield: 'partyId', editable: false, filter: deptColumnFilter,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < partyData.length; i++){
								if(value == partyData[i].partyId){
									return '<span title=' + value + '>' + partyData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						}
					 },
                     { text: '${uiLabelMap.Year}', datafield: 'year', width: 150, editable: false, filter: yearColumnFilter},
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
					    },
					    cellbeginedit: function (row, datafield, columntype) {
					    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					    	if (isHeadOfDept && (data.statusId == 'RPH_PROPOSED' || data.statusId == 'RPH_APPROVED' || data.statusId == 'RPH_ACCEPTED'))
					            return false;
					    	if (isAdmin && (data.statusId == 'RPH_APPROVED'))
					            return false;
					    }
                     },
                     { text: '${uiLabelMap.reason}', datafield: 'reason', width: 150, editable: true}
					 "/>
<#if Static["com.olbius.util.PartyUtil"].isCEO(delegator, userLogin)>
	<#assign addrow = "false">
<#else>
	<#assign addrow = "true">
</#if>
<@jqGrid id="jqxgrid" addType="popup" editable="true" addrefresh="true" filtersimplemode="true" addrow=addrow showtoolbar="true" clearfilteringbutton="true"
		 url="jqxGeneralServicer?sname=JQGetListRecruitmentPlanHeader" dataField=dataField columnlist=columnlist alternativeAddPopup="alterpopupNewRPH"
		 createUrl="jqxGeneralServicer?sname=createRecruitmentPlanHeader&jqaction=C" addColumns="partyId;year;scheduleDate(java.sql.Timestamp);reason"
		 initrowdetails="true" initrowdetailsDetail="initrowdetails" updateUrl="jqxGeneralServicer?sname=updateRecruitmentPlanHeader&jqaction=U" editColumns="partyId;year;statusId;reason"
		/>
<#--====================================================Create new popup window==========================================================-->
<div class="row-fluid">
	<div class="span12">
		<div id="alterpopupNewRPH">
			<div id="windowHeaderNewRPH">
	            <span>
	               ${uiLabelMap.AddRecruitmentPlan}
	            </span>
	        </div>
	        <div style="overflow: hidden; padding: 15px" id="windowContentNewPlan">
			<div class="basic-form form-horizontal" style="margin-top: 10px">
				<form name="createNewRPH" id="createNewRPH">
				<div class="row-fluid" >
					<div class="span12">
						<div class="control-group no-left-margin">
							<label class="control-label">${uiLabelMap.Department}:</label>
							<div class="controls">
								<div id="partyIdLabel" ></div>
								<input id="partyIdAdd" name="partyId" type="hidden"></input>
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">${uiLabelMap.Year}:</label>
							<div class="controls">
								<div id="yearLabel"></div>
								<input id="yearAdd" name="year" type="hidden"></input>
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">${uiLabelMap.reason}:</label>
							<div class="controls">
								<input id="reasonAdd" ></input>
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">${uiLabelMap.sheduleDate}:</label>
							<div class="controls">
								<div id="scheduleDate" ></div>
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">&nbsp</label>
							<div class="controls">
								<button type="button" class="btn btn-mini btn-success" id="alterSave"><i class="icon-ok"></i>${uiLabelMap.CommonSubmit}</button>
								<button type="button" class="btn btn-mini btn-danger" id="alterCancel">${uiLabelMap.CommonCancel}&nbsp;<i class="icon-remove"></i></button>
							</div>
						</div>
					</div>
				</div>
				</form>
			</div>
	        </div>
		</div>
	</div>
</div>
<#--====================================================/Create new popup window==========================================================-->
<script>
	/*
	 * Prepare data for popup window
	 * */
	$(document).ready(function(){
		//Create partyId
		<#assign partyId = Static["com.olbius.util.PartyUtil"].getOrgByManager(userLogin, delegator) >
		<#assign partyName = Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, partyId, false)>
		jQuery("#partyIdLabel").text('${StringUtil.wrapString(partyName)}');
		$("#partyIdAdd").val('${partyId}');

		//Create year
		<#assign currentYear = Static["com.olbius.util.DateUtil"].getCurrentYear() >
		jQuery("#yearLabel").text('${currentYear}');
		$("#yearAdd").val('${currentYear}');

		//Create scheduleDate
		jQuery("#scheduleDate").jqxDateTimeInput({ width: '200px', height: '25px',  formatString: 'd', theme: theme });
		
		//Create reason
		jQuery("#reasonAdd").jqxInput({ width: '195px',theme: theme });

		//Create window
		$("#alterpopupNewRPH").jqxWindow({
	        showCollapseButton: false, maxHeight: 550, autoOpen: false, maxWidth: "50%", minHeight: 300, minWidth: '40%', width: "80%", isModal: true,
	        theme:theme, collapsed:false
	    });

		//update the edited row when the user clicks the 'Save' button.
	    $("#alterSave").click(function () {
		var row;
	        row = {
				scheduleDate:$('#scheduleDate').jqxDateTimeInput('getDate').getTime(),
				partyId:$("#partyIdAdd").val(),
				year:$("#yearAdd").val(),
				reason:$("#reasonAdd").val(),
			  };
		   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	        // select the first row and clear the selection.
	        $("#jqxgrid").jqxGrid('clearSelection');
	        $("#jqxgrid").jqxGrid('selectRow', 0);
	        $("#alterpopupNewRPH").jqxWindow('close');
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
	var cuUrl = "createOrUpdateRecruitmentPlan";
	var idGrid = "jqxgridDetail_" + id;
	var cellEditable = true;
	var isHrmAdmin = false;
	<#if Static["com.olbius.util.PartyUtil"].isAdmin(userLogin.partyId, delegator)>
		isHrmAdmin = true;
	</#if>
	var isManaged = false;
	<#assign department = Static["com.olbius.util.PartyUtil"].getOrgByManager(userLogin.partyId, delegator) />
	if(partyId == '${department}'){
		isManaged = true;
	}
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
		url: getUrl,
	        updaterow: function (rowid, rowdata, commit) {
	        console.log(rowid,rowdata,commit);
			var data = {};
			rowdata['partyId'] = partyId;
			rowdata['year'] = year;
			$.ajax({
	                url: cuUrl,
	                type: "POST",
	                cache: false,
	                datatype: 'json',
	                data: rowdata,
	                success: function (data, status, xhr) {
	                	if(data.responseMessage == "error"){
	                		commit(false);
	                	}else{
	                		commit(true);
	                	}
	                	jqxgridDetail.jqxGrid('updatebounddata');
	                }
	            });
	        }
	};
	var isShowtoolbar = false;
	var editable = false;
	if((statusId == 'RPH_INIT' && !isHrmAdmin && isManaged) || (statusId == 'RPH_ACCEPTED' && isHrmAdmin)){
		isShowtoolbar = true;
		editable = true;
	}
	var dataAdapter = new $.jqx.dataAdapter(detailSource);
	if(jqxgridDetail && jqxgridDetail.length){
		jqxgridDetail.jqxGrid(
	         {
	             width: '95%',
	             autoHeight: true,
	             source: dataAdapter,
	             showtoolbar: isShowtoolbar,
	             selectionmode: 'singlecell',
	             pageable: true,
	             editable: editable,
	             rendertoolbar: function (toolbar) {
                    var me = this;
                    var container = $("<div style='margin: 5px;'></div>");
                    toolbar.append(container);
                	container.append('<input id="addrowbutton" type="button" class="icon-plus-sign" value="${uiLabelMap.accAddNewRow}" />');
                    $("#addrowbutton").jqxButton();
                    // create new row.
                    $("#addrowbutton").on('click', function () {
                    	jqxgridDetail.jqxGrid('addrow', null, {});
                    });
	             },
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