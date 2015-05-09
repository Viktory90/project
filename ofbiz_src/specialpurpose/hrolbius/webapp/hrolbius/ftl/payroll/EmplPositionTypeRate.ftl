<#assign dataFields = "[{name: 'emplPositionTypeId', type: 'string'},
						{name: 'periodTypeId', type: 'string'},
						{name:'fromDate', type: 'date'},
						{name: 'thruDate', type: 'date'},
						{name: 'rateAmount', type: 'number'},
						{name: 'rateCurrencyUomId', type: 'string'},
						]" />

<script type="text/javascript">
	var emplPosTypeArr = new Array();	
	<#list emplPosType as posType>
		var row = {};
		row["emplPositionTypeId"] = "${posType.emplPositionTypeId}";
		row["description"] = "${StringUtil.wrapString(posType.description)}";
		emplPosTypeArr[${posType_index}] = row;
	</#list>
	/* var emplPosTypeAdapter = new $.jqx.dataAdapter(emplPosTypeArr, {autoBind: true});
	var dataEmplPosTypeList = emplPosTypeAdapter.records;  */
	var periodTypeArr = new Array();
	<#list periodTypeList as periodType>
		var row = {};
		row["periodTypeId"] = "${periodType.periodTypeId}";
		row["description"] = "${StringUtil.wrapString(periodType.description?if_exists)}";
		periodTypeArr[${periodType_index}] = row;
	</#list>
	var filterBoxAdapter = new $.jqx.dataAdapter(periodTypeArr, {autoBind: true});
	var dataSoureList = filterBoxAdapter.records;

	<#assign initrowdetailsDetail = "function (index, parentElement, gridElement, datarecord){
					var emplPositionTypeId = datarecord.emplPositionTypeId;
					var fromDate = datarecord.fromDate;
					var periodTypeId = datarecord.periodTypeId;
					var urlStr = 'getEmplPositionTypeRateHistory';
					
					var id = datarecord.uid.toString();
					var grid = $($(parentElement).children()[0]);
			        $(grid).attr('id', 'jqxgridDetail_' + id);
	        		var emplPosTypeSalarySource = {datafields: [
           		            {name: 'fromDateDetail', type: 'date'},
           		            {name: 'thruDateDetail', type: 'date'},
           		            {name: 'rateAmountDetail', type: 'number'},
           		            {name: 'periodTypeIdDetail', type: 'string'},
           		            {name: 'rateCurrencyUomIdDetail', type: 'string'}           		            
           				],
           				cache: false,
           				//localdata: emplSalaryArr,
           				datatype: 'json',
           				type: 'POST',
           				data: {emplPositionTypeId: emplPositionTypeId},
           		        url: urlStr,
           		        deleterow: function(rowId, commit){
           		        	
           		        }
           	        };
			        var nestedGridAdapter = new $.jqx.dataAdapter(emplPosTypeSalarySource);
			        if (grid != null) {
			        	grid.jqxGrid({
			        		source: nestedGridAdapter,
			        		width: '100%', height: 170,
			                 showtoolbar:false,
					 		 editable: false,
					 		 editmode:'selectedrow',
					 		 showheader: true,
					 		 
					 		 selectionmode:'singlecell',
					 		 theme: 'energyblue',
					 		columns: [
												 		          
					 		 	{text: '${uiLabelMap.CommonFromDate}', datafield: 'fromDateDetail', cellsalign: 'left', width: '25%', cellsformat: 'dd/MM/yyyy ', columntype: 'template'},
					 		 	{text: '${uiLabelMap.CommonThruDate}', datafield: 'thruDateDetail', cellsalign: 'left', width: '24%', cellsformat: 'dd/MM/yyyy ', columntype: 'template'},
					 		 	{text: '${uiLabelMap.CommonAmount}',datafield: 'rateAmountDetail', filterable: false,editable: false, cellsalign: 'right', width: '23%', 
					 		 		 cellsrenderer: function (row, column, value) {
						 		 		 var data = grid.jqxGrid('getrowdata', row);
						 		 		 if (data && data.rateAmountDetail){
						 		 		 	return \"<div style='margin-top: 3px; text-align: right; margin-right: 3px;'>\" + formatcurrency(data.rateAmountDetail, data.rateCurrencyUomIdDetail) + \"</div>\";
						 		 		 }
					 		 		 }
					 		 	},
					 		 	
					 		 	{text: '${uiLabelMap.PeriodTypePayroll}', datafield: 'periodTypeIdDetail', filterable: false,editable: false, cellsalign: 'left', width: '23%',
									cellsrenderer: function (row, column, value){
										for(var i = 0; i < periodTypeArr.length; i++){
											if(periodTypeArr[i].periodTypeId == value){
												return '<div style=\"margin-top: 4px; margin-left: 2px\">' + periodTypeArr[i].description + '</div>';		
											}
										}
									}	
								},
								{text:'', datafield: 'rateCurrencyUomIdDetail', hidden: true},
		 		            ]
			        	});
			        }
				}">
	
	<#assign columnlist = "{text: '${uiLabelMap.EmplPositionTypeId}', datafield: 'emplPositionTypeId', filterable: true, editable: false, cellsalign: 'left', 
								filtertype: 'checkedlist',
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
								    var dataEmplPosTypeList = filterBoxAdapter.records;
								    //var selectAll = {'trainingTypeId': 'selectAll', 'description': '(Select All)'};
								    dataEmplPosTypeList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
								    widget.jqxDropDownList({ source: dataEmplPosTypeList,  displayMember: 'description', valueMember : 'emplPositionTypeId', 
								    	height: '25px', autoDropDownHeight: false, searchMode: 'containsignorecase', incrementalSearch: true, filterable:true,
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
							{text: '${uiLabelMap.PeriodTypePayroll}', datafield:'periodTypeId' , filterable: false, editable: false, cellsalign: 'left', width: 160,
								cellsrenderer: function (row, column, value){
									for(var i = 0; i < periodTypeArr.length; i++){
										if(periodTypeArr[i].periodTypeId == value){
											return '<div style=\"\">' + periodTypeArr[i].description + '</div>';		
										}
									}
								}
							},
							{text: '${uiLabelMap.PayrollFromDate}', datafield:'fromDate', filterable: false,editable: false, cellsalign: 'left', width: 160, cellsformat: 'dd/MM/yyyy ', columntype: 'template'},
							{text: '${uiLabelMap.PayrollThruDate}', datafield: 'thruDate', filterable: false, editable: true, cellsalign: 'left', width: 160, cellsformat: 'dd/MM/yyyy ', columntype: 'template',
								cellsrenderer: function (row, column, value) {
									if(!value){
										return '<div style=\"margin-left: 4px\">${uiLabelMap.HRCommonCurrent}</div>';
									}
								},
								createeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
							        editor.jqxDateTimeInput({width: 158, height: 28});
							        editor.val(cellvalue);
							    }
							}, 
							{text: '${uiLabelMap.CommonAmount}', datafield: 'rateAmount', filterable: false,editable: true, cellsalign: 'right', width: 160,
								cellsrenderer: function (row, column, value) {
					 		 		 var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		 		 if (data && data.rateAmount){
					 		 		 	return \"<div style='margin-right: 2px; margin-top: 9.5px; text-align: right;'>\" + formatcurrency(data.rateAmount, data.rateCurrencyUomId) + \"</div>\";
					 		 		 }
				 		 		 }								
							},
							
							{text: '', datafield: 'rateCurrencyUomId', hidden: true}"/>
var rowUpdateIndex = -1;
$(document).ready(function () {
	theme = 'olbius';
	var uomArray = new Array();
	 <#list uomList as uom>
	 	var row = {};
	 	row["uomId"] = "${uom.uomId}";
	 	row["description"] = "${uom.description?if_exists}";
	 	uomArray[${uom_index}] = row;
	 </#list>
	 var filterUomAdapter = new $.jqx.dataAdapter(uomArray, {autoBind: true});
	 var dataSoureUomList = filterUomAdapter.records;
	$("#jqxgrid").on('rowDoubleClick', function (event){
		//var dataField = event.args.datafield;
		var rowBoundIndex = event.args.rowindex;
		var data = $('#jqxgrid').jqxGrid('getrowdata', rowBoundIndex);
		var emplPosDes = '';
		rowSelectedIndex = rowBoundIndex;	
		for(var i = 0; i < emplPosTypeArr.length; i++){
			if(emplPosTypeArr[i].emplPositionTypeId == data.emplPositionTypeId){
				emplPosDes = emplPosTypeArr[i].description; 
				break;
			}
		}
		jQuery("#emplPosTypeRateSalary").text(emplPosDes);
		jQuery("#emplPositionTypeId").val(data.emplPositionTypeId);
		$('#editEmplPosTypeRateWindow').jqxWindow('open');			
		
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
	 
	 $("#amountSalary").jqxNumberInput({ width: '250px', height: '25px', spinButtons: false, decimalDigits: 2, digits: 9, max: 999999999, theme: 'olbius', min: 0});
	 $('#editEmplPosTypeRateWindow').jqxWindow({
        showCollapseButton: false, maxHeight: 350, maxWidth: '50%', minHeight: 350, minWidth: '50%', height: 350, width: '50%', theme:'olbius',
        autoOpen: false, 
        initContent: function () {
            
        }
    });
	 $('#editEmplPosTypeRateWindow').on('open', function(event){
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
				         $( this ).dialog( "close" );
				         $('#editEmplPosTypeRateWindow').jqxWindow('close');
				         var dataSubmit = new Array();
						 var partyId = $("#partyId").val();
						 var emplPositionTypeId = $("#emplPositionTypeId").val();
						 var fromDate = $("#payrollFromDate").jqxDateTimeInput('getDate').getTime();
						 var uomId = jQuery("#CurrencyUomIdSalary").jqxDropDownList('getSelectedItem').value;
						 var periodTypeId = $("#periodTypeSalary").jqxDropDownList('getSelectedItem').value;
						 var amount = $("#amountSalary").val();
						 var emplPositionTypeId = $("#emplPositionTypeId").val();		
						 dataSubmit.push({name: "fromDate", value: fromDate});		 
						 dataSubmit.push({name: "uomId", value: uomId});
						 dataSubmit.push({name: "periodTypeId", value: periodTypeId});
						 dataSubmit.push({name: "rateAmount", value: amount});
						 dataSubmit.push({name: "emplPositionTypeId", value: emplPositionTypeId});
						 if($("#payrollThruDate").val()){
							 dataSubmit.push({name: "thruDate", value: $("#payrollThruDate").jqxDateTimeInput('getDate').getTime()});
						 }
						 $.ajax({
							url: "<@ofbizUrl>createEmplPositionTypeRateDateConvert</@ofbizUrl>",
							type: 'POST',
							data: dataSubmit,
							success: function(data){
								//console.log(data);
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
		        	$('#editEmplPosTypeRateWindow').jqxWindow('close');
		        }
		      }
			});		 
		 
		
	 });
	 $("#cancelSubmit").click(function(){
		 $('#editEmplPosTypeRateWindow').jqxWindow('close');
	 });
	 $("#updateNotificationSalary").jqxNotification({
         width: "100%", position: "top-left", opacity: 1, appendContainer: "#appendNotification",
         autoOpen: false, animationOpenDelay: 800, autoClose: false
     });
	 $("#amountValueNew").jqxNumberInput({ width: '250px', height: '25px', spinButtons: false, decimalDigits: 2, digits: 9, max: 999999999, theme: 'olbius', min: 0});
	 
	 $('#periodTypeNew').jqxDropDownList({  source: dataSoureList,
	    	displayMember: "description", valueMember: "periodTypeId", itemHeight: 25, height: 25, width: 250, theme: theme, dropDownHeight: 120,
	        renderer: function (index, label, value) {
	            for(var i = 0; i < periodTypeArr.length; i++){
	            	if(periodTypeArr[i].periodTypeId == value){
	            		return periodTypeArr[i].description; 
	            	}
	            }
	            return value;
	        }
	   });
	 
	 $('#periodTypeNew').val("${defaultPeriodTypeId?if_exists}");
	 $("#fromDateNew").jqxDateTimeInput({width: '250px', height: '25px', formatString: 'dd/MM/yyyy', theme: 'olbius'});
	 $("#thruDateNew").jqxDateTimeInput({width: '250px', height: '25px', formatString: 'dd/MM/yyyy', theme: 'olbius'});
	 $("#thruDateNew").val(null);
	 $("#alterCancel").jqxButton({theme:theme});
	 $("#alterSave").jqxButton({theme:theme});
	 
	 $("#alterSave").click(function(){
		 $("#warningAddRecord").text("${StringUtil.wrapString(uiLabelMap.AddRowDataConfirm)}?" );
			$("#warningAddRecord").dialog({
		      resizable: false,
		      height:180,
		      modal: true,
		      buttons: {
		        "${StringUtil.wrapString(uiLabelMap.wgok)}": function() {						          
			         $( this ).dialog( "close" );
			         $("#popupWindowEmplPosTypeRate").jqxWindow('close');
			         $("#alterSave").jqxButton({disabled: true});
			 		 var thruDate = $("#thruDateNew").jqxDateTimeInput('getDate');
			 		 /* if(thruDate){
			 			 thruDate = $("#thruDateNew").jqxDateTimeInput('getDate').getTime();  
			 		 } */
			 		 var row = {
			     		emplPositionTypeId: $('#setSalaryEmplPositionTypeId').val(),
			     		periodTypeId: $("#periodTypeNew").val(),
			     		rateAmount: $("#amountValueNew").val(),
			     		fromDate: $("#fromDateNew").jqxDateTimeInput('getDate'),
			     		thruDate: thruDate
			     	};
			     	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
				 				                 				                 					          						          
		        },
		        "${StringUtil.wrapString(uiLabelMap.wgcancel)}": function() {
		        	$( this ).dialog( "close" );
		        	$("#popupWindowEmplPosTypeRate").jqxWindow('close');
		        }
		      }
			});
	    
	 });
	 $("#alterCancel").click(function(){
		 $("#popupWindowEmplPosTypeRate").jqxWindow('close');
	 });	 
	 jQuery("#popupWindowEmplPosTypeRate").jqxWindow({showCollapseButton: false, maxHeight: 320, autoOpen: false,
			maxWidth: 700, minHeight: 320, minWidth: 700, height: 320, width: 700, isModal: true, theme:theme});
	 $('#setSalaryEmplPositionTypeId').jqxDropDownList({selectedIndex: 0,
	    	displayMember: "description", valueMember: "emplPositionTypeId", itemHeight: 25, height: 25, width: 250, theme: theme, dropDownHeight: 200,
	    	autoDropDownHeight: false,
	        renderer: function (index, label, value) {
	            for(var i = 0; i < emplPosTypeArr.length; i++){
	            	if(emplPosTypeArr[i].emplPositionTypeId == value){
	            		return emplPosTypeArr[i].description; 
	            	}
	            }
	            return value;
	        }
	   });
	 jQuery("#popupWindowEmplPosTypeRate").on('open', function (event){
		 jQuery.ajax({
			url:  "getEmplPostionTypeNotSetSalary",
			datatType:'json',
			async: false,
			success: function(data){
				if(data.listEmplPositionTypeNotSet.length > 0){
					var source = {
							 datatype: "json",
			                 datafields: [
			                     { name: 'emplPositionTypeId' },
			                     { name: 'description' }
			                 ],
							 localdata:data.listEmplPositionTypeNotSet 				                 	 
					 };
					 var dataAdapter = new $.jqx.dataAdapter(source);
					 
					 $('#setSalaryEmplPositionTypeId').jqxDropDownList({source: dataAdapter});	
					 $("#alterSave").jqxButton({disabled: false});
				}else{
					//jQuery("#EmplPosTypeRateWindowContent").html("<div style='text-align: center'><h4>${uiLabelMap.AllEmplPositionTypeSalarySet}<h4></div>");
					$("#alterSave").jqxButton({disabled: true});
				}	
			}
		 });
		 $("#amountValueNew").val(0);
		 $("#thruDateNew").val(null);
	 });
	 $("#jqxgrid").on('cellEndEdit', function (event){
		 rowUpdateIndex = event.args.rowindex;
	 });
});
function enableAlterSave(){
	 $("#alterSave").jqxButton({disabled: false});
}

function refreshRowDetail(){
	if(rowUpdateIndex > -1 ){
		var id = $('#jqxgrid').jqxGrid('getrowid', rowUpdateIndex);
		 if($("#jqxgridDetail_" + id).length){
			 $("#jqxgridDetail_" + id).jqxGrid('updatebounddata');	 
		 }	
	}
}
function formatcurrency(num, uom){
      decimalseparator = ",";
          thousandsseparator = ".";
          currencysymbol = "đ";
          if(typeof(uom) == "undefined" || uom == null){
           uom = "${currencyUomId?if_exists}";
          }
      if(uom == "USD"){
       currencysymbol = "$";
       decimalseparator = ".";
           thousandsseparator = ",";
      }else if(uom == "EUR"){
       currencysymbol = "€";
       decimalseparator = ".";
           thousandsseparator = ",";
      }
         var str = num.toString().replace(currencysymbol, ""), parts = false, output = [], i = 1, formatted = null;
         if(str.indexOf(".") > 0) {
             parts = str.split(".");
             str = parts[0];
         }
         str = str.split("").reverse();
         for(var j = 0, len = str.length; j < len; j++) {
             if(str[j] != ",") {
                 output.push(str[j]);
                 if(i%3 == 0 && j < (len - 1)) {
                     output.push(thousandsseparator);
                 }
                 i++;
             }
         }
         formatted = output.reverse().join("");
         console(formatted + ((parts) ? decimalseparator + parts[1].substr(0, 2) : "") + "&nbsp;" + currencysymbol);
         return(formatted + ((parts) ? decimalseparator + parts[1].substr(0, 2) : "") + "&nbsp;" + currencysymbol);
     }								
</script>
<div class="row-fluid">
	<div id="appendNotification">
		<div id="updateNotificationSalary">
			<span id="notificationText"></span>
		</div>
	</div>	
</div>	
<#--<!-- removeUrl="jqxGeneralServicer?sname=deleteEmpPosTypeSalary&jqaction=D" deleteColumn="emplPositionTypeId;periodTypeId;fromDate(java.sql.Timestamp)" -->
<#--<!-- updateUrl="jqxGeneralServicer?jqaction=U&sname=updateEmpPosTypeSalary" editmode="selectedcell"
editColumns="emplPositionTypeId;periodTypeId;rateAmount(java.math.BigDecimal);fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp)" -->	
					
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataFields columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" 
		 filterable="true" alternativeAddPopup="popupWindowEmplPosTypeRate" deleterow="false" editable="false" addrow="true"
		 url="jqxGeneralServicer?hasrequest=Y&sname=JQListEmplPositionTypeRate" id="jqxgrid" initrowdetails="true" initrowdetailsDetail=initrowdetailsDetail
		 createUrl="jqxGeneralServicer?jqaction=C&sname=createEmplPositionTypeRateAmount" functionAfterUpdate="refreshRowDetail()" functionAfterAddRow="enableAlterSave()"
		 addColumns="periodTypeId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);rateAmount;emplPositionTypeId" 
		 selectionmode="singlerow"
		 
	/>
<div class="row-fluid">
	<div id="popupWindowEmplPosTypeRate">
		<div id="EmplPosTypeRateWindowHeader">
			 ${uiLabelMap.AddEmpPosTypeSalary}
		</div>
		<div style="overflow: hidden;" id="EmplPosTypeRateWindowContent">
			<form class="form-horizontal">
				<div class="control-group">
					<label class="control-label">${uiLabelMap.EmplPositionTypeId}</label>
					<div class="controls">
						<div id="setSalaryEmplPositionTypeId">
						</div>
					</div>
				</div>								
				<div class="control-group">
					<label class="control-label">${uiLabelMap.CommonPeriodType}</label>
					<div class="controls">
						<div id="periodTypeNew"></div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">${uiLabelMap.AvailableFromDate}</label>
					<div class="controls">
						<div id="fromDateNew"></div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">${uiLabelMap.CommonThruDate}</label>
					<div class="controls">
						<div id="thruDateNew"></div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">${uiLabelMap.CommonAmount}</label>
					<div class="controls">
						<div id="amountValueNew"></div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">&nbsp;</label>
					<div class="controls">
						<input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSubmit}" />
						<input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" />
					</div>
				</div>
			</form>
		</div>
	</div>
</div>	

<div id="editEmplPosTypeRateWindow">
	<div id="windowHeader">
     	${uiLabelMap.EditEmpPosTypeRate}
     </div>	
     <div style="overflow: hidden;" id="windowContent">
     	<div class="row-fluid">
     		<div class="span12">
     			<form class="form-horizontal" method="post">
     				<div class="control-group">
     					<label class="control-label">${uiLabelMap.EmplPositionTypeId}</label>
     					<div class="controls">
     						<span id="emplPosTypeRateSalary"></span>
     						<input type="hidden" name="emplPositionTypeId" id="emplPositionTypeId">
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
<style>
	.ui-dialog { z-index: 200000 !important ;}
</style>
<div class="row-fluid" id="dialogDiv">
	<div id="warningAddRecord" title="${StringUtil.wrapString(uiLabelMap.AddRowRecord)}?">
	
	</div>
</div>
