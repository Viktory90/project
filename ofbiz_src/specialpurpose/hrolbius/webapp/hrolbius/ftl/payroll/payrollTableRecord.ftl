<#if !payrollTimestampResult?exists>
	<#assign payrollTimestampResult = dispatcher.runSync("getPayrollTableRecordTimestamp", Static["org.ofbiz.base.util.UtilMisc"].toMap("payrollTableId", parameters.payrollTableId, "userLogin", userLogin))>	
</#if>
<#if payrollTimestampResult?exists>
	<#assign listTimestamp = payrollTimestampResult.get("listTimestamp")>
	<#if listTimestamp?has_content>
		<#if !tempFromDate?exists>		
			<#assign tempFromDate = listTimestamp.get(0).get("fromDate")>	
		</#if>
		  
		<#assign formulaList = delegator.findByAnd("PayrollTable", Static["org.ofbiz.base.util.UtilMisc"].toMap("payrollTableId", parameters.payrollTableId, "fromDate", tempFromDate), Static["org.ofbiz.base.util.UtilMisc"].toList("code"), false)>
		<#assign formulaListStr = Static["org.ofbiz.entity.util.EntityUtil"].getFieldListFromEntityList(formulaList, "code", true)>
		<#assign dataField = "[{ name: 'partyName', type: 'string'},
	                      {name: 'partyId', type:'string'}"/>
	                      
	    <#assign columnlist = "{text: '${uiLabelMap.EmployeeName}', datafield: 'partyName', cellsalign: 'left', editable: false, width: 130, filterable: false,}, 
							   {text: '${uiLabelMap.EmployeeId}', datafield: 'partyId',cellsalign: 'left', editable: false,width: 100, filterable: false,
									cellsrenderer: function (row, column, value) {
										var data = $('#jqxgrid').jqxGrid('getrowdata', row);
										if (data && data.partyId){
			        						return '<a style = \"margin-left: 10px\" href=' + 'EmployeeProfile?partyId=' + data.partyId + '>' +  data.partyId + '</a>'
			    						}
		    						}
	    						}"/>
	   <#list formulaListStr as formulaCode>
	   		<#assign formula = delegator.findOne("PayrollFormula", Static["org.ofbiz.base.util.UtilMisc"].toMap("code", formulaCode), false)/>
	   		<#assign dataField = dataField + ",">
	   		<#assign dataField = dataField + "{name: '${formulaCode}', type: 'float'}"/>
	   		<#assign columnlist = columnlist + ","/>
	   		<#if formulaCode_has_next>
	   			<#assign width = '120'>
	   		<#else>
	   			<#assign width = 'auto'>	
	   		</#if>
	   		<#assign columnlist = columnlist + "{text: '${formula.name}', dataField: '${formulaCode}',cellsformat: 'c', cellsalign: 'right',width: '${width}', filterable: false}"/>
	   </#list> 		
	   				
	   <#assign dataField = dataField + "]"/>
	   <#assign tempFormulaListStr = Static["org.apache.commons.lang.StringUtils"].join(formulaListStr, ",SPLITARR,")>	   
	   <@jqGrid url="jqxGeneralServicer?sname=getPayrollTableRecord&payrollTableId=${parameters.payrollTableId}&fromDate=${tempFromDate.getTime()}&hasrequest=Y&formulaList=${tempFormulaListStr}" 
	   		dataField=dataField columnlist=columnlist filtersimplemode="false" sortable="false" showtoolbar="false" editable="false" id="jqxgrid"/>           
	</#if>
</#if>
