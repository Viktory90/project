<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<#assign listHoliday = delegator.findList("HolidayType",null,null,null,null,false)!>
<script type="text/javascript">
var data = [
			<#list listHoliday as holiday>
				{
					hId : '${holiday.holidayId?if_exists}',
					description : '${holiday.description?default("")}'
				},
			</#list>
		];
</script>
<#assign dataField="[
	{name : 'holidayId', type : 'string'},
	{name : 'fromDate', type : 'date'},
	{name : 'thruDate', type : 'date'},
	{name : 'description',type : 'string'}
]"/>
<#assign columnlist="
			{text : '${uiLabelMap.HolidayType}',dataField : 'holidayId',width : '150px',editable : false,cellsrenderer : 
				function(row,columnfield,value){
					var datas = $(\"#jqxgrid\").jqxGrid('getrowdata',row);
					for(var i = 0 ;i < data.length ; i++){
						if(data[i].hId == datas.holidayId){
							return '<span>' + data[i].description +'</span>';
						}
					}
					return datas.holidayId; 
				}
			},
			{text : '${uiLabelMap.CommonFromDate}',dataField : 'fromDate',cellsformat : 'dd/MM/yyyy'},
			{text : '${uiLabelMap.CommonThruDate}',dataField : 'thruDate',cellsformat : 'dd/MM/yyyy'},
			{text : '${uiLabelMap.CommonDescription}',dataField : 'description',filterable :false}
"/>

<@jqGrid filtersimplemode="true"  deleterow="true" filterable="true" addrow="true"   addType="popup" addrefresh="true" alternativeAddPopup="alterpopupWindow" dataField=dataField columnlist=columnlist  clearfilteringbutton="true" 
		editable="true" 
		 url="jqxGeneralServicer?sname=JQgetListHolidayInYear&year=${parameters.year?if_exists}"
		 createUrl="jqxGeneralServicer?sname=createHolidayInYear&jqaction=C" addColumns="holidayId;description;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp)"
		 removeUrl="jqxGeneralServicer?sname=deleteHolidayInYear&jqaction=D" deleteColumn="holidayId"
		 updateUrl="jqxGeneralServicer?jqaction=U&sname=updateHolidayInYear"  editColumns="holidayId;description;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp)"
		/>	
<div id="alterpopupWindow" style="display : none;">
	<div>${uiLabelMap.CommonAdd} ${uiLabelMap.AddHolidayInYear}</div>
	<div style="overflow: hidden;">
		<form id="formAdd" class="form-horizontal">
			<div class="control-group no-left-margin">
				<label class="control-label asterisk">${uiLabelMap.HolidayType}</label>
				<div class="controls">
					<div id="holidayIdAdd"/>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label asterisk">${uiLabelMap.CommonFromDate} </label>
				<div class="controls">
					<div id="fromDateAdd"></div>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label asterisk">${uiLabelMap.CommonThruDate} </label>
				<div class="controls">
					<div id="thruDateAdd"></div>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label">${uiLabelMap.CommonDescription} </label>
				<div class="controls">
					<input type="text" id="descriptionAdd"/>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label">&nbsp;</label>
				<div class="controls">
					<button type="button" class='btn btn-primary btn-mini' style="margin-right: 5px; margin-top: 10px;" id="alterSave"><i class='fa fa-check'></i>&nbsp;${uiLabelMap.CommonSave}</button>
					<button type="button" class='btn btn-danger btn-mini' style="margin-right: 5px; margin-top: 10px;" id="alterCancel"><i class='icon-remove'></i>&nbsp;${uiLabelMap.CommonClose}</button>
				</div>
			</div>
		</form>
	</div>
</div>


<script type="text/javascript">
$.jqx.theme = 'olbius';
var theme = theme;

$('#alterpopupWindow').jqxWindow({ width: 500, height : 300,resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7 });
	$('#holidayIdAdd').jqxDropDownList({width : '200px',height : '25px',source : data,displayMember : 'description',valueMember : 'hId',selectedIndex  : 0,autoDropDownHeight : true});
	$('#fromDateAdd').jqxDateTimeInput({width : '200px',height : '25px',allowNullDate : true,value : null});
	$('#thruDateAdd').jqxDateTimeInput({width : '200px',height : '25px',allowNullDate : true,value : null});
	$('#descriptionAdd').jqxInput({width : '195px',height : '25px'});
	$("#fromDateAdd").on("change", function(event){
			var tmp = event.args.date;
			if(tmp != null && tmp !== 'undefined'){
				var date = new Date((tmp.getYear() + 1900), tmp.getMonth(), tmp.getDate());
				$("#thruDateAdd").jqxDateTimeInput('setMinDate', date);
			}
		});
	$("#thruDateAdd").on("change", function(event){
		var tmp = event.args.date;
		if(tmp != null && tmp !== 'undefined'){
			var date = new Date((tmp.getYear() + 1900), tmp.getMonth(), tmp.getDate());
			$("#fromDateAdd").jqxDateTimeInput('setMaxDate', date);
		}
	});
	$('#formAdd').jqxValidator({
			rules : [
				{input : '#fromDateAdd',message : '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}' , action : 'blur',rule : function(){
					var fromDate = $('#fromDateAdd').val();
					if(!fromDate){
						return false;
					}
					return true;
				}},	
				{input : '#thruDateAdd',message : '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}' , action : 'blur',rule : function(){
					var thruDate = $('#thruDateAdd').val();
					if(!thruDate){
						return false;
					}
					return true;
				}}	
			]
	})
	$('#alterSave').click(function(){
		$('#formAdd').jqxValidator('validate');
	});
	$('#formAdd').on('validationSuccess',function(){
	var row = {};
	row = {
		holidayId : $('#holidayIdAdd').val(),
		description : $('#descriptionAdd').val()
	};
	 $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	// select the first row and clear the selection.
    $("#jqxgrid").jqxGrid('clearSelection');                        
    $("#jqxgrid").jqxGrid('selectRow', 0);  
    $("#alterpopupWindow").jqxWindow('close');
	});
	$('#alterpopupWindow').on('close',function(){
		$('#fromDateAdd').jqxDateTimeInput('val',null);
		$('#thruDateAdd').jqxDateTimeInput('val',null);
		$('#descriptionAdd').jqxInput('val',null);
	});
</script>		
			