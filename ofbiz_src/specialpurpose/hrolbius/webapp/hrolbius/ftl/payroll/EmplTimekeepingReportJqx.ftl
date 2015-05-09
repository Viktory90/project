<div id="popupWindowTimekeeping">
    <div>${uiLabelMap.CommonEdit}</div>
    <div style="overflow: hidden;">
        <table>
       	 	<tr>
       	 		<td align="center">${uiLabelMap.EmployeeId}:</td>
       	 		<td align="left"><input id="partyId" readonly="readonly"/>
    	 	</tr>
    	 	<tr>
    	 		<td align="center">${uiLabelMap.CommonDate}:</td>
       	 		<td align="center"><input id="dateTimeId" readonly="readonly"/>
    	 	</tr>
       	 	<tr>
       	 		<td align="center">${uiLabelMap.StartTime}:</td>
      	 		<td align="left"><div id="startTime"></div></td>
     	 	</tr>
     	 	<tr>
     	 		<td align="center">${uiLabelMap.EndTime}:</td>
       	 		<td align="left"><div id="endTime"></div></td>
       	 	</tr>
            <tr>
                <td align="center"></td>
                <td style="padding-top: 10px;" align="right">
                 <input style="margin-right: 5px;" type="button" id="Save" value="${uiLabelMap.CommonSave}" />
                 <input id="Cancel" type="button" value="${uiLabelMap.CommonCancel}" />
                </td>
            </tr>
        </table>
    </div>
</div>


	
<#assign dataField = "[{ name: 'partyName', type: 'string'},
                      {name: 'partyId', type:'string'}"/>
<#assign columnlist = "{text: '${uiLabelMap.EmployeeName}', datafield: 'partyName', width: 100, cellsalign: 'center', editable: false, pinned: true},
						{text: '${uiLabelMap.EmployeeId}', datafield: 'partyId', width: 100,cellsalign: 'center', pinned: true, editable: false,cellsrenderer: function (row, column, value) {
							var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							if (data && data.partyId){
        						return '<a style = \"margin-left: 10px\" href=' + 'EmployeeProfile?partyId=' + data.partyId + '>' +  data.partyId + '</a>'
    						}
    						}
    					}"/>
<#assign editColumns = ""/>	
<#--<!-- createfilterwidget: function(column, columnElement, widget){
	var keepingTypeList = new Array();
	keepingTypeList = {'keepingTypeId': 'EMPTY', 'description': 'V'};
	keepingTypeList[1] = {'keepingTypeId': 'LATE', 'description': 'M'};
	keepingTypeList[2] = {'keepingTypeId': 'EARLY', 'description': 'S'};
	var sourceKeepingType = {
        localdata: keepingTypeList,
        datatype: \"array\"
    };
    var filterBoxAdapter = new $.jqx.dataAdapter(sourceKeepingType, {autoBind: true});
    var dataSoureList = filterBoxAdapter.records; 
    dataSoureList.splice(0, 0, '(Select All)');
    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'keepingTypeId', valueMember : 'keepingTypeId', 
			renderer: function (index, label, value) {
			for(i=0;i < keepingTypeList.length; i++){
				if(keepingTypeList[i].keepingTypeId == value){
					return keepingTypeList[i].description;
				}
			}
		    return value;
		}
	});												
} -->	
<div style="background-color: "></div>
<style>     
#EmplTimeKeeping .green {
    color: black\9;
    background-color: #b6ff00\9;
}
#EmplTimeKeeping .yellow {
    color: black\9;
    background-color: yellow\9;
}
#EmplTimeKeeping .red {
    color: black\9;
    background-color: #FF6600;
}
#EmplTimeKeeping .green:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected), .jqx-widget .green:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected) {
    color: black;
    background-color: #b6ff00;
}
#EmplTimeKeeping .yellow:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected), .jqx-widget .yellow:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected) {
    color: black;
    background-color: yellow;
}
#EmplTimeKeeping .red:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected), .jqx-widget .red:not(.jqx-grid-cell-hover):not(.jqx-grid-cell-selected) {
    color: black;
    background-color: #e83636;
}
#EmplTimeKeeping .white{
	color: black;
    background-color: #ffffff;
}
</style>
<div style="color: green;"></div>
<script type="text/javascript">	
var keepingTypeList = new Array();
keepingTypeList[0] = {'keepingTypeId': 'V', 'description': 'V'};
keepingTypeList[1] = {'keepingTypeId': 'M', 'description': 'M'};
keepingTypeList[2] = {'keepingTypeId': 'S', 'description': 'S'};
keepingTypeList[3] = {'keepingTypeId': 'X', 'description': 'X'};
var cellclass = function (row, columnfield, value) {
    if (value == "V") {
        return 'red';
    }
    else if (value == "M") {
        return 'yellow';
    }
    else if(value == "S"){
		return 'green';    	
    }else if(value == "X"){
    	return 'white';
    }
}

<#list dateOfMonth as date>
	<#assign dataField = dataField + ","/>
	<#assign dataField =  dataField + "{name: 'date_" + date_index + "', type: 'string'}"/>
	<#assign dataField = dataField + ","/>	
	<#assign dataField =  dataField + "{name: 'dateValue_" + date_index + "', type: 'D'}"/>
	<#assign columnlist = columnlist + ","/>
	<#assign columnlist = columnlist +  "{text:'" + date?string["dd EEE"] +"', dataField: 'date_"+ date_index +"', width: 60, cellsalign: 'center', filtertype: 'checkedlist', 
								cellsrenderer: function (row, column, value){
									if (value == \"V\") {
								        return \"<div><b style='color: red;'>\"+ value +\"</b></div>\";
								    }
								    else if (value == \"M\") {
								        return \"<div><b style='color: #6633CC;'>\"+ value +\"</b></div>\";
								    }
								    else if(value == \"S\"){
										return \"<div><b style='color: blue;''>\"+ value +\"</b></div>\";    	
								    }else if(value == \"X\"){
								    	return \"<div><b style='color: #C0C0C0;'>\"+ value +\"</b></div>\";
								    }else{
								    	return value
								    }
								},
								createfilterwidget: function(column, columnElement, widget){
									var sourceKeepingType = {
								        localdata: keepingTypeList,
								        datatype: \"array\"
								    };
								    var filterBoxAdapter = new $.jqx.dataAdapter(sourceKeepingType, {autoBind: true});
								    var dataSoureList = filterBoxAdapter.records;
								    var selectAll = {'keepingTypeId': 'selectAll', 'description': '(Select All)'};
								    dataSoureList.splice(0, 0, '(Select All)');
								    //console.log(dataSoureList);
								    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'keepingTypeId', valueMember : 'keepingTypeId', 
											renderer: function (index, label, value) {
											for(i=0;i < keepingTypeList.length; i++){
												if(keepingTypeList[i].keepingTypeId == value){
													return keepingTypeList[i].description;
												}
											}
										    return value;
										}
									});
								}				
							}"/>
	<#assign columnlist = columnlist + ","/>
	<#assign columnlist = columnlist + "{text: 'dateValue', dataField: 'dateValue_"+ date_index +"', hidden: true}"/>
	<#assign editColumns = editColumns + "date"+ date_index + ";">
</#list> 
</script>

<#assign dataField = dataField + ",{name: 'TotalTimeKeeping', type: 'string'}"/>
<#assign dataField = dataField + ",{name: 'TotalDayWorking', type: 'string'}"/>                     
<#assign dataField = dataField + "]"/>
<#assign columnlist = columnlist + ",{text: '${uiLabelMap.TotalTimeKeeping}', datafield:'TotalTimeKeeping', width: 150, cellsalign: 'center', filterable: false}"/>
<#assign columnlist = columnlist + ",{text: '${uiLabelMap.TotalDayWorking}', datafield:'TotalDayWorking', width: 110, cellsalign: 'center', filterable: false}"/>

<div id="EmplTimeKeepingSearchPopup">
	<div id="windowHeader">
		<span>
			${uiLabelMap.CommonAdvanceSearch}
		</span>
	</div>	
	<div id="windowContent">
		<form action="<@ofbizUrl>EmplTimekeepingReport</@ofbizUrl>" class="basic-form form-horizontal" id="SearchEmplTimekeepingReport">
			<div class="control-group no-left-margin ">
				<label for="" class="control-label">${uiLabelMap.ViewResultEmplTimekeeping}</label>  
				<div class="controls">
					<div class="row-fluid">
						<div class="span12">
							<div class="row-fluid">
								<div class="span3" style="margin: 0; padding: 0">
									<label style="display: inline;">${uiLabelMap.CommonMonth}</label>
								</div>
								<div class="span3" style="margin: 0">
									<input type="text" style="margin-bottom:0px;" name="month" class="input-mini" id="month" />
								</div>
								
								<div class="span3" style="margin: 0; padding: 0">
									<label style="display: inline;">${uiLabelMap.CommonYear}</label>
								</div>
								<div class="span3" style="margin: 0">
									<input type="text" style="margin-bottom:0px;"class="input-mini" id="year" name="year"/>
								</div>
							</div>		
						</div>
					</div>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label>
					&nbsp;
				</label>
				<div class="controls">
					<button type="submit" id="submitAdvanceSearch" class="btn btn-small btn-primary">
						${uiLabelMap.CommonFind}
					</button>
				</div>
			</div>
		</form>
	</div>
</div>	
<div class="row-fluid">
	<div id="appendNotification">
		<div id="updateNotification">
			<span id="notificationText"></span>
		</div>
	</div>	
</div>
<div id="EmplTimeKeeping">
<@jqGrid url="jqxGeneralServicer?month=${month}&year=${year}&hasrequest=Y&sname=JQEmplListTimeKeeping" dataField=dataField columnlist=columnlist 
	filtersimplemode="true" sortable="false" showtoolbar="true" editable="false" id="jqxgrid" clearfilteringbutton="true"
	customcontrol1="icon-search@${uiLabelMap.CommonAdvanceSearch}@#javascript:void(0)@showPopup()"/>
	
	<#assign currentYear = currentDateTime.get(Static["java.util.Calendar"].YEAR)>
	<#assign currentMonth = currentDateTime.get(Static["java.util.Calendar"].MONTH) + 1>
	<#assign minYear = currentYear-10>
	<#assign maxYear = currentYear+10>
</div>	
<script type="text/javascript">

function showPopup(){
	$("#EmplTimeKeepingSearchPopup").jqxWindow("open");
}
$(document).ready(function () {
	var editRow = -1;
	var cellEdit = -1;
	var theme = 'olbius';
	var dateTimeValue;
	jQuery("#jqxgrid").jqxGrid('pinColumn', 'partyId');
	jQuery("#jqxgrid").jqxGrid('pinColumn', 'partyName');
	
	jQuery('#month').ace_spinner({value:${currentMonth},min:1,max:12,step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
	jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
	
	$('#EmplTimeKeepingSearchPopup').jqxWindow({
        showCollapseButton: true, maxHeight: 150, autoOpen: false, maxWidth: "40%", minHeight: 150, minWidth: "40%", height: 150, width: "40%", isModal: true, 
        theme:theme, collapsed:false,
        initContent: function () {            	
            //jQuery('#trainingCourseDetailWindow').jqxWindow('focus');
            //jQuery('#trainingCourseDetailWindow').jqxWindow('close');
        }
    });
	
	
	jQuery("#jqxgrid").on("cellDoubleClick", function (event){
		rowid = event.args.rowindex;
		editRow = rowid;
		cellEdit = event.args.datafield;
		if(cellEdit != "partyName" && cellEdit != "partyId" && cellEdit !="TotalTimeKeeping" && cellEdit != "TotalDayWorking"){
			var indexOfChar = cellEdit.indexOf("_");
			var index = cellEdit.substring(indexOfChar);
			var dateValueColumnDatafield = "dateValue" + index;
			var partyId = jQuery('#jqxgrid').jqxGrid('getcellvalue', rowid, 'partyId');
			dateTimeValue = jQuery('#jqxgrid').jqxGrid('getcellvalue', rowid, dateValueColumnDatafield);
		  	jQuery('#partyId').val(partyId);
		  	var tempDate = new Date(dateTimeValue);
		  	var startDateTime = new Date(tempDate);
		  	var endDateTime = new Date(tempDate);
		  	jQuery("#dateTimeId").val(tempDate.getDate() + "/" + (tempDate.getMonth() + 1) + "/" + tempDate.getFullYear());
		  	jQuery.ajax({
				url: "<@ofbizUrl>getPartyAttendance</@ofbizUrl>",
				type:"POST",
				async: false,
				data: {partyId: partyId, dateKeeping: dateTimeValue},
				success: function(data){
					if(data._EVENT_MESSAGE_ == "success"){
						if(data.startTime){
							var startTimeArr = data.startTime.split(":");
							startDateTime.setHours(startTimeArr[0]);
							startDateTime.setMinutes(startTimeArr[1]);
						}
						if(data.endTime){
							var endTimeArr = data.endTime.split(":");
							endDateTime.setHours(endTimeArr[0]);
							endDateTime.setMinutes(endTimeArr[1]);
						}
					}
				}
			});
		  	$("#startTime").jqxDateTimeInput({ width: 200, height: '25px', formatString: 'HH:mm:ss', showCalendarButton: false, value: startDateTime});
			$("#endTime").jqxDateTimeInput({ width: 200, height: '25px', formatString: 'HH:mm:ss', showCalendarButton: false, value: endDateTime});
		  	$('#popupWindowTimekeeping').jqxWindow('open');
		}
		
	});
	$("#popupWindowTimekeeping").jqxWindow({
		minWidth: 580, minHeight: 230, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#Cancel"), modalOpacity: 0.01, theme: theme          
    });
	$("#updateNotification").jqxNotification({
        width: "100%", position: "top-left", opacity: 1, appendContainer: "#appendNotification",
        autoOpen: false, animationOpenDelay: 800, autoClose: false
    });
	$("#Cancel").jqxButton({ theme: theme });
    $("#Save").jqxButton({ theme: theme });
    $("#Save").click(function () {
    	if (editRow >= 0) {
    		var startTime = $("#startTime").jqxDateTimeInput('value');
    		var endTime = $("#endTime").jqxDateTimeInput('value');
    		var dateValue = dateTimeValue;
    		var partyId = $("#partyId").val();
    		//console.log(endTime.getTime());
    		jQuery.ajax({
    			url: "<@ofbizUrl>updateEmplAttendanceTracker</@ofbizUrl>",
    			type: "POST",
    			data: {partyId: partyId, startTime: startTime.getTime(), endTime: endTime.getTime(), dateAttendance: dateValue},
    			success: function(data){    				
    				if(data._EVENT_MESSAGE_){
    					if(data.newStatus){
    						$("#jqxgrid").jqxGrid('setcellvalue', editRow, cellEdit, data.newStatus);	
    					}
    				}else{
    					$("#notificationText").html(data._ERROR_MESSAGE_);
    					$("#updateNotification").jqxNotification('open');
    				}
    			}
    		}); 
    		$("#popupWindowTimekeeping").jqxWindow('hide');
    	}
    });
});

</script>	

