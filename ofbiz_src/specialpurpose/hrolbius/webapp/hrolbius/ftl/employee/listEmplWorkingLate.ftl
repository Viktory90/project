
<#assign listPs = delegator.findList("Person",null,null,null,null,false) !>
<script type="text/javascript">
	var psName = [
		<#list listPs as ps>
		{
			partyId : "${ps.partyId?if_exists}",
			name : "${StringUtil.wrapString(ps.lastName?default(''))} ${StringUtil.wrapString(ps.middleName?default(''))} ${StringUtil.wrapString(ps.firstName?default(''))}"
		},	
		</#list>
	];
</script>
<script type="text/javascript" src="/delys/images/js/marketing/utils.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script> 		
<#assign dataField = "[
			{name : 'partyId',type : 'string'},
			{name : 'reasonQuantity', type : 'number'},
			{name : 'NoReasonQuantity', type : 'number'}
]"/>

<#assign columnlist = "
				{text : '${uiLabelMap.EmployeeName}' , datafield : 'partyId',filtertype: 'olbiusdropgrid',cellsrenderer : 
					function(row,columnfield,value){
						for(var i = 0 ;i < psName.length ; i ++){
							if(psName[i].partyId == value){
								return '<span>' +psName[i].name + ' <a href=\"EmployeeProfile?partyId='+ value +'\">'+ value +'</a></span>';
							}
						}
					}
				},
				{text : '${uiLabelMap.HREmplWorkingLateReason}' , datafield : 'reasonQuantity',filterable : false},
				{text : '${uiLabelMap.HREmplWorkingLateNoReason}' , datafield : 'NoReasonQuantity',filterable : false},
				{text : '',width : '70px',filterable : false,cellsrenderer : 
					function(row,columnfield,value){
						var data = $(\"#jqxgrid\").jqxGrid(\"getrowdata\",row);
						return '<a class=\"icon-eye-open open-sans\" href=\"WorkingLateEmplDetails?partyId='+ data.partyId +'\"></a>';
					}
				}
"/>

<@jqGrid filtersimplemode="true" filterable="true"  addType="popup" addrefresh="true" alternativeAddPopup="alterpopupWindow" dataField=dataField columnlist=columnlist  clearfilteringbutton="true" 
		addrow = "true"
		 url="jqxGeneralServicer?sname=JQgetListEmplWorkLate" 
		createUrl="jqxGeneralServicer?sname=createEmplWorkingLate&jqaction=C" addColumns="partyId;delayTime(java.lang.Long);reason;dateWorkingLate(java.sql.Timestamp)"
		/>	 
<div id="alterpopupWindow" style="display:none;">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <form id="formAdd">
	        <table>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.EmployeeId}  <span style="color : red">*</span></td>
		 			<td align="left">
		 				<div id="partyIdAdd">
		 					<div id="jqxPartyGrid"></div>
		 				</div>
		 			</td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.HRDateWorkingLate}  <span style="color : red">*</span></td>
		 			<td align="left">
		 				<div id="dateWorkingLateAdd"/>
	 				</td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.HRDelayTime} (${uiLabelMap.HRMinute})  <span style="color : red">*</span></td>
		 			<td align="left">
		 				<input id="delayTimeAdd" ></input>
	 				</td>
	    	 	</tr>
	    	 	<tr>
	    	 		<td align="right">${uiLabelMap.HRReasonLate}  <span style="color : red">*</span></td>
		 			<td align="left">
		 				<textarea id="reasonAdd" cols="16" rows="4"></textarea>
	 				</td>
	    	 	</tr>
	        </table>
	       <div class="center" style="margin-left : 20px;"><input type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div>
        </form>
    </div>
</div>	
    
 <div id="jqxwindowpartyId">
	<div>${uiLabelMap.HrEmployeeList}</div>
	<div style="overflow: hidden;">
		<table id="PartyIdFrom">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdkey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdvalue" value=""/>
					<div id="jqxgridpartyid"></div>
				</td>
			</tr>
		</table>
       <div class="center"><input type="button" id="alterSave3" value="${uiLabelMap.CommonSave}" /><input id="alterCancel3" type="button" value="${uiLabelMap.CommonCancel}" /></div>
	</div>
</div>	   
    
<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	$("#alterpopupWindow").jqxWindow({
        width: 500, height : 400,resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel")      
    });
    $("#dateWorkingLateAdd").jqxDateTimeInput({height: '25px', width: 210,  formatString: 'dd-MM-yyyy : HH:mm:ss', allowNullDate: true, value: null});
    $("#delayTimeAdd").jqxInput({ width: '205px', height: '25px'});
	$("#alterSave").jqxButton({theme: theme});
	$("#alterCancel").jqxButton({theme: theme});
	//validate form
	 $('#formAdd').jqxValidator({
                rules: [
                			{ input: '#dateWorkingLateAdd', message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}', action: 'keyup, blur', rule:'required' },
	                       { input: '#delayTimeAdd', message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}', action: 'keyup, blur', rule:function(){
	                       		var value = $('#delayTimeAdd').val();
	                       		return value && !isNaN(value);
	                       } },
	                       { input: '#reasonAdd', message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}', action: 'keyup, blur', rule: 'required'}
                       ]
           			 });
	var sourceE = {
				datafields:[
							{name: 'partyId', type: 'string' },
			    			{name: 'firstName', type: 'string' },
			    			{name : 'middleName',type : 'string'},
			    			{name : 'lastName' , type : 'string'},
			    			{name : 'personalTitle' , type : 'string'},
			    			{name : 'suffix' , type : 'string'},
			    			{name : 'nickname' , type : 'string'}
				],
				cache: false,
				root: 'results',
				datatype: "json",
				updaterow: function (rowid, rowdata) {
					// synchronize with the server - send update command   
				},
				beforeprocessing: function (data) {
				    sourceE.totalrecords = data.TotalRows;
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
					conditionsFind: 'N'
				},
				pagesize:5,
				contentType: 'application/x-www-form-urlencoded',
				url: 'jqxGeneralServicer?sname=JQgetListEmplInOrg&partyId=${orgId}'
	};
	
	
	 var dataAdapterP = new $.jqx.dataAdapter(sourceE,
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
                if (!sourceE.totalRecords) {
                    sourceE.totalRecords = parseInt(data['odata.count']);
                }
        }
    });	

	// Create Employee Lookup
	$('#partyIdAdd').jqxDropDownButton({ width: 210, height: 25});
	$("#jqxPartyGrid").jqxGrid({
		width:500,
		source: dataAdapterP,
		filterable: true,
		virtualmode: true, 
 		showfilterrow: true,
		sortable:true,
		editable: false,
		autoheight:true,
		pageable: true,
		rendergridrows: function(obj) {	
			return obj.data;
		},
		columns:[	
					{text: '${uiLabelMap.PartyPartyId}', datafield: 'partyId',width : '20%'},
					{text: '${uiLabelMap.PartyFirstName}', datafield: 'firstName',width : '20%'},
					{text: '${uiLabelMap.PartyMiddleInitial}', datafield: 'middleName',width : '10%'},
					{text: '${uiLabelMap.PartyLastName}', datafield: 'lastName',width : '20%'},
					{text: '${uiLabelMap.PartyPersonalTitle}', datafield: 'personalTitle',width : '10%',cellsrenderer : 
						function(row,columnfield,value){
							var dtrow = $("#jqxPartyGrid").jqxGrid("getrowdata",row);
							var data;
							if(dtrow.personalTitle){
								 data = processData(dtrow.personalTitle);
							}
							return '<span id="' + row  + '" onmouseenter = "showDetail('+ "'"+ row + "'" +',' +"'" + data + "'" +')">' + data +'</span>';	
						}
					},
					{text: '${uiLabelMap.PartySuffix}', datafield: 'suffix',width : '10%'},
					{text: '${uiLabelMap.PartyNickName}', datafield: 'nickname',width : '10%'}
				]
	});
	$('#jqxgrid').on('filter',function(event){
		if(event.args.filters.length > 0){
		}
	});
	$("#jqxPartyGrid").on('rowselect', function (event) {
   		var args = event.args;
    	var row = $("#jqxPartyGrid").jqxGrid('getrowdata', args.rowindex);
    	var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['partyId'] + '</div>';
   		$("#partyIdAdd").jqxDropDownButton('setContent', dropDownContent);
   	});
   	
 	
   	$('#alterSave').click(function(){
   		$('#formAdd').jqxValidator('validate');
   	});
   	$('#alterCancel').click(function(){
   		$('#formAdd').trigger('reset');
   	})
   	$('#formAdd').on('validationSuccess', function (event) {
	   		 var timeJS ;
   			 var delayTimeJS;
		   		 if($('#dateWorkingLateAdd').jqxDateTimeInput('getDate') !== 'undefined' && $('#dateWorkingLateAdd').jqxDateTimeInput('getDate') != null){
		   		 	timeJS = Utils.formatDateYMD($('#dateWorkingLateAdd').jqxDateTimeInput('getDate'));
		   		 }
		   		 if($('#delayTimeAdd').val() !== 'undefined' && $('#delayTimeAdd').val() != null){
		   		 	delayTimeJS  = $('#delayTimeAdd').val();
		   		 }
		   		var row = {
		   			partyId : $('#partyIdAdd').val(),
		   			dateWorkingLate : timeJS,
		   			delayTime : delayTimeJS,
		   			reason : $('#reasonAdd').val()
		   		};
		   		 $("#jqxgrid").jqxGrid('addRow', null, row, "first");
		        // select the first row and clear the selection.
		        $("#jqxgrid").jqxGrid('clearSelection');                        
		        $("#jqxgrid").jqxGrid('selectRow', 0);  
		        $("#alterpopupWindow").jqxWindow('close');
		        $('#formAdd').trigger('reset');
        });
   	var showDetail  = function(id,value){
			$('#' + id).jqxTooltip({content : value,position : 'right'});
		};
	var processData = function(data){
		var newData = '';
		if(data.length > 40){
			newData = data.substr(0,40) + '...';
		}else {
			newData = data;
		}
		return newData;
	}
	
	//form lookup party
	$("#jqxwindowpartyId").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel3"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxwindowpartyId').on('open', function (event) {
    	var offset = $("#jqxgrid").offset();
   		$("#jqxwindowpartyId").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave3").jqxButton({theme: theme});
	$("#alterCancel3").jqxButton({theme: theme});
	$("#alterSave3").click(function () {
		var tIndex = $('#jqxgridpartyid').jqxGrid('selectedrowindex');
		var data = $('#jqxgridpartyid').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindowpartyIdkey').val()).val(data.partyId);
		$("#jqxwindowpartyId").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindowpartyIdkey').val()).trigger(e);
	});
	// From party
    var sourceF =
    {
        datafields:
        [
            { name: 'partyId', type: 'string' },
            { name: 'firstName', type: 'string' },
            { name: 'middleName', type: 'string' },
            { name: 'lastName', type: 'string' }
        ],
        cache: false,
        root: 'results',
        datatype: "json",
        updaterow: function (rowid, rowdata) {
            // synchronize with the server - send update command   
        },
        beforeprocessing: function (data) {
            sourceF.totalrecords = data.TotalRows;
        },
        filter: function () {
            // update the grid and send a request to the server.
            $("#jqxgridpartyid").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridpartyid").jqxGrid('updatebounddata');
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
        url: 'jqxGeneralServicer?sname=JQgetEmployeeInOrg',
    };
    var dataAdapterF = new $.jqx.dataAdapter(sourceF,
    {
    	autoBind: true,
    	formatData: function (data) {
    		if (data.filterscount) {
    			console.log(data);
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
            }else{
            	data.filterListFields = "";
            }
            return data;
        },
        loadError: function (xhr, status, error) {
            alert(error);
        },
        downloadComplete: function (data, status, xhr) {
                if (!sourceF.totalRecords) {
                    sourceF.totalRecords = parseInt(data['odata.count']);
                }
        }
    });
    $('#jqxgridpartyid').jqxGrid(
    {
        width:800,
        source: dataAdapterF,
        filterable: true,
        virtualmode: true, 
        sortable:true,
        editable: false,
        showfilterrow: true,
        theme: theme, 
        autoheight:true,
        pageable: true,
        pagesizeoptions: ['5', '10', '15'],
        ready:function(){
        },
        rendergridrows: function(obj)
		{
			return obj.data;
		},
         columns: [
          { text: '${uiLabelMap.EmployeePartyIdTo}', datafield: 'partyId',width : '25%'},
          { text: '${uiLabelMap.HRolbiusEmployeeFirstName}', datafield: 'firstName', width:'25%'},
          { text: '${uiLabelMap.HRolbiusEmployeeMiddleName}', datafield: 'middleName', width:'25%'},
          { text: '${uiLabelMap.HRolbiusEmployeeLastName}', datafield: 'lastName', width:'25%'}
        ]
    });
    
    $(document).keydown(function(event){
	    if(event.ctrlKey)
	        cntrlIsPressed = true;
	});
	
	$(document).keyup(function(event){
		if(event.which=='17')
	    	cntrlIsPressed = false;
	});
	var cntrlIsPressed = false;
	
	
</script>		