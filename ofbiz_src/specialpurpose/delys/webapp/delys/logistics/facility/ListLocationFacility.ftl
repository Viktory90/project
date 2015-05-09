<@jqGridMinimumLib/>
<script type="text/javascript" src="/aceadmin/jqw/scripts/demos.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/demos/sampledata/generatedata.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdatatable.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtreegrid2.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>

<script>
	<#assign locationFacilityTypeList = delegator.findList("LocationFacilityType", null, null, null, null, false) />
	var locationFacilityTypeData = new Array();
	<#list locationFacilityTypeList as locationFacilityType>
		var row = {};
		row['locationFacilityTypeId'] = "${locationFacilityType.locationFacilityTypeId}";
		row['description'] = "${locationFacilityType.description}";
		locationFacilityTypeData[${locationFacilityType_index}] = row;
	</#list>

	var arrayLocationFacilityTypeInLocationFacilityTypeData = [];
	for(var i in locationFacilityTypeData){
		arrayLocationFacilityTypeInLocationFacilityTypeData.push(locationFacilityTypeData[i].locationFacilityTypeId);
	}
</script>

<div>
	<div id="contentNotificationCreateLocationFacilityTypeSuccess" style="width:100%">
	</div>
	<div id="contentNotificationCheckDescription" style="width:100%">
	</div>
	<div id="contentNotificationCreateLocationFacilityTypeDeleteSuccess" style="width:100%">
	</div>
	<div id="contentNotificationCreateLocationFacilityTypeUpdateSuccess" style="width:100%">
	</div>
	<div id="contentNotificationCreateLocationFacilityTypeError" style="width:100%">
	</div>
	<div id="contentNotificationCreateLocationFacilityTypeUpdateError" style="width:100%">
	</div>
	<div id="contentNotificationCreateLocationFacilityTypeUpdateErrorParent" style="width:100%">
	</div>
	<div id="contentNotificationSelectTreeGird" style="width:100%">
	</div>
	<div>
		<input type="button" value='${uiLabelMap.DScreateNew}' id="createLocationFacilityType" ></input>
		<input type="button" value='${uiLabelMap.DSDeleteLocationFacilityType}' id="deleteLocationFacilityType" ></input>
	</div>
	<div id="jqxTreeGirdLocationFacilityType">
	</div>
</div>


<div id="alterpopupWindow" class="hide">
	<div>${uiLabelMap.AddLocationTypeInFacility}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div id="contentNotificationCreateLocationFacilityType" style="width:100%">
					</div>
					<div id="contentNotificationCreateLocationFacilityTypeExits" style="width:100%">
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.LocationType}:</div>
						<div class="controls">
							<input id="locationFacilityTypeId"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.ParentLocationFacilityTypeId}: </div>
						<div class="controls">
							<div id="parentLocationFacilityTypeId"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.description}:</div>
						<div class="controls">
							<input id="description"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>	
		</div>	
	</div>
</div>

<div id="jqxNotificationCreate" >
	<div id="notificationContentCreate">
	</div>
</div>

<div id="jqxNotificationCreateSuccess" >
	<div id="notificationContentCreateSuccess">
	</div>
</div>

<div id="jqxNotificationCreateError" >
	<div id="notificationContentCreateError">
	</div>
</div>

<div id="jqxNotificationCreateExists" >
	<div id="notificationContentCreateExists">
	</div>
</div>

<div id="jqxNotificationUpdateSuccess" >
	<div id="notificationContentUpdateSuccess">
	</div>
</div>

<div id="jqxNotificationDeleteSuccess" >
	<div id="notificationContentDeleteSuccess">
	</div>
</div>

<div id="jqxNotificationUpdateError" >
	<div id="notificationContentUpdateError">
	</div>
</div>

<div id="jqxNotificationUpdateErrorParent" >
	<div id="notificationContentUpdateErrorParent">
	</div>
</div>

<div id="jqxMessageNotificationSelectMyTree">
	<div id="notificationContentSelectMyTree">
	</div>
</div>

<div id="jqxMessageNotificationCheckDescription">
	<div id="notificationContentCheckDescription">
	</div>
</div>

<script>
	//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	$("#alterpopupWindow").jqxWindow({
	    width: 600 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7           
	});
	$("#createLocationFacilityType").jqxButton({ height: 30, width: 80 });
	$("#deleteLocationFacilityType").jqxButton({ height: 30, width: 80 });
	
	$("#alterSave").jqxButton({ height: 30, width: 80 });
	$("#alterCancel").jqxButton({ height: 30, width: 80 });
	$("#locationFacilityTypeId").jqxInput({placeHolder: "Enter text"});
	$("#description").jqxInput({placeHolder: "Enter text"});
	
	$("#jqxNotificationCreate").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityType", opacity: 0.9, autoClose: true, template: "error" });
	$("#jqxNotificationCreateError").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeError", opacity: 0.9, autoClose: true, template: "error" });
	$("#jqxNotificationCreateSuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeSuccess", opacity: 0.9, autoClose: true, template: "success" });
	$("#jqxNotificationCreateExists").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeExits", opacity: 0.9, autoClose: true, template: "info" });
	$("#jqxNotificationUpdateSuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeUpdateSuccess", opacity: 0.9, autoClose: true, template: "success" });
	$("#jqxNotificationUpdateError").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeUpdateError", opacity: 0.9, autoClose: true, template: "error" });
	$("#jqxNotificationUpdateErrorParent").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeUpdateErrorParent", opacity: 0.9, autoClose: true, template: "error" });
	$("#jqxMessageNotificationSelectMyTree").jqxNotification({ width: "100%", appendContainer: "#contentNotificationSelectTreeGird", opacity: 0.9, autoClose: true, template: "error" });
	$("#jqxNotificationDeleteSuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateLocationFacilityTypeDeleteSuccess", opacity: 0.9, autoClose: true, template: "success" });
	$("#jqxMessageNotificationCheckDescription").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckDescription", opacity: 0.9, autoClose: true, template: "error" });
	
	$("#createLocationFacilityType").click(function (){
		loadParentLocationFacilityTypeId();
		$('#alterpopupWindow').jqxWindow('open');
	});
	
	$('#locationFacilityTypeId').on('close',function (){
		var locationFacilityTypeId = $("#locationFacilityTypeId").val();
		$.ajax({
  		  url: "loadParentLocationFacilityTypeId",
  		  type: "POST",
  		  data: {locationFacilityTypeId: locationFacilityTypeId},
  		  dataType: "json",
  		  success: function(data) {
  		  }
	  	}).done(function(data) {
	  		var value = data["value"];
	  		if(value == "exists"){
	  			$("#notificationContentCreateExists").text('${StringUtil.wrapString(uiLabelMap.checkInventoryItemExits)}');
				$("#jqxNotificationCreateExists").jqxNotification('open');
	  		}
	  		else{
	  			
	  		}
	  	});
	});
	
	function loadParentLocationFacilityTypeId(){
		$.ajax({
	  		  url: "loadParentLocationFacilityTypeIdInFacility",
	  		  type: "POST",
	  		  data: {},
	  		  dataType: "json",
	  		  success: function(data) {
	  		  }
	  	}).done(function(data) {
	  		var listParentLocationFacilityTypeMap = data["listParentLocationFacilityTypeMap"];
	  		bindingParentLocationFacilityTypeId(listParentLocationFacilityTypeMap);
	  	});
	}
	
	function bindingParentLocationFacilityTypeId(listParentLocationFacilityTypeMap){
		$("#parentLocationFacilityTypeId").jqxDropDownList({source: listParentLocationFacilityTypeMap, placeHolder: "Please select" ,displayMember: 'description', valueMember: 'locationFacilityTypeId', width:'211px'});
	}
	
	$("#alterSave").click(function (){
		$("#locationFacilityTypeId").jqxInput({placeHolder: "Enter text"});
		$("#description").jqxInput({placeHolder: "Enter text"});
		var locationFacilityTypeId = $("#locationFacilityTypeId").val();
		var parentLocationFacilityTypeId = $("#parentLocationFacilityTypeId").val();
		var description = $("#description").val();
		if(locationFacilityTypeId == "" || description == ""){
			$("#notificationContentCreate").text('${StringUtil.wrapString(uiLabelMap.NotifiEnterData)}');
			$("#jqxNotificationCreate").jqxNotification('open');
		}
		else{
			$.ajax({
	    		  url: "createLocationFacilityTypeInFacility",
	    		  type: "POST",
	    		  data: {locationFacilityTypeId: locationFacilityTypeId, parentLocationFacilityTypeId: parentLocationFacilityTypeId, description: description},
	    		  dataType: "json",
	    		  success: function(data) {
	    			  var value = data["value"];
	    			  if(value == "error"){
	    				  $("#notificationContentCreateError").text('${StringUtil.wrapString(uiLabelMap.checkInventoryItemExits)}');
	    				  $("#jqxNotificationCreateError").jqxNotification('open');
	    			  }
	    			  /*if(value == "errorParent"){
	    				  $("#notificationContentUpdateErrorParent").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateErrorParent)}');
	    				  $("#jqxNotificationUpdateErrorParent").jqxNotification('open');
	    			  }*/
	    			  else{
	    				  $("#notificationContentCreateSuccess").text('${StringUtil.wrapString(uiLabelMap.NotifiCreateSucess)}');
	    				  $("#jqxNotificationCreateSuccess").jqxNotification('open');
	    			  }
	    		  }
	    	}).done(function(data) {
	    		loadParentLocationFacilityTypeId();
	    		loadDataJqxTreeGirdLocationFacilityType();
	    		$("#locationFacilityTypeId").val("");
	    		$("#description").val("");
	    		$('#alterpopupWindow').jqxWindow('close');
	    	});
		}
	});
	
	$('#jqxTreeGirdLocationFacilityType').on('rowEndEdit', function (event) {
	      var args = event.args;
	      var row = args.row;
	      var locationFacilityTypeId = row.locationFacilityTypeId;
	      var parentLocationFacilityTypeId = row.parentLocationFacilityTypeId;
	      var description = row.description;
	      if(description == ""){
	    	  $("#notificationContentCheckDescription").text('${StringUtil.wrapString(uiLabelMap.DSCheckDescription)}');
			  $("#jqxMessageNotificationCheckDescription").jqxNotification('open');
	      }else{
	    	  $.ajax({
	    		  url: "updateLocationFacilityTypeInFacility",
	    		  type: "POST",
	    		  data: {locationFacilityTypeId: locationFacilityTypeId, parentLocationFacilityTypeId: parentLocationFacilityTypeId, description: description},
	    		  dataType: "json",
	    		  success: function(data) {
	    			  var value = data["value"];
	    			  if(value == "success"){
	    				  $("#notificationContentUpdateSuccess").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateSucess)}');
	    				  $("#jqxNotificationUpdateSuccess").jqxNotification('open');
	    			  }
	    			  if(value == "parentError"){
	    				  $("#notificationContentUpdateError").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateError)}');
	    				  $("#jqxNotificationUpdateError").jqxNotification('open');
	    			  }
	    			  if(value == "errorParent"){
	    				  $("#notificationContentUpdateErrorParent").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateErrorParent)}');
	    				  $("#jqxNotificationUpdateErrorParent").jqxNotification('open');
	    			  }
	    			  else{
	    				  /*$("#notificationContentCreateSuccess").text('${StringUtil.wrapString(uiLabelMap.NotifiCreateSucess)}');
	    				  $("#jqxNotificationCreateSuccess").jqxNotification('open');*/
	    			  }
	    		  }
	    	}).done(function(data) {
	    		row.parentLocationFacilityTypeId = "Please select";
	    		console.log(row.parentLocationFacilityTypeId);
	    		loadParentLocationFacilityTypeId();
	    		loadDataJqxTreeGirdLocationFacilityType();
	    	});
	      }
    });
	
	var dataRow = [];
	$('#jqxTreeGirdLocationFacilityType').on('rowCheck', function (event) {
		var args = event.args;
	    var row = args.row;
	    var key = args.key;
	    dataRow.push(row);
	});

	$('#jqxTreeGirdLocationFacilityType').on('rowUncheck', function (event) {
		var row = args.row;
		var ii = dataRow.indexOf(row);
		dataRow.splice(ii, 1);
	});
	
	$("#deleteLocationFacilityType").click(function (){
		if(dataRow.length == 0){
			$("#notificationContentSelectMyTree").text('${StringUtil.wrapString(uiLabelMap.SelectJqxTreeGirdToDelete)}');
	     	$("#jqxMessageNotificationSelectMyTree").jqxNotification('open');
		}
		else{
			var locationFacilityTypeId = [];
			for(var i= 0; i < dataRow.length; i++){
				locationFacilityTypeId.push(dataRow[i].locationFacilityTypeId);
			}
			deleteLocationFacilityType(locationFacilityTypeId);
		}
	});
	
	
	function deleteLocationFacilityType(locationFacilityTypeId){
		$.ajax({
			  url: "deleteLocationFacilityTypeInFacility",
			  type: "POST",
			  data: {locationFacilityTypeId: locationFacilityTypeId},
			  dataType: "json",
			  success: function(data) {
				  var value = data["value"];
				  if(value == "success"){
					  $("#notificationContentDeleteSuccess").text('${StringUtil.wrapString(uiLabelMap.DSNotifiDeleteSucess)}');
    				  $("#jqxNotificationDeleteSuccess").jqxNotification('open');
				  }
			  }    
		}).done(function(data) {
			dataRow = [];
			loadDataJqxTreeGirdLocationFacilityType();
		});
	}
</script>	
<script>
	$(document).ready(function () {
		loadDataJqxTreeGirdLocationFacilityType();
		loadParentLocationFacilityTypeId();
	});
	function loadDataJqxTreeGirdLocationFacilityType() {
		var listlocationFacilityTypeMap;
		$.ajax({
			  url: "loadListLocationFacilityTypeInFacility",
			  type: "POST",
			  data: {},
			  dataType: "json",
			  success: function(data) {
				  listlocationFacilityTypeMap = data["listlocationFacilityTypeMap"];
			  }    
		}).done(function(data) {
			renderTree(listlocationFacilityTypeMap);
		});
	}
	
	function renderTree(dataList) {
    	var source =
    	{
			dataType: "json",
		    dataFields: [
		        { name: 'locationFacilityTypeId', type: 'string' },         
		    	{ name: 'parentLocationFacilityTypeId', type: 'string' },
		    	{ name: 'description', type: 'string' },
		    ],
		    hierarchy:
		    {
		    	keyDataField: { name: 'locationFacilityTypeId' },
		        parentDataField: { name: 'parentLocationFacilityTypeId' }
		    },
		    id: 'locationFacilityTypeId',
		    localData: dataList
	    };
	    var dataAdapter = new $.jqx.dataAdapter(source, {
            loadComplete: function () {
            }
        });
         // create Tree Grid
	     $("#jqxTreeGirdLocationFacilityType").jqxTreeGrid(
	     {
	     	width: '100%',
	        source: dataAdapter,
	        hierarchicalCheckboxes: true,
            altRows: true,
            editable:true,
            checkboxes: true,
            ready: function()
            {
            	$("#jqxTreeGirdLocationFacilityType").jqxTreeGrid('expandRow', '1');
            	$("#jqxTreeGirdLocationFacilityType").jqxTreeGrid('expandRow', '2');
            },
            columns: [
                       { text: '${uiLabelMap.SelectTypeLocationFacility}', dataField: 'locationFacilityTypeId', editable:false},
                       { text: '${uiLabelMap.ParentLocationFacilityTypeId}',  dataField: 'parentLocationFacilityTypeId', columnType: "template", editable:true, 
                    	   createEditor: function (row, cellvalue, editor, cellText, width, height) {
                    		   editor.jqxDropDownList({autoDropDownHeight: true, placeHolder: "Please select....", source: locationFacilityTypeData, width: '100%', height: '100%' ,displayMember: 'description', valueMember: 'locationFacilityTypeId'});
                    	   }
                       },
                       { text: '${uiLabelMap.Description}', dataField: 'description'},
                    ],
            });
    }  
</script>