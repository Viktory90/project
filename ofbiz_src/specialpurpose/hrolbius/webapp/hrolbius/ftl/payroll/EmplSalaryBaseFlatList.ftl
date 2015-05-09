<#assign dataFields = "[{name: 'partyId', type: 'string'},
						{name: 'partyName', type: 'string'},
						{name: 'currDept', type: 'string'},
						{name: 'emplPositionTypeId', type: 'string'},
						{name: 'fromDate', type: 'date'},
						{name: 'rateAmount', type: 'number'},
						{name: 'rateCurrencyUomId', type: 'string'},
						{name: 'periodTypeId', type: 'string'},
						{name: 'allEmplPositionTypeId', type: 'string'},	
						{name: 'editAction', type: 'string'}]"/>
<script type="text/javascript" src="/jqwidgets/jqwidgets/jqxtree.js"></script>
<script type="text/javascript" src="/jqwidgets/jqwidgets/jqxdropdownbutton.js"></script>						
<script type="text/javascript" src="/hrolbius/js/formatCurrency.js"></script>
<script type="text/javascript">
<#--/* if(event.args.datafield == 'deleteRecord'){
if(rowDetailData.rateTypeIdDetail && rowDetailData.workEffortIdDetail){
	var dataSubmitDelete = new Array();
	dataSubmitDelete.push({name: 'partyId', value: partyId});
	dataSubmitDelete.push({name: 'emplPositionTypeId', value: rowDetailData.emplPositionTypeIdDetail});
	dataSubmitDelete.push({name: 'periodTypeId', value: rowDetailData.periodTypeIdDetail});
	dataSubmitDelete.push({name: 'rateCurrencyUomId', value: rowDetailData.rateCurrencyUomIdDetail});
	dataSubmitDelete.push({name: 'rateTypeId', value: rowDetailData.rateTypeIdDetail});
	dataSubmitDelete.push({name: 'workEffortId', value: rowDetailData.workEffortIdDetail});
	dataSubmitDelete.push({name: 'fromDate', value: rowDetailData.fromDateDetail.getTime()});
	jQuery.ajax({
		url: 'deletePartyRateAmount',
		data: dataSubmitDelete,
		type: 'POST',
		success:function(data){
			if(data._EVENT_MESSAGE_){
				$('#notificationText').html(data._EVENT_MESSAGE_);
				$('#updateNotificationSalary').jqxNotification({ template: 'info' });
				$('#updateNotificationSalary').jqxNotification('open');
				grid.jqxGrid('updatebounddata');
			}else{
				$('#notificationText').html(data._ERROR_MESSAGE_);
				$('#updateNotificationSalary').jqxNotification({ template: 'info' });
				$('#updateNotificationSalary').jqxNotification('open');
				
			}	
		}
	});
}else{
	$('#cannotDeleteNotify').jqxNotification('open');
}
} */-->
var emplPosTypeArr = new Array();	
<#list emplPosType as posType>
	var row = {};
	row["emplPositionTypeId"] = "${posType.emplPositionTypeId}";
	row["description"] = "${StringUtil.wrapString(posType.description)}";
	emplPosTypeArr[${posType_index}] = row;
</#list>

var periodTypeArr = new Array();
<#list periodTypeList as periodType>
	var row = {};
	row["periodTypeId"] = "${periodType.periodTypeId}";
	row["description"] = "${periodType.description?if_exists}";
	periodTypeArr[${periodType_index}] = row;
</#list>
var filterBoxAdapter = new $.jqx.dataAdapter(periodTypeArr, {autoBind: true});
var dataSoureList = filterBoxAdapter.records;


var treePartyGroupArr = new Array();
	<#list treePartyGroup as tree>
	var row = {};
	row["id"] = "${tree.id}_partyGroupId";
	row["text"] = "${tree.text}";
	row["parentId"] = "${tree.parentId}_partyGroupId";
	row["value"] = "${tree.idValueEntity}"
	treePartyGroupArr[${tree_index}] = row;
</#list>  
 var sourceTreePartyGroup =
 {
     datatype: "json",
     datafields: [
         { name: 'id'},
         { name: 'parentId'},
         { name: 'text'} ,
         { name: 'value'}
     ],
     id: 'id',
     localdata: treePartyGroupArr
 };
 
 var dataAdapter = new $.jqx.dataAdapter(sourceTreePartyGroup);
 // perform Data Binding.
 dataAdapter.dataBind();
 // get the tree items. The first parameter is the item's id. The second parameter is the parent item's id. The 'items' parameter represents 
 // the sub items collection name. Each jqxTree item has a 'label' property, but in the JSON data, we have a 'text' field. The last parameter 
 // specifies the mapping between the 'text' and 'label' fields.  
 var records = dataAdapter.getRecordsHierarchy('id', 'parentId', 'items', [{ name: 'text', map: 'label'}]);
 
	<#assign initrowdetailsDetail = "function (index, parentElement, gridElement, datarecord){
			var partyId = datarecord.partyId;
			var urlStr = 'getPartyPayrollHistory';
			//var emplSalaryDataAdapter = new $.jqx.dataAdapter(datarecord.rowDetail, { autoBind: true });
			//emplSalary = emplSalaryDataAdapter.records;
			
			//var nestedGrids = new Array();
			var id = datarecord.uid.toString();
			var grid = $($(parentElement).children()[0]);
	        $(grid).attr(\"id\",\"jqxgridDetail\" + \"_\" + id);
	        
	        //nestedGrids[index] = grid;
	        //var emplSalaryArr = [];
	        /* for(var k = 0; k < emplSalary.length; k++){
	        	emplSalaryArr.push(emplSalary[k]);
	        } */
	        var emplSalarySource = {datafields: [
		            {name: 'fromDateDetail', type: 'date'},
		            {name: 'thruDateDetail', type: 'date'},
		            {name: 'rateAmountDetail', type: 'number'},
		            {name: 'emplPositionTypeIdDetail', type: 'string'},
		            {name: 'periodTypeIdDetail', type: 'string'},
		            {name: 'rateCurrencyUomIdDetail', type: 'string'},
		            {name: 'isBasedOnPosType', type: 'string'},
		            /* {name: 'deleteRecord', type: 'string'}, */
		            {name: 'rateTypeIdDetail', type: 'string'},
		            {name: 'workEffortIdDetail', type: 'string'}
				],
				cache: false,
				//localdata: emplSalaryArr,
				datatype: 'json',
				type: 'POST',
				data: {partyId: partyId},
		        url: urlStr,
		        deleterow: function(rowId, commit){
		        	
		        }
	        };
	        var nestedGridAdapter = new $.jqx.dataAdapter(emplSalarySource);
	        if (grid != null) {
	        	grid.on('cellselect', function (event){
	        		var rowBoundIndex = event.args.rowindex;
	        		var rowDetailData = grid.jqxGrid('getrowdata', rowBoundIndex);
	        		
	        		//delete row is temporary remove
	        		
	        	});
	        	grid.jqxGrid({
	        		source: nestedGridAdapter, width: '96%', height: 170,
	                 showtoolbar:false,
			 		 editable: false,
			 		 editmode:'selectedrow',
			 		 showheader: true,
			 		 
			 		 selectionmode:'singlecell',
			 		 theme: 'energyblue',
			 		 columns: [
			 		 	{text: '${uiLabelMap.CommonFromDate}', datafield: 'fromDateDetail', cellsalign: 'left', width: 130, cellsformat: 'dd/MM/yyyy ', columntype: 'template'},
			 		 	{text: '${uiLabelMap.CommonThruDate}', datafield: 'thruDateDetail', cellsalign: 'left', width: 130, cellsformat: 'dd/MM/yyyy ', columntype: 'template'},
			 		 	{text: '${uiLabelMap.CommonAmount}',datafield: 'rateAmountDetail', filterable: false,editable: false, cellsalign: 'right', width: 130, 
			 		 		 cellsrenderer: function (row, column, value) {
				 		 		 var data = grid.jqxGrid('getrowdata', row);
				 		 		 if (data && data.rateAmountDetail){
				 		 		 	return \"<div style='margin-top: 3px; text-align: right; margin-right: 3px;'>\" + formatcurrency(data.rateAmountDetail, data.rateCurrencyUomIdDetail) + \"</div>\";
				 		 		 }
			 		 		 }
			 		 	},
			 		 	{text: '${uiLabelMap.EmplPositionTypeId}',  datafield: 'emplPositionTypeIdDetail', filterable: false,editable: false, cellsalign: 'left',
							cellsrenderer: function (row, column, value){
								for(var i = 0; i < emplPosTypeArr.length; i++){
									if(emplPosTypeArr[i].emplPositionTypeId == value){
										return '<div style=\"margin-top: 2px; margin-left: 3px\">' + emplPosTypeArr[i].description + '</div>';		
									}
								}
							}
						},
			 		 	{text: '${uiLabelMap.PeriodTypePayroll}', datafield: 'periodTypeIdDetail', filterable: false,editable: false, cellsalign: 'left', width: 130,
							cellsrenderer: function (row, column, value){
								for(var i = 0; i < periodTypeArr.length; i++){
									if(periodTypeArr[i].periodTypeId == value){
										return '<div style=\"margin-top: 4px; margin-left: 2px\">' + periodTypeArr[i].description + '</div>';		
									}
								}
							}	
						},
						{ text: '${uiLabelMap.IsBasedOnPosType}', columntype: 'template', datafield: 'isBasedOnPosType',  width: '150px', filterable: false,editable: false, cellsalign: 'center',
							cellsrenderer: function(row, column, value){
								if(value == 'Y'){
									return \"<label style='text-align: center; margin-top: 6px'><input type='checkbox' disabled='disabled' checked='checked'><span class='lbl'></span></label>\";
								}else{
									return \"<label style='text-align: center; margin-top: 6px'><input type='checkbox' disabled='disabled'><span class='lbl'></span></label>\";
								}
								
							}
						},
						/* {text: '', datafield:'deleteRecord', filterable: false,editable: false, cellsalign: 'center', width: '50px',
							 cellsrenderer: function(row, column, value){
								 //var gridId = 'jqxgridDetail_' + id;
								 return '<div style=\"text-align: center; margin-bottom: 2px\"><button class=\"btn btn-mini btn-danger icon-trash\" ></button></div>';
			                  }	
						}, */
						{text:'', datafield: 'rateCurrencyUomIdDetail', hidden: true},
						{text:'', datafield: 'rateTypeId', hidden: true},
						{text:'', datafield: 'workEffortId', hidden: true}
 		            ]
	        	});
	        }
		  }">
	<#assign columnlist = "{text: '${uiLabelMap.EmployeeId}', datafield: 'partyId', filterable: true,  editable: false, cellsalign: 'left', width: 95},
							{text: '${uiLabelMap.EmployeeName}', datafield: 'partyName', filterable: true, editable: false, cellsalign: 'left', width: 125},
							{text: '${uiLabelMap.EmployeeCurrentDept}', datafield: 'currDept', filterable: false,editable: false, cellsalign: 'left', width: 160},
							{text: '${uiLabelMap.EmplPositionTypeId}',  datafield: 'emplPositionTypeId', filterable: false,editable: false, cellsalign: 'left', width: 200,
								cellsrenderer: function (row, column, value){
									for(var i = 0; i < emplPosTypeArr.length; i++){
										if(emplPosTypeArr[i].emplPositionTypeId == value){
											return '<div style=\"\">' + emplPosTypeArr[i].description + '</div>';		
										}
									}
								}
							},
							{text: '${uiLabelMap.PayrollFromDate}', datafield: 'fromDate', filterable: false,editable: false, cellsalign: 'left', width: 130, cellsformat: 'dd/MM/yyyy ', columntype: 'template'},
							{text: '${uiLabelMap.CommonAmount}', datafield: 'rateAmount', filterable: false,editable: false, cellsalign: 'right', width: 130,
								cellsrenderer: function (row, column, value) {
					 		 		 var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		 		 if (data && data.rateAmount){
					 		 		 	return \"<div style='margin-top: 9.5px; text-align: right;'>\" + formatcurrency(data.rateAmount, data.rateCurrencyUomId) + \"</div>\";
					 		 		 }
				 		 		 }	
							},
							{text: '${uiLabelMap.PeriodTypePayroll}', datafield: 'periodTypeId', filterable: false,editable: false, cellsalign: 'left',
								cellsrenderer: function (row, column, value){
									for(var i = 0; i < periodTypeArr.length; i++){
										if(periodTypeArr[i].periodTypeId == value){
											return '<div style=\"\">' + periodTypeArr[i].description + '</div>';		
										}
									}
								}	
							},
							{ text: '',columntype: 'template', editable: false,  width: 50, filterable: false, datafield: 'editAction',
			                	   cellsrenderer: function(){
			                		return '<div style=\"text-align: center; margin-bottom: 2px\"><button class=\"btn btn-mini btn-primary icon-edit\" ></button></div>';
			                	   }			                   
			                },
			                {text: '${uiLabelMap.allEmplPositionType}',  datafield: 'allEmplPositionTypeId',filterable: false,editable: false, hidden: true,
			                },
							{text:'', datafield: 'rateCurrencyUomId', hidden: true}">;
							
 $(document).ready(function () {
	 var theme = 'olbius';
	 var uomArray = new Array();
	 <#list uomList as uom>
	 	var row = {};
	 	row["uomId"] = "${uom.uomId}";
	 	row["description"] = "${uom.description?if_exists}";
	 	uomArray[${uom_index}] = row;
	 </#list>
	 var filterUomAdapter = new $.jqx.dataAdapter(uomArray, {autoBind: true});
	 var dataSoureUomList = filterUomAdapter.records;
	 var rowSelectedIndex;
	 
	 jQuery("#emplPosTypeSalary").jqxDropDownList({ width: '250', height: '25', autoDropDownHeight: true, selectedIndex: 0, theme:theme, displayMember: "description", valueMember: "emplPositionTypeId"})
	
	 $("#dropDownButton").jqxDropDownButton({ width: 280, height: 25, theme: theme});
		$('#jqxTree').on('select', function(event){
	    	var id = event.args.element.id;
	    	var item = $('#jqxTree').jqxTree('getItem', event.args.element);
	    	/* var value = jQuery("#jqxTree").jqxTree('getItem', $("#"+id)[0]).value; */
	    	setDropdownContent(event.args.element);
	        var tmpS = $("#jqxgrid").jqxGrid('source');
	        var partyId = item.value;
	        
	        tmpS._source.url = "jqxGeneralServicer?hasrequest=Y&sname=JQListEmplSalaryBaseFlat&partyGroupId=" + partyId;
	        $("#jqxgrid").jqxGrid('source', tmpS);
	        	       
	     });
	     $('#jqxTree').jqxTree({ source: records,width: "280px", height: "200px", theme: theme});
	     <#if expandedList?has_content>
		 	<#list expandedList as expandId>
		 		$('#jqxTree').jqxTree('expandItem', $("#${expandId}_partyGroupId")[0]);
		 	</#list>
		 </#if>    
		 <#if expandedList?has_content>
		 	var initElement = $("#${expandedList.get(0)}_partyGroupId")[0];
		 	setDropdownContent(initElement);
		 </#if>
	 
	 $("#jqxgrid").on('cellSelect', function (event){
		var dataField = event.args.datafield;
		var rowBoundIndex = event.args.rowindex;
		if(dataField == 'editAction'){
			var data = $('#jqxgrid').jqxGrid('getrowdata', rowBoundIndex);
			//var emplPosDes = '';
			rowSelectedIndex = rowBoundIndex;
			var emplPosTypeArrSalary = new Array();
			var currEmplPos = data.allEmplPositionTypeId;
			for(var i = 0; i < currEmplPos.length; i++){
				for(var j = 0; j < emplPosTypeArr.length; j++){
					if(emplPosTypeArr[j].emplPositionTypeId == currEmplPos[i]){
						emplPosTypeArrSalary.push(emplPosTypeArr[j]); 
						break;
					}
				}	
			}
			//var emplPosTypeSalaryAdapter = new  
			if(emplPosTypeArrSalary.length > 8){
				jQuery("#emplPosTypeSalary").jqxDropDownList({autoDropDownHeight: false});
			}
			jQuery("#emplPosTypeSalary").jqxDropDownList({source: emplPosTypeArrSalary});
			
			jQuery("#emplNameSalary").text(data.partyName);
			//jQuery("#emplPosTypeSalary").text(emplPosDes);
			jQuery("#currDeptSalary").text(data.currDept);
			jQuery("#partyId").val(data.partyId);
			jQuery("#emplPositionTypeId").val(data.emplPositionTypeId);
			$('#editSalaryWindow').jqxWindow('open');			
		}
	}); 
	
	 $("#payrollFromDate").jqxDateTimeInput({width: '250px', height: '25px', formatString: 'dd/MM/yyyy', theme: 'olbius'});
	 $("#payrollThruDate").jqxDateTimeInput({width: '250px', height: '25px', formatString: 'dd/MM/yyyy', theme: 'olbius'});
	 $("#payrollThruDate").val(null);
	 $("#periodTypeSalary").jqxDropDownList({ width: '250px',source: dataSoureList, displayMember: 'description', 
		 	valueMember : 'periodTypeId', height: '25px', theme: 'olbius', searchMode: 'contains', dropDownHeight: 100,
			renderer: function (index, label, value) {
				for(i=0; i < periodTypeArr.length; i++){
					if(periodTypeArr[i].periodTypeId == value){
						return periodTypeArr[i].description;
					}
				}
			    return value;
			}
	 });
	 <#if defaultPeriodTypeId?exists>
		 $("#periodTypeSalary").jqxDropDownList('selectItem', "${defaultPeriodTypeId}");
	 </#if>
	 
	 jQuery("#CurrencyUomIdSalary").jqxDropDownList({ width: '250px', source: dataSoureUomList, displayMember: 'uomId', valueMember : 'uomId', 
		 	height: '25px', theme: 'olbius', searchMode: 'contains', dropDownHeight: 190,
			renderer: function (index, label, value) {
				for(i=0; i < uomArray.length; i++){
					if(uomArray[i].uomId == value){
						return uomArray[i].description;
					}
				}
			    return value;
			}
		});
	 $("#submitForm").jqxButton({ width: '130', theme: theme});
	 $("#cancelSubmit").jqxButton({ width: '130', theme: theme, template: 'warning'});
	 <#if rateCurrencyUomId?exists>
	 	jQuery("#CurrencyUomIdSalary").jqxDropDownList('selectItem', "${rateCurrencyUomId}");
	 </#if>
	 $("#amountSalary").jqxNumberInput({ width: '250px', height: '25px', spinButtons: false, decimalDigits: 2, digits: 9, max: 999999999, theme: 'olbius', min: 0 });
	 $('#editSalaryWindow').jqxWindow({
	        showCollapseButton: false, maxHeight: 440, maxWidth: '50%', minHeight: 400, minWidth: '50%', height: 430, width: '50%', theme:'olbius',
	        autoOpen: false, isModal: true, 
	        initContent: function () {
	            
	        }
	  });
	 $('#editSalaryWindow').on("open", function(event){
		 $("#payrollThruDate").val(null);
		 $("#amountSalary").val(0);
	 });
	 
	 $("#submitForm").click(function(){
		 $("#warningAddRecord").text("${StringUtil.wrapString(uiLabelMap.AddRowDataConfirm)}?" );
			$("#warningAddRecord").dialog({
		      resizable: false,
		      height:180,
		      modal: true,
		      buttons: {
		        "${StringUtil.wrapString(uiLabelMap.wgok)}": function() {
		        	$('#editSalaryWindow').jqxWindow('close');
				 	 $( this ).dialog( "close" );
				 	 var dataSubmit = new Array();
					 var partyId = $("#partyId").val();
					 var emplPositionTypeId = $("#emplPositionTypeId").val();
					 var fromDate = $("#payrollFromDate").jqxDateTimeInput('getDate').getTime();
					 var uomId = jQuery("#CurrencyUomIdSalary").jqxDropDownList('getSelectedItem').value;
					 var periodTypeId = $("#periodTypeSalary").jqxDropDownList('getSelectedItem').value;
					 var amount = $("#amountSalary").val();
					 var emplPositionTypeId = $("#emplPosTypeSalary").jqxDropDownList('getSelectedItem').value;
					 dataSubmit.push({name: "partyId", value: partyId});
					 dataSubmit.push({name: "fromDate", value: fromDate});
					 dataSubmit.push({name: "uomId", value: uomId});
					 dataSubmit.push({name: "periodTypeId", value: periodTypeId});
					 dataSubmit.push({name: "amount", value: amount});
					 dataSubmit.push({name: "emplPositionTypeId", value: emplPositionTypeId});
					 if($("#payrollThruDate").val()){
						 dataSubmit.push({name: "thruDate", value: $("#payrollThruDate").jqxDateTimeInput('getDate').getTime()});
					 }
					 $.ajax({
						url: "<@ofbizUrl>createPartyRateAmount</@ofbizUrl>",
						type: 'POST',
						data: dataSubmit,
						success: function(data){
							if(data._EVENT_MESSAGE_){
								$("#notificationText").html(data._EVENT_MESSAGE_);
								$("#updateNotificationSalary").jqxNotification({ template: 'info' });
								$("#updateNotificationSalary").jqxNotification('open');
								var rowId = $('#jqxgrid').jqxGrid('getrowid', rowSelectedIndex);
								if($("#jqxgridDetail_" + rowId).length){
									$("#jqxgridDetail_" + rowId).jqxGrid('updatebounddata');
								}else{
									$('#jqxgrid').jqxGrid('showrowdetails', rowSelectedIndex);
								}
							}else{
								$("#notificationText").html(data._ERROR_MESSAGE_);
								$("#updateNotificationSalary").jqxNotification({ template: 'info' });
								$("#updateNotificationSalary").jqxNotification('open');
							}	
						}
					 });        					          						          
		        },
		        "${StringUtil.wrapString(uiLabelMap.wgcancel)}": function() {
		        	$( this ).dialog( "close" );
		        	$('#editSalaryWindow').jqxWindow('close');
		        }
		      }
			});		
	 });
	 $("#cancelSubmit").click(function(){
		 $('#editSalaryWindow').jqxWindow('close');
	 });
	 $("#updateNotificationSalary").jqxNotification({
         width: "100%", position: "top-left", opacity: 1, appendContainer: "#appendNotification",
         autoOpen: false, animationOpenDelay: 800, autoClose: false
     });
	 $("#cannotDeleteNotify").jqxNotification({
         width: "300px", position: "top-right", opacity: 1, template: 'info', appendContainer: "#appendNotification",
         autoOpen: false, animationOpenDelay: 800, autoClose: true, autoCloseDelay: 10000
     });
	 
 });
 function setDropdownContent(element){
	 var item = $("#jqxTree").jqxTree('getItem', element);
	 var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + item.label + '</div>';
     $("#dropDownButton").jqxDropDownButton('setContent', dropDownContent);
 }
 /* function deleteEmplSalaryRecord(gridId){
	 jQuery("#" + gridId).
 } */
 
</script>	
	
<div id="editSalaryWindow">
	 <div id="windowHeader">
     	${uiLabelMap.EditEmpPosTypeSalary}
     </div>
     <div style="overflow: hidden;" id="windowContent">
     	<div class="row-fluid">
     		<div class="span12">
     			<form class="form-horizontal" method="post">
     				
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.EmployeeName}</label>
     					<div class="controls">
     						<span id="emplNameSalary"></span>
     						<input type="hidden" name="partyId" id="partyId">
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.EmployeeCurrentDept}</label>
     					<div class="controls">
     						<span id="currDeptSalary"></span>
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.EmplPositionTypeId}</label>
     					<div class="controls">
     						<div id="emplPosTypeSalary"></div>
     						
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.PayrollFromDate}</label>
     					<div class="controls">
     						<div id='payrollFromDate'>
        					</div>
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.CommonThruDate}</label>
     					<div class="controls">
     						<div id='payrollThruDate'>
        					</div>
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.CurrencyUomId}</label>
     					<div class="controls">
     						<div id="CurrencyUomIdSalary">
     							
     						</div>
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.PeriodTypePayroll}</label>
     					<div class="controls">
     						<div id="periodTypeSalary"></div>
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.CommonAmount}</label>
     					<div class="controls">
     						<div id="amountSalary">
     						</div>
     					</div>
     				</div>
     				<div class="control-group">
     					<label class="control-label">&nbsp;</label>
     					<div class="controls">
     						<input type="button" value="${uiLabelMap.CommonSubmit}" id='submitForm'/>
     						<input type="button" value="${uiLabelMap.CommonClose}" id='cancelSubmit'/>
     					</div>
     				</div>
     			</form>
     		</div>
     	</div>
     </div>
</div>				
<div class="row-fluid">
	<div id="appendNotification">
		<div id="updateNotificationSalary">
			<span id="notificationText"></span>
		</div>
	</div>
	<div id="cannotDeleteNotify">
		<span style="font-weight: bold;">${uiLabelMap.CannotDeleteSalarySetBaseOnPosType}</span>
	</div>
</div>
<div class="widget-box transparent no-bottom-border">
	<div class="widget-header">
		<h4>${uiLabelMap.EmplSalaryBaseFlatList}</h4>
		<div class="widget-toolbar none-content">
			<div id="dropDownButton" style="margin-top: 5px;">
				<div style="border: none;" id="jqxTree">
						
				</div>
			</div>	
		</div>
	</div>
	<div class="widget-body">
			<@jqGrid filtersimplemode="true" addType="popup" dataField=dataFields columnlist=columnlist clearfilteringbutton="true" showtoolbar="false" 
				 filterable="true" alternativeAddPopup="popupWindowAddPartyAttend" deleterow="false" editable="false" addrow="false"
				 url="jqxGeneralServicer?hasrequest=Y&sname=JQListEmplSalaryBaseFlat" id="jqxgrid" initrowdetails="true" initrowdetailsDetail=initrowdetailsDetail
				 removeUrl="" deleteColumn="" updateUrl="" editColumns="" selectionmode="singlecell"
			/>	
	</div>	
</div> 

<style>
	.ui-dialog { z-index: 9999 !important ;}
</style>	
<div id="warningAddRecord" title="${StringUtil.wrapString(uiLabelMap.AddRowRecord)}?">
	
</div>