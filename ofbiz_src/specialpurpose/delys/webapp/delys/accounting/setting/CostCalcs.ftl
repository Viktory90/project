<script type="text/javascript" language="Javascript">
	<#assign itlength = listGlAccountType.size()/>
    <#if listGlAccountType?size gt 0>
	    <#assign lglat="var lglat = ['" + StringUtil.wrapString(listGlAccountType.get(0).glAccountTypeId?if_exists) + "'"/>
		<#assign lglatValue="var lglatValue = [\"" + StringUtil.wrapString(listGlAccountType.get(0).glAccountTypeId?if_exists) + ":" + StringUtil.wrapString(listGlAccountType.get(0).description?if_exists) +"\""/>
		<#if listGlAccountType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lglat=lglat + ",'" + StringUtil.wrapString(listGlAccountType.get(i).glAccountTypeId?if_exists) + "'"/>
				<#assign lglatValue=lglatValue + ",\"" + StringUtil.wrapString(listGlAccountType.get(i).glAccountTypeId?if_exists) + ":" + StringUtil.wrapString(listGlAccountType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lglat=lglat + "];"/>
		<#assign lglatValue=lglatValue + "];"/>
	<#else>
    	<#assign lglat="var lglat = [];"/>
    	<#assign lglatValue="var lglatValue = [];"/>
    </#if>
	${lglat}
	${lglatValue}	
	
	var dataGLAT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["glAccountTypeId"] = lglat[i];
        row["description"] = lglatValue[i];
        dataGLAT[i] = row;
    }


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
    

	
	<#assign itlength = listCustomMethod.size()/>
    <#if listCustomMethod?size gt 0>
	    <#assign lcm="var lcm = ['" + StringUtil.wrapString(listCustomMethod.get(0).customMethodId?if_exists) + "'"/>
		<#assign lcmValue="var lcmValue = [\"" + StringUtil.wrapString(listCustomMethod.get(0).customMethodName?if_exists) + ":" + StringUtil.wrapString(listCustomMethod.get(0).description?if_exists) +"\""/>
		<#if listCurrency?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lcm=lcm + ",'" + StringUtil.wrapString(listCustomMethod.get(i).customMethodId?if_exists) + "'"/>
				<#assign lcmValue=lcmValue + ",\"" + StringUtil.wrapString(listCustomMethod.get(i).customMethodName?if_exists) + ":" + StringUtil.wrapString(listCustomMethod.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lcm=lcm + "];"/>
		<#assign lcmValue=lcmValue + "];"/>
	<#else>
    	<#assign lcm="var lcm = [];"/>
    	<#assign lcmValue="var lcmValue = [];"/>
    </#if>
	${lcm}
	${lcmValue}	
	
	var dataCustomMethod = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["customMethodId"] = lcm[i];
        row["description"] = lcmValue[i];
        dataCustomMethod[i] = row;
    }
    
</script>
<#assign dataField="[{ name: 'costComponentCalcId', type: 'string' },
						 { name: 'description', type: 'string' },
						 { name: 'costGlAccountTypeId', type: 'string' },
						 { name: 'offsettingGlAccountTypeId', type: 'string' },
						 { name: 'fixedCost', type: 'number'},
						 { name: 'variableCost', type: 'number'},
						 { name: 'perMilliSecond', type: 'number' },
						 { name: 'currencyUomId', type: 'string' },
						 { name: 'costCustomMethodId', type: 'string' }
						 ]
						 "/>
<#assign columnlist="{ text: '${uiLabelMap.costComponentCalcId}', datafield: 'costComponentCalcId', width: 100},
					 { text: '${uiLabelMap.description}', datafield: 'description', width: 190},
					 { text: '${uiLabelMap.costGlAccountTypeId}', datafield: 'costGlAccountTypeId', width: 200, columntype: 'dropdownlist',
					 	createeditor: function (row, column, editor) {
                            var sourceGlat =
						    {
						        localdata: dataGLAT,
						        datatype: \"array\"
						    };
						   
						    var dataAdapterGlat = new $.jqx.dataAdapter(sourceGlat);
						    
                            editor.jqxDropDownList({source: dataAdapterGlat, displayMember:\"glAccountTypeId\", valueMember: \"glAccountTypeId\",
                            renderer: function (index, label, value) {
			                    var datarecord = dataGLAT[index];
			                    return datarecord.description;
			                } 
                        }); 
					 }},
                     { text: '${uiLabelMap.offSettingGlAccountType}', datafield: 'offsettingGlAccountTypeId', width: 200,columntype: 'dropdownlist',
                     	createeditor: function (row, column, editor) {
                            var sourceGlat =
						    {
						        localdata: dataGLAT,
						        datatype: \"array\"
						    };
						    var dataAdapterGlat = new $.jqx.dataAdapter(sourceGlat);
						    
                            editor.jqxDropDownList({source: dataAdapterGlat, displayMember:\"glAccountTypeId\", valueMember: \"glAccountTypeId\",
                            renderer: function (index, label, value) {
			                    var datarecord = dataGLAT[index];
			                    return datarecord.description;
			                } 
                        }); 
                     
                     }},
                     { text: '${uiLabelMap.fixedCost}', datafield: 'fixedCost', width: 150},
                     { text: '${uiLabelMap.variableCost}', datafield: 'variableCost', width: 150 },
                     { text: '${uiLabelMap.permilisecond}', datafield: 'perMilliSecond'},
					 { text: '${uiLabelMap.currency}', datafield: 'currencyUomId'},
					 { text: '${uiLabelMap.costCustomMethod}', datafield: 'costCustomMethodId', width: 130}
					 "/>
<div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.costGlAccountTypeId}:</td>
	 			<td align="left"><div id="costGlAccountTypeId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.offsettingGlAccountTypeId}:</td>
	 			<td align="left"><div id="offsettingGlAccountTypeId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.description}:</td>
	 			<td align="left"><input id="description"></input></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.fixedCost}:</td>
	 			<td align="left"><div  id="fixedCost"></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.variableCost}:</td>
	 			<td align="left"><div  id="variableCost"></div><td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.perMilliSecond}:</td>
	 			<td align="left"><div id="perMilliSecond"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.currency}:</td>
	 			<td align="left"><div id="currencyUomId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.costCustomMethodId}:</td>
	 			<td align="left"><div id="costCustomMethodId"></td>
    	 	</tr>
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div>					 
<@jqGrid url="jqxGeneralServicer?sname=JQListCosts" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true"
		 editable="true" deleterow="true" editrefresh="true"
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow" createUrl="jqxGeneralServicer?jqaction=C&sname=createCostComponentCalc"
		 addColumns="description;fixedCost(java.lang.Float);costGlAccountTypeId;offsettingGlAccountTypeId;fixedCost(java.lang.Float);variableCost(java.lang.Long);perMilliSecond(java.lang.Float);currencyUomId;costCustomMethodId;organizationPartyId]" clearfilteringbutton="true"
		 updateUrl="jqxGeneralServicer?jqaction=U&sname=updateCostComponentCalc" 
		 editColumns="costComponentCalcId;description;costGlAccountTypeId;offsettingGlAccountTypeId;fixedCost;variableCost;perMilliSecond;currencyUomId;costCustomMethodId"
		 removeUrl="jqxGeneralServicer?sname=removeCostComponentCalc&jqaction=D" deleteColumn="costComponentCalcId" 
 />

<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	var sourceGlat =
    {
        localdata: dataGLAT,
        datatype: "array"
    };
    var dataAdapterGlat = new $.jqx.dataAdapter(sourceGlat);
    
    
    var sourceCurrency =
    {
        localdata: dataLC,
        datatype: "array"
    };
    var dataAdapterCurrency = new $.jqx.dataAdapter(sourceCurrency);
    
    var sourceCustomMethod =
    {
        localdata: dataCustomMethod,
        datatype: "array"
    };
    var dataAdapterCustomMethod = new $.jqx.dataAdapter(sourceCustomMethod);
    
    $('#costGlAccountTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGlat, displayMember: "description", valueMember: "glAccountTypeId"});
    $('#offsettingGlAccountTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGlat, displayMember: "description", valueMember: "glAccountTypeId"});
    $('#description').jqxInput({width:195,theme:theme, placeHolder: "${StringUtil.wrapString(uiLabelMap.description	)}"} );
    $("#fixedCost").jqxNumberInput({ width: '200px', inputMode: 'simple', spinButtons: true });
    $("#variableCost").jqxNumberInput({ width: '200px', inputMode: 'simple', spinButtons: true });
	$("#perMilliSecond").jqxNumberInput({ width: '200px', inputMode: 'simple', spinButtons: true });
	$('#currencyUomId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterCurrency, displayMember: "description", valueMember: "uomId"});
	$('#costCustomMethodId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterCustomMethod, displayMember: "description", valueMember: "customMethodId"});
	
    $("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
	$("#alterSave").click(function () {
		var row;
        row = {
        		
        		costGlAccountTypeId: $('#costGlAccountTypeId').val(),
        		offsettingGlAccountTypeId: $('#offsettingGlAccountTypeId').val(),
        		
        		description: $('#description').val(),
        		fixedCost: $('#fixedCost').val(),
        		
        		variableCost: $('#variableCost').val(),
        		perMilliSecond: $('#perMilliSecond').val(),
        		currencyUomId : $('#currencyUomId').val(),
        		costCustomMethodId:$('#costCustomMethodId').val()              
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
       $("#alterpopupWindow").jqxWindow('close');
		
	});
</script>