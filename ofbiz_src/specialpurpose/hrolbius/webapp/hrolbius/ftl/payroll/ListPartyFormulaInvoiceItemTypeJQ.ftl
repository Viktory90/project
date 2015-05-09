<script>
	var departments = [
		<#if directChildDepartment?exists>
			<#list directChildDepartment as department>
				<#assign partyName = Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, department.partyId, false)>
				{
					partyId : "${department.partyId}",
					groupName : "${partyName}"
				},
			</#list>
		</#if>
	];
</script>
<#assign dataField="[{ name: 'code', type: 'string' },
					{ name: 'groupName', type: 'string' },
					{ name: 'description', type: 'string' },
					 { name: 'partyId', type: 'string' },
					 { name: 'invoiceItemTypeId', type: 'string' },
					 { name: 'fromDate', type: 'date', other: 'Timestamp'},
					 {name: 'thruDate', type: 'date', other: 'Timestamp'}]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.FormulaCode}',  filtertype: 'checkedlist', datafield: 'code', width: 250, editable: false},
 					 { text: '${uiLabelMap.Department}', filtertype: 'checkedlist', datafield: 'partyId', width: 300, editable: false,
 						 createfilterwidget: function(column, columnElement, widget){
						    var filterBoxAdapter = new $.jqx.dataAdapter(departments, {autoBind: true});
							var dataSoureList = filterBoxAdapter.records;
						    dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
						    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'groupName', dropDownHeight: 300, autoDropDownHeight: false,valueMember : 'partyId', filterable:true, searchMode:'containsignorecase'});
						},
						cellsrenderer : function(row, column, value){
							var val = $('#jqxgrid').jqxGrid('getrowdata', row);
							return '<div style=\"margin-top: 6px; margin-left: 4px;\">'+val.groupName+'</div>';
						}
					 },
 					 { text: '${uiLabelMap.FormFieldTitle_perfReviewItemTypeId}', filtertype: 'checkedlist', datafield: 'invoiceItemTypeId', width: 280, editable: false,
 					  createfilterwidget: function(column, columnElement, widget){
						    var filterBoxAdapter = new $.jqx.dataAdapter(invoiceItems, {autoBind: true});
							var dataSoureList = filterBoxAdapter.records;
						    dataSoureList.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
						    widget.jqxDropDownList({ source: dataSoureList, displayMember: 'description', dropDownHeight: 300, autoDropDownHeight: false, valueMember : 'invoiceItemTypeId',  filterable:true, searchMode:'containsignorecase'});
						},
						cellsrenderer : function(row, column, value){
							var val = $('#jqxgrid').jqxGrid('getrowdata', row);
							return '<div style=\"margin-top: 6px; margin-left: 4px;\">'+val.description+'</div>';
						}
					 },
					 { text: '${uiLabelMap.fromDate}', datafield: 'fromDate',cellsformat: 'dd/MM/yyyy', filtertype:'range', editable: false,columntype: 'datetimeinput'},
					 { text: '${uiLabelMap.CommonThruDate}', datafield: 'thruDate', cellsformat: 'dd/MM/yyyy', editable: true, filtertype:'range', columntype: 'datetimeinput'}
					 "/>
					 
<@jqGrid url="jqxGeneralServicer?sname=JQGetPartyFormulaInvoiceItemType" dataField=dataField columnlist=columnlist
	clearfilteringbutton="true"
	editable="true" 
	editrefresh ="true"
	editmode="click"
	autorowheight="true"
	showtoolbar = "true" deleterow="true"
	updateUrl="jqxGeneralServicer?jqaction=U&sname=updatePartyFormulaInvoiceItemType" editColumns="partyId;invoiceItemTypeId;code;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp)"
	removeUrl="jqxGeneralServicer?sname=deletePartyFormulaInvoiceItemType&jqaction=D" deleteColumn="partyId;invoiceItemTypeId;code;fromDate(java.sql.Timestamp)"
	createUrl="jqxGeneralServicer?jqaction=C&sname=createPartyFormulaInvoiceItemType" alternativeAddPopup="popupAddRow" addrow="true" addType="popup" 
	addColumns="invoiceItemTypeId;code;partyListId;fromDate(java.sql.Timestamp)" editmode="selectedcell" addrefresh="true"
/>
	
<div id="popupAddRow" >
    <div>${uiLabelMap.CommonAddSetting}</div> 
    <div style="overflow: hidden;">
    	<form name="popupAddRow" action="" id="popupAddRow" class="form-horizontal">
			<div class="control-group no-left-margin">
				<label class="control-label asterisk">${uiLabelMap.formulaName}</label>
				<div class="controls">
					<div id="codeadd">
						<script>
							var codes = [
								<#list formulaList as formula>
									{
										code: "${formula.code}",
										name: "${StringUtil.wrapString(formula.name?default(''))}"
									},
								</#list>
							];
						</script>
					</div>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label asterisk">${uiLabelMap.AccountingInvoicePurchaseItemType}</label>
				<div class="controls">
					<div id='invoiceItemTypeIdJQ'>
						<script>
							var invoiceItems = [
								<#list invoiceItemTypeList as invoiceItemType>	
									{
										invoiceItemTypeId: "${invoiceItemType.invoiceItemTypeId}",
										description : "${StringUtil.wrapString(invoiceItemType.description?default(''))}"
									},
								</#list>
							];
						</script>
					</div>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label asterisk">${uiLabelMap.Department}</label>
				<div class="controls">
					<div id="partyListId"></div>					
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label">${uiLabelMap.AvailableFromDate}</label>
				<div class="controls">
					<div id="fromDateJQ"></div>
				</div>
			</div>
			<div class="control-group no-left-margin">
				<label class="control-label">&nbsp;</label>
				<div class="controls">
					<button type="button" class='btn btn-mini btn-primary' style="margin-right: 5px; margin-top: 10px;" id="alterSave"><i class='fa fa-check'></i>&nbsp;${uiLabelMap.CommonSave}</button>
				</div>
			</div>
    	</form>
    </div>
</div>  
<script type="text/javascript">
	var partyIdArr = new Array();
	<#list directChildDepartment as department>
		<#assign partyName = Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, department.partyId, false)>
		var row = {};
		row["partyId"] = "${department.partyId}";
		row["groupName"] = "${partyName}";
		partyIdArr[${department_index}] = row;
	</#list>
	var partyIdSource = {
	        localdata: partyIdArr,
	        datatype: "array"
	};
    var filterBoxAdapter = new $.jqx.dataAdapter(partyIdSource, {autoBind: true});
    var dataSoureList = filterBoxAdapter.records;
    
	$(document).ready(function(){	
		$("#partyListId").jqxComboBox({source: dataSoureList, placeHolder:'', displayMember: 'groupName',dropDownHeight:'200px',  
	    	valueMember : 'partyId', height: '25px', width: 218, theme: 'olbius',multiSelect: true,  
			renderer: function (index, label, value) {
				for(i=0; i < partyIdArr.length; i++){
					if(partyIdArr[i].partyId == value){
						return partyIdArr[i].groupName;
					}
				}
			    return value;
			}
		});
		var skillJqx = $("#jqxgrid");
		var popup = $("#popupAddRow");
		popup.jqxWindow({
	        width: 600, height: 320, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#Cancel")           
	    });
	    popup.on('close', function (event) { 
	    	popup.jqxValidator('hide');
	    }); 
	    var invoiceItemTypes = $('#invoiceItemTypeIdJQ');
		invoiceItemTypes.jqxDropDownList({
			theme: 'olbius',
			source: invoiceItems,
			width: 218,
			displayMember: "description",
			valueMember: "invoiceItemTypeId"
		});
		
		var codeadd = $('#codeadd');
		codeadd.jqxDropDownList({
			theme: 'olbius',
			source: codes,
			width: 218,
			displayMember: "name",
			valueMember: "code"
		});
		$("#fromDateJQ").jqxDateTimeInput({
		     height: '30px',
		     width: '218px',
		     theme: 'olbius',
		     value: null
		});
		
		popup.jqxValidator({
		   	rules: [{
			    input: '#inputfromDateJQ',
				message: '${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}',
				action: 'blur',
				rule: 'required'
			},{
                input: "#codeadd", 
                message: "${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}", 
                action: 'blur', 
                rule: function (input, commit) {
                    var index = $("#codeadd").jqxDropDownList('getSelectedIndex');
                    return index != -1;
                }
            }, {
                input: "#invoiceItemTypeIdJQ", 
                message: "${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}", 
                action: 'blur', 
                rule: function (input, commit) {
                    var index = $("#invoiceItemTypeIdJQ").jqxDropDownList('getSelectedIndex');
                    return index != -1;
                }
            }, {
                input: "#partyListId", 
                message: "${StringUtil.wrapString(uiLabelMap.FieldRequired?default(''))}", 
                action: 'blur', 
                rule: function (input, commit) {
                    var val = $("#partyListId").val();
                    var flag = val && val.length ? true : false;
                    return flag;
                }
            }],
		 });
		$("#alterSave").click(function () {
			if(!$('#popupAddRow').jqxValidator('validate')){
				return;
			}
			var fromDate = Utils.formatDateYMD($('#fromDateJQ').jqxDateTimeInput('getDate'));
			var i = invoiceItemTypes.jqxDropDownList('getSelectedItem');
			var j = codeadd.jqxDropDownList('getSelectedItem');
			var invoiceItemTypeId = i ? i.value : "";
			var code = j.value;
			var partyIdListChoose = $("#partyListId").jqxComboBox('getSelectedItems');
			var partyIdSubmitArr = new Array();
			for(var i = 0; i < partyIdListChoose.length; i++){
				partyIdSubmitArr.push({partyId: partyIdListChoose[i].value});
			}
			//console.log(partyIdSubmitArr);
	    	var row = { 
        		invoiceItemTypeId: invoiceItemTypeId,
        		partyListId: JSON.stringify(partyIdSubmitArr),
        		fromDate: fromDate,
        		code: code,
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