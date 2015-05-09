<script>
	var statuses = [
		<#if statuses?exists>
			<#list statuses as status>
				{
					statusId : "${status.statusId}",
					description : "${status.description}",
				},
			</#list>
		</#if>
	];
	var periodTypes = [
		<#list periodTypes as period>
			{
				periodTypeId : "${period.periodTypeId}",
				description : "${StringUtil.wrapString(period.description?default(''))}"
			},
		</#list>	
	];
</script>
<#assign dataField="[{ name: 'payrollTableId', type: 'string' },
					 { name: 'payrollTableName', type: 'string' },
					 { name: 'fromDate', type: 'date', other:'Timestamp' },
					 { name: 'thruDate', type: 'date', other:'Timestamp' },
					 { name: 'periodTypeId', type: 'string' },
					 { name: 'statusId', type: 'string'},
					 {name: 'calcPayroll', type:'string'}]
					"/>				

<#assign columnlist="{ text: '${uiLabelMap.HRPayrollTableId}', datafield: 'payrollTableId', width: 90, hidden: false, editable: false,
						cellsrenderer: function(row, column, value){
							return '<a href=\"viewPayrollTable?payrollTableId='+ value + '\">' + value + '</a>';
						}
					 },
 					 { text: '${uiLabelMap.PayrollTableName}', datafield: 'payrollTableName', width: 250},
					 { text: '${uiLabelMap.fromDate}', datafield: 'fromDate',cellsformat: 'dd/MM/yyyy', filtertype:'range', columntype: 'datetimeinput', editable: false},
					 { text: '${uiLabelMap.thruDate}', datafield: 'thruDate',cellsformat: 'dd/MM/yyyy', filtertype:'range',columntype: 'datetimeinput' , editable: false},
					 { text: '${uiLabelMap.PeriodType}', datafield: 'periodTypeId',editable:false, filtertype: 'checkedlist',
					 	createfilterwidget: function(column, columnElement, widget){
						    var filterBoxAdapter = new $.jqx.dataAdapter(periodTypes, {autoBind: true});
							var dataSoureList = filterBoxAdapter.records;
						    dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
						    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'description', autoDropDownHeight: false,valueMember : 'periodTypeId', filterable:true, searchMode:'containsignorecase'});
						},
						cellsrenderer : function(row, column, value){
							var val = $('#jqxgrid').jqxGrid('getrowdata', row);
							for(var x in periodTypes){
								if(periodTypes[x].periodTypeId && val.periodTypeId && periodTypes[x].periodTypeId == val.periodTypeId){
									return '<div style=\"margin-top: 6px; margin-left: 4px;\">'+periodTypes[x].description+'</div>';		
								}
							}
							return '&nbsp;';
						}
					 },
                     { text: '${uiLabelMap.statusId}', datafield: 'statusId', width: 200, editable:false, filtertype: 'checkedlist',
                     	createfilterwidget: function(column, columnElement, widget){
						    var filterBoxAdapter = new $.jqx.dataAdapter(statuses, {autoBind: true});
							var dataSoureList = filterBoxAdapter.records;
						    dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
						    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'description', autoDropDownHeight: false,valueMember : 'statusId', filterable:true, searchMode:'containsignorecase'});
						},
						cellsrenderer : function(row, column, value){
							var val = $('#jqxgrid').jqxGrid('getrowdata', row);
							for(var x in statuses){
								if(statuses[x].statusId  && val.statusId && statuses[x].statusId == val.statusId){
									return '<div style=\"margin-top: 6px; margin-left: 4px;\">'+statuses[x].description+'</div>';		
								}
							}
						}
                     },
					 {text: '${uiLabelMap.HrolbiusFomular}', datafield: 'calcPayroll', width: 70, filterable: false, editable: false,
					 	cellsrenderer: function(row, column, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return '<div style=\"text-align: center\"><form action=\"calcPayroll\" method=\"post\"><input type=\"hidden\" name=\"payrollTableId\" value=\"'+ data.payrollTableId +'\"><button onclick=\"submitForm(this.form,' + row + ')\" type=\"button\" class=\"btn btn-primary btn-mini icon-play\"></button></form></div>'
					 	}
					 },
					 
					 {text: '${uiLabelMap.CreatePayrollInvoice}', width: 100, filterable: false, editable: false,
					 	cellsrenderer: function(row, column, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return '<div style=\"text-align: center\"><a href=\"ApprovalPayrollTable?payrollTableId='+ data.payrollTableId +'\"><i class=\"icon-file-text\"></i></a></div>'
					 	}
					 }"/>

<@jqGrid url="jqxGeneralServicer?sname=JQGetPayroll" dataField=dataField columnlist=columnlist
	clearfilteringbutton="true"
	editable="true" 
	editrefresh ="true"
	editmode="click"
	showtoolbar = "true" deleterow="true"
	removeUrl="jqxGeneralServicer?sname=deletePayrollTable&jqaction=D" deleteColumn="payrollTableId"
	createUrl="jqxGeneralServicer?jqaction=C&sname=createPayrollTableRecord" alternativeAddPopup="popupAddRow" addrow="true" addType="popup" 
	addColumns="payrollTableName;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);periodTypeId;departmentList;formulaList" addrefresh="true"
	updateUrl="jqxGeneralServicer?jqaction=U&sname=updatePayrollTableRecord"  editColumns="payrollTableId;payrollTableName"
/>
	
<div id="popupAddRow" >
    <div>${uiLabelMap.EditPayrollTable}</div>
    <div style="overflow: hidden;">
    	
    	<form name="popupAddRow" action="" id="popupAddRow" class="form-horizontal">
			<div class="row-fluid">
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">
						${uiLabelMap.PayrollTableName}
					</label>
					<div class="controls">
						<input type="text" name="payrollTableNameAdd" id="payrollTableNameAdd">
					</div>
				</div>						   	
		   		<div class="control-group no-left-margin">
		   			<label class="control-label asterisk">
						${uiLabelMap.formulaCode}
					</label>
					<div class="controls">
						<@htmlTemplate.renderPayrollFormula name="formulaList" id="formulaList" payrollFormulaList=parollFormula divId="jqxPayrollBox" width="90%" height="200px"/>
					</div>
		   		</div>	
		   		<div class="control-group no-left-margin">
		   			<label class="control-label asterisk">
		   				${uiLabelMap.Department}
		   			</label>
		   			<div class="controls controls-chzn">
		   				<select name="departmentList" id="departmentListadd" multiple="multiple" class="chzn-select" required>
							<#list directChildDepartment as department>
								<#assign partyName = Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, department.partyId, false)>
								<option value="${department.partyId}" <#if parameters.departmentList?exists && parameters.departmentList?contains(department.partyId)>selected="selected"</#if>>${partyName}</option>
							</#list> 			
						</select>
		   			</div>
		   		</div>	
		   		<div class="control-group no-left-margin">
		   			<label class="control-label asterisk">
		   				${uiLabelMap.CalcSalaryPeriod}
		   			</label>
		   			<div class="controls">
		   				<div id="periodTypeIdDd">
		   				</div>
		   			</div>
		   		</div>
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">
		   				${uiLabelMap.FromDate}
		   			</label>
		   			<div class="controls">
		   				<div id="fromDateJQ"></div>
		   			</div>
				</div>	
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">
		   				${uiLabelMap.ThruDate}
		   			</label>
		   			<div class="controls">
		   				<div id="thruDateJQ"></div>
		   			</div>
				</div>
			</div>	
			<div class="control-group no-left-margin">
				<label class="control-label">&nbsp;</label>
				<div class="controls">
					<button type="button" class='btn btn-primary btn-mini' style="margin-right: 5px; margin-top: 10px;" id="alterSave">
						<i class='fa fa-check'></i>&nbsp;${uiLabelMap.CommonSave}</button>
					<button type="button" class='btn btn-danger btn-mini' style="margin-right: 5px; margin-top: 10px;" id="alterCancel">
						<i class='icon-remove'></i>&nbsp;${uiLabelMap.CommonClose}</button>	
				</div>
			</div>

    	</form>
    </div>
</div>  
<script type="text/javascript">
	var skills = [
		<#if skillTypes?exists>
		<#list skillTypes as skill>
		{
			skillTypeId : "${skill.skillTypeId}",
			description : "${skill.description}"
		},
		</#list>
		</#if>
	];
	
	function submitForm(form, row){
		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		var statusId = data.statusId;
		if(statusId == 'PYRLL_TABLE_CREATED'){
			form.submit();
		}else if(statusId == 'PYRLL_TABLE_CALC'){
			bootbox.dialog({
				message:"${uiLabelMap.PayrollCalculated_Recalculated}", 
				buttons:{
					success: { 
						label: "${uiLabelMap.CommonSubmit}",
						className: 'icon-ok btn btn-mini btn-primary',
						callback: function() {
							form.submit();		
						}
					},
					cancel: {
						label: "${uiLabelMap.CommonClose}",
						className: 'icon-remove btn btn-mini btn-danger',
						callback: function() {
							$(this).modal('hide');		
						}	
					}
				}
			});
		}
	}
	
	$(document).ready(function(){
	   	// $("#setDefault").jqxButton({ template: "primary" });
		// $("#addNewTarget").jqxButton({ template: "primary" });
		// $("#alterSave").jqxButton({ template: "primary" });
		// $("#saveRow").jqxButton({ template: "primary" });
		// $("#cancelRow").jqxButton({ template: "primary" });	
		$.validator.setDefaults({ ignore: ":hidden:not(select)" })
		var skillJqx = $("#jqxgrid");
		var popup = $("#popupAddRow");
		popup.jqxWindow({
	        width: 800, height: 580, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#Cancel"),           
	    });
		$("#alterCancel").click(function(){
			popup.jqxWindow('close');
		});
	    popup.on('close', function (event) { 
	    	popup.jqxValidator('hide');
	    }); 
	    var periodTypeDd = $('#periodTypeIdDd');
		periodTypeDd.jqxDropDownList({
			theme: 'olbius',
			source: periodTypes,
			width: 218,
			displayMember: "description",
			dropDownHeight: 140,
			valueMember: "periodTypeId"
		});
		<#if defaultPeriodType?exists>
			periodTypeDd.jqxDropDownList('selectItem', "${defaultPeriodType}" );
		</#if>
		$("#fromDateJQ").jqxDateTimeInput({
		     height: '30px',
		     width: '218px',
		     theme: 'olbius',
		     value: null
		});
		$("#thruDateJQ").jqxDateTimeInput({
		     height: '30px',
		     width: '218px',
		     theme: 'olbius',
		     value: null
		});
		$("#fromDateJQ").on("change", function(event){
			var tmp = event.args.date;
			var date = new Date((tmp.getYear() + 1900), tmp.getMonth(), tmp.getDate());
			$("#thruDateJQ").jqxDateTimeInput('setMinDate', date);
		});
		$("#thruDateJQ").on("change", function(event){
			var tmp = event.args.date;
			var date = new Date((tmp.getYear() + 1900), tmp.getMonth(), tmp.getDate());
			$("#fromDateJQ").jqxDateTimeInput('setMaxDate', date);
		});
		popup.jqxValidator({
		   	rules: [{
				input: '#payrollTableNameAdd',
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}',
				action: 'blur',
				rule: 'required'
			},{
			    input: '#inputfromDateJQ',
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}',
				action: 'blur',
				rule: 'required'
			},{
			    input: '#inputthruDateJQ',
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}',
				action: 'blur',
				rule: 'required'
			}, {
                input: "#periodTypeIdDd", 
                message: "${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}", 
                action: 'blur', 
                rule: function (input, commit) {
                    var index = $("#periodTypeIdDd").jqxDropDownList('getSelectedIndex');
                    return index != -1;
                }
            }, { 
				input: '#jqxPayrollBox', 
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}', 
				action: 'blur', 
				rule: function (input, commit) {
                    var selected = $("#formulaList").val();
                    
                    if(!selected || !selected.length){
                    	return false;
                    }
                    return true;
                }
			},{ 
				input: '#departmentListadd', 
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}', 
				action: 'blur', 
				rule: function (input, commit) {
                    var selected = $("#departmentListadd").val();
                    if(!selected || !selected.length){
                    	return false;
                    }
                    return true;
                }
			}],
		 });
		$("#alterSave").click(function () {
			if(!$('#popupAddRow').jqxValidator('validate')){
				return;
			}
			var fromDate = Utils.formatDateYMD($('#fromDateJQ').jqxDateTimeInput('getDate'));
			var thruDate = Utils.formatDateYMD($('#thruDateJQ').jqxDateTimeInput('getDate'));
			var i = periodTypeDd.jqxDropDownList('getSelectedItem');
			var periodTypeId = i ? i.value : "";
	    	var row = { 
        		payrollTableName: $("input[name='payrollTableNameAdd']").val(),
        		periodTypeId: periodTypeId,
        		fromDate: fromDate,
        		thruDate: thruDate,
        		departmentList: JSON.stringify($("select[name='departmentList']").val()),
        		formulaList: JSON.stringify($("#formulaList").val())
        	  };
		    skillJqx.jqxGrid('addRow', null, row, "first");
	        // select the first row and clear the selection.
	        skillJqx.jqxGrid('clearSelection');                        
	        skillJqx.jqxGrid('selectRow', 0);  
	        popup.jqxWindow('close');
	    });
	});
    function openPopupCreatePartySkill(){
    	$("#popupAddRow").jqxWindow('open');
    }
</script>