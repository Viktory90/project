
<script type="text/javascript">
<#assign itlength = listCurrency.size()/>
<#if listCurrency?size gt 0>
    <#assign lc="var lc = ['" + StringUtil.wrapString(listCurrency.get(0).uomId?if_exists) + "'"/>
	<#assign lcValue="var lcValue = [\"" + StringUtil.wrapString(listCurrency.get(0).abbreviation?if_exists) + ":" + StringUtil.wrapString(listCurrency.get(0).description?if_exists) +"\""/>
	<#if listCurrency?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lc=lc + ",'" + StringUtil.wrapString(listCurrency.get(i).uomId?if_exists) + "'"/>
			<#assign lcValue=lcValue + ",\"" + StringUtil.wrapString(listCurrency.get(i).abbreviation?if_exists) + ":" + StringUtil.wrapString(listCurrency.get(i).description?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lc=lc + "];"/>
	<#assign lcValue=lcValue + "];"/>
<#else>
	<#assign lc="var lc = [];"/>
	<#assign lcValue="var lcValue = [];"/>
</#if>
${lc}
${lcValue}	
var dataLC = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["uomId"] = lc[i];
    row["description"] = lcValue[i];
    dataLC[i] = row;
} 

</script>
<#assign dataField="[{ name: 'requirementId', type: 'string' },
					 { name: 'requirementTypeId', type: 'string' },
					 { name: 'statusId', type: 'string' },
					 { name: 'description', type: 'string' },
					 { name: 'requirementStartDate', type: 'date', other: 'Timestamp' },
					 { name: 'requiredByDate', type: 'date', other: 'Timestamp' },
					 { name: 'estimatedBudget', type: 'number' },
					 { name: 'currencyUomId', type: 'string' },
					 { name: 'quantity', type: 'number' },
					 { name: 'useCase', type: 'string' },
					 { name: 'reason', type: 'string' },
					 { name: 'createdByUserLogin', type: 'string'},
					 { name: 'createdDepartment', type: 'string' },
					 ]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.proposalId}', datafield: 'requirementId', editable: false, width:50,
						cellsrenderer: function (row, column, value) {
						var data = $('#jqxgrid').jqxGrid('getrowdata', row);
       					return '<a style = \"margin-left: 10px\" href=' + 'viewProcurementProposal?requirementId=' + data.requirementId + '>' +  data.requirementId + '</a>'
   						}
					 },
					 { text: '${uiLabelMap.statusId}', datafield: 'statusId', editable: false, width: 100},
				
					 { text: '${uiLabelMap.estimatedBudget}', datafield: 'estimatedBudget', width:100,cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + formatcurrency(data.estimatedBudget,data.currencyUomId) + \"</span>\";
					 	}},
					 { text: '${uiLabelMap.currencyUomId}', datafield: 'currencyUomId', width: 100},
					 { text: '${uiLabelMap.requirementStartDate}', datafield: 'requirementStartDate',filtertype: 'range',cellsformat: 'dd/MM/yyyy',  width: 80},
					 { text: '${uiLabelMap.requiredByDate}', datafield: 'requiredByDate',filtertype: 'range',cellsformat: 'dd/MM/yyyy',  width: 80},
					 { text: '${uiLabelMap.Description}', datafield: 'description'}"/>
<#if showColumns>
	<#assign columnlist = columnlist + 
	",{ text: '${uiLabelMap.CreatedBy}', datafield: 'createdByUserLogin', width: 150},
 	{ text: '${uiLabelMap.Department}', datafield: 'createdDepartment', width: 150}
 	"/>
</#if>						
<@jqGrid url="jqxGeneralServicer?sname=JQListShoppingProposal&userLogin=${userLogin}" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" 
		 otherParams="createdDepartment:S-getDepartmentFromUserLogin(createdByUserLogin)<departmentName>;"	 
 />
 
 <div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.requirementStartDate}</td>
	 			<td align="left"><div id="requirementStartDate"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.requiredByDate}:</td>
	 			<td align="left"><div id="requiredByDate"> </div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.estimatedBudget}:</td>
	 			<td align="left">
	 				<input id="estimatedBudget"></input>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.currencyUomId}:</td>
	 			<td align="left">
	 				<div id="currencyUomId"></div>
	 			</td>
    	 	</tr>
			<tr>
    	 		<td align="right">${uiLabelMap.reason}:</td>
	 			<td align="left">
	 				<input id="reason"></input>
	 			</td>
    	 	</tr>
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div> 
<script type="text/javascript">
	var sourceLC =
	{
	    localdata: dataLC,
	    datatype: "array"
	};
	var dataAdapterLC = new $.jqx.dataAdapter(sourceLC);
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	$("#requirementStartDate").jqxDateTimeInput({width: '200px', height: '25px'});
	$("#requiredByDate").jqxDateTimeInput({width: '200px', height: '25px'});
	$("#requiredByDate").val(null);
	$("#estimatedBudget").jqxInput({width: '195px'});
	$('#currencyUomId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLC, displayMember: "description", valueMember: "uomId"});
	$("#reason").jqxInput({width: '195px'});
	$("#alterpopupWindow").jqxWindow({
        width: 580, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });

    $("#alterCancel").jqxButton();
    $("#alterSave").jqxButton();
    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
    	var row;
        row = { 
        		requirementStartDate:$('#requirementStartDate').jqxDateTimeInput('getDate'),
        		requiredByDate:$('#requirementStartDate').jqxDateTimeInput('getDate'),
        		estimatedBudget:$('#estimatedBudget').val(),
        		currencyUomId:$('#currencyUomId').val(),
        		reason:$('#reason').val()
        		         
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
        // select the first row and clear the selection.
        $("#jqxgrid").jqxGrid('clearSelection');                        
        $("#jqxgrid").jqxGrid('selectRow', 0);  
        $("#alterpopupWindow").jqxWindow('close');
    });
</script> 
 
 	