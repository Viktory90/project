<script>
	var periodTypes = [
	<#list periodTypes as period>
		{
			periodTypeId : "${period.periodTypeId}",
			description : "${StringUtil.wrapString(period.description?default(''))}"
		},
	</#list>	
	];
	
	var parameterTypes = [
		<#if parameterTypes?exists>
			<#list parameterTypes as parameterType>
				{
					code : "${parameterType.code}",
					name : "${StringUtil.wrapString(parameterType.name?default(''))}",
					description : "${StringUtil.wrapString(parameterType.description?default(''))}"
				},
			</#list>
		</#if>
	]; 
	var allParameterType=[
				<#if allParameterType?exists>
				<#list allParameterType as parameterType>
					{
						type : "${parameterType.code}",
						name : "${StringUtil.wrapString(parameterType.name?default(''))}",
						description : "${StringUtil.wrapString(parameterType.description?default(''))}"
					},
				</#list>
				</#if>          
	 ];
</script>
<#assign dataField="[{ name: 'code', type: 'string' },
					 { name: 'name', type: 'string' },
					 { name: 'defaultValue', type: 'string' },
					 { name: 'actualValue', type: 'string' },
					 { name: 'description', type: 'string' },
					 {name: 'type', type: 'string'},
					 { name: 'periodTypeId', type: 'string' }]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.HRPayrollCode}', datafield: 'code', width: 150, editable: false},
 					 { text: '${uiLabelMap.parameterName}', datafield: 'name', width: 130, },
 					 {text: '${uiLabelMap.PayrollParamterType}', datafield: 'type', width: '170', editable: false, filtertype: 'checkedlist',
 					 	cellsrenderer : function(row, column, value){
							for(var i = 0; i < allParameterType.length; i++){
								if(allParameterType[i].type &&  allParameterType[i].type == value){
									return '<div style=\"margin-top: 6px; margin-left: 4px;\">'+ allParameterType[i].description+'</div>';		
								}
							}
							return '&nbsp;';
						},
						createfilterwidget: function (column, columnElement, widget) {
					        var sourceParameterType = {
						        localdata: allParameterType,
						        datatype: 'array'
						    };		
							var filterBoxAdapter = new $.jqx.dataAdapter(sourceParameterType, {autoBind: true});
						    var dataParameteTypeList = filterBoxAdapter.records;
						   
						    dataParameteTypeList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
						    widget.jqxDropDownList({ source: dataParameteTypeList,  displayMember: 'description', valueMember : 'type', 
						    	height: '25px', autoDropDownHeight: false,
								renderer: function (index, label, value) {
									for(i=0; i < allParameterType.length; i++){
										if(allParameterType[i].type == value){
											return allParameterType[i].description;
										}
									}
								    return value;
								}
							});	
					    }
 					 },
 					 { text: '${uiLabelMap.HrolbiusDefaultValue}', datafield: 'defaultValue', width: 120, 
 					 	validation: function (cell, value) {
                        	if (!value || isNaN(value)) {
                        		return { result: false, message: \"${StringUtil.wrapString(uiLabelMap.NumberFieldRequired?default(''))}\" };
                       			
                        	}
                        	return true;	
                    	}
 					 },
 					 { text: '${uiLabelMap.actualValue}', datafield: 'actualValue', width: 120,
 					 	validation: function (cell, value) {
                        	if (!value || isNaN(value)) {
                        		return { result: false, message: \"${StringUtil.wrapString(uiLabelMap.NumberFieldRequired?default(''))}\" };
                       			
                        	}
                        	return true;	
                    	}
                     },
 					 { text: '${uiLabelMap.HRolbiusRecruitmentTypeDescription}', datafield: 'description', width: 250},
 					 { text: '${uiLabelMap.CommonPeriodType}', datafield: 'periodTypeId', editable: false, filtertype: 'checkedlist',
 					 	createfilterwidget: function(column, columnElement, widget){
						    var filterBoxAdapter = new $.jqx.dataAdapter(periodTypes, {autoBind: true});
							var dataSoureList = filterBoxAdapter.records;
						    dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
						    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'description',
						    		autoDropDownHeight: false,valueMember : 'periodTypeId', filterable:true, searchMode:'containsignorecase'});
						},
						cellsrenderer : function(row, column, value){
							var val = $('#jqxgrid').jqxGrid('getrowdata', row);
							for(var x in periodTypes){
								if(periodTypes[x].periodTypeId &&  periodTypes[x].periodTypeId == value){
									return '<div style=\"margin-top: 6px; margin-left: 4px;\">'+periodTypes[x].description+'</div>';		
								}
							}
							return '&nbsp;';
						}
 					 }"/>
					 
<@jqGrid url="jqxGeneralServicer?sname=JQGetPayrollParameters" dataField=dataField columnlist=columnlist
	clearfilteringbutton="true"
	editable="true" 
	showtoolbar = "true"
	editmode="click"
	deleterow="true"
	removeUrl="jqxGeneralServicer?jqaction=D&sname=deletePayrollParameter" deleteColumn="code"
	createUrl="jqxGeneralServicer?jqaction=C&sname=createPayrollParameter" alternativeAddPopup="popupAddRow" addrow="true" addType="popup" 
	addColumns="code;name;defaultValue;periodTypeId;type;actualValue;description" addrefresh="true"
	updateUrl="jqxGeneralServicer?jqaction=U&sname=updatePayrollParameter"  editColumns="code;name;defaultValue;actualValue;periodTypeId;description"
/>
<div id="popupAddRow" >
    <div>${uiLabelMap.CreateNewParameters}</div>
    <div style="overflow: hidden;">
    	<form name="popupAddRow" action="" id="popupAddRow" class="form-horizontal">
			<div class="control-group">
				<label class="control-label asterisk">${uiLabelMap.parameterCode}</label>
				<div class="controls">
					<input type="text" name="codeadd" id="codeadd" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label asterisk" >${uiLabelMap.parameterName}</label>
				<div class="controls">
					<input type="text" name="nameadd" id="nameadd"/>
				</div>
			</div>
			<div class="control-group">
				<label class='control-label asterisk'>${uiLabelMap.CalcSalaryPeriod}</label>
				<div class="controls">
					<div id="periodTypeIdDd">
						
	   				</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label asterisk" >${uiLabelMap.parameterType}</label>
				<div class="controls">
					<div id="parameterTypeAdd"></div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" >${uiLabelMap.actualValue}</label>
				<div class="controls">
					<input type="text" name="actualvalueadd" id="actualvalueadd" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">${uiLabelMap.HrolbiusDefaultValue}</label>
				<div class="controls">
					<input type="text" name="defaultvalueadd" id="defaultvalueadd" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" >${uiLabelMap.HRolbiusRecruitmentTypeDescription}</label>
				<div class="controls">
					<input type="text" name="descriptionadd" id="descriptionadd"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" >&nbsp;</label>
				<div class="controls">
					<button type="button" class='btn btn-primary btn-mini' style="margin-right: 5px; margin-top: 10px;" id="alterSave"><i class='fa fa-check'></i>&nbsp;${uiLabelMap.CommonSave}</button>
				</div>
			</div>
    	</form>
   
    </div>
</div>  
<script type="text/javascript">
	$(document).ready(function(){	
		var skillJqx = $("#jqxgrid");
		var popup = $("#popupAddRow");
		popup.jqxWindow({
	        width: 600, height: 470, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#Cancel")           
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
			valueMember : "periodTypeId"
		});
		<#if (periodTypes?size < 8)>
			periodTypeDd.jqxDropDownList({autoDropDownHeight: true});		
		</#if>
		var parameterTypeDd = $('#parameterTypeAdd');
		parameterTypeDd.jqxDropDownList({
			theme: 'olbius',
			source: parameterTypes,
			width: 218,
			displayMember: "description",
			valueMember : "code"
		});
		<#if (parameterTypes?size < 8)>
			parameterTypeDd.jqxDropDownList({autoDropDownHeight: true});
		</#if>
		popup.jqxValidator({
		   	rules: [{
			    input: '#codeadd',
				message: '${StringUtil.wrapString(uiLabelMap.IdNotSpace?default(''))}',
				action: 'blur',
				rule: function (input, commit) {
                    var s= $("#codeadd").val();
                    if (/\s/.test(s)) {
					    return false;
					}
					return true;
                }
			},{
			    input: '#nameadd',
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}',
				action: 'blur',
				rule: 'required'
			},{
                input: "#parameterTypeAdd", 
                message: "${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}", 
                action: 'blur', 
                rule: function (input, commit) {
                    var index = $("#parameterTypeAdd").jqxDropDownList('getSelectedIndex');
                    return index != -1;
                }
            },
            {
                input: "#periodTypeIdDd", 
                message: "${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}", 
                action: 'blur', 
                rule: function (input, commit) {
                    var index = $("#periodTypeIdDd").jqxDropDownList('getSelectedIndex');
                    return index != -1;
                }
            },
            {
                input: "#defaultvalueadd", 
                message: "${StringUtil.wrapString(uiLabelMap.NumberRequired?default(''))}", 
                action: 'change', 
                rule: function (input, commit) {
                	var val = $("#defaultvalueadd").val();
                    return isNaN(val) ? false : true;
                }
            },{
                input: "#actualvalueadd", 
                message: "${StringUtil.wrapString(uiLabelMap.NumberRequired?default(''))}", 
                action: 'change', 
                rule: function (input, commit) {
                	var val = $("#actualvalueadd").val();
                    return isNaN(val) ? false : true;
                }
            }]
		 });
		 
		$("#alterSave").click(function () {
			if(!$('#popupAddRow').jqxValidator('validate')){
				return;
			}
			var i = periodTypeDd.jqxDropDownList('getSelectedItem');
			var j = parameterTypeDd.jqxDropDownList('getSelectedItem');
			var periodTypeId = i ? i.value : "";
			var type = j ? j.value : "";
	    	var row = { 
        		code: $("#codeadd").val(),
        		name: $("#nameadd").val(),
        		defaultValue: $("#defaultvalueadd").val(),
        		periodTypeId: periodTypeId,
        		type: type,
        		actualValue : $("#actualvalueadd").val(),
        		description : $("#descriptionadd").val()
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