<script type="text/javascript" language="Javascript">
	
	<#assign periodTypeListX = delegator.findList("PeriodType",  Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("groupPeriodTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].EQUALS , "FISCAL_ACCOUNT"), null, null, null, false) />
	var dataPT = new Array();
	<#list periodTypeListX as periodType>
		<#assign description = StringUtil.wrapString(periodType.get("description", locale)) />
		var row = {};
		row['description'] = "${description}";
		row['periodTypeId'] = "${periodType.periodTypeId}";
		dataPT[${periodType_index}] = row;
	</#list>
	
    <#assign itlength = openTimePeriods.size()/>
    <#if openTimePeriods?size gt 0>
	    <#assign lotp="var lotp = ['" + StringUtil.wrapString(openTimePeriods.get(0).customTimePeriodId?if_exists) + "'"/>
		<#assign lotpValue="var lotpValue = ['" + StringUtil.wrapString(openTimePeriods.get(0).customTimePeriodId?if_exists) + ":" + StringUtil.wrapString(openTimePeriods.get(0).periodName?if_exists) + ":" + StringUtil.wrapString(openTimePeriods.get(0).fromDate?string?if_exists)
					+ "-" + StringUtil.wrapString(openTimePeriods.get(0).thruDate?string?if_exists) + "'"/>
		<#if openTimePeriods?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lotp=lotp + ",'" + StringUtil.wrapString(openTimePeriods.get(i).customTimePeriodId?if_exists) + "'"/>
				<#assign lotpValue=lotpValue + ",'" + StringUtil.wrapString(openTimePeriods.get(i).customTimePeriodId?if_exists) + ":" + StringUtil.wrapString(openTimePeriods.get(i).periodName?if_exists) + ":" + StringUtil.wrapString(openTimePeriods.get(i).fromDate?string?if_exists)
						+ "-" + StringUtil.wrapString(openTimePeriods.get(i).thruDate?string?if_exists) + "'"/>
			</#list>
		</#if>
		<#assign lotp=lotp + "];"/>
		<#assign lotpValue=lotpValue + "];"/>
	<#else>
    	<#assign lotp="var lotp = [];"/>
    	<#assign lotpValue="var lotpValue = [];"/>
    </#if>
	${lotp}
	${lotpValue}	
	var dataOtp = new Array();
	row["customTimePeriodId"] = "";
    row["periodName"] = "";
    dataOtp[0] = row;
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["customTimePeriodId"] = lotp[i];
        row["periodName"] = lotpValue[i];
        dataOtp[i+1] = row;
    }
    <#assign itlength = closedTimePeriods.size()/>
    <#if closedTimePeriods?has_content && closedTimePeriods?size gt 0>
    	<#assign lctp="var lctp = ['" + StringUtil.wrapString(closedTimePeriods.get(0).customTimePeriodId?if_exists) + "'"/>
		<#assign lctpValue="var lctpValue = ['" + StringUtil.wrapString(closedTimePeriods.get(0).periodName?if_exists?string) + ":" + StringUtil.wrapString(closedTimePeriods.get(0).fromDate?if_exists?string)
					+ "-" + StringUtil.wrapString(closedTimePeriods.get(0).thruDate?if_exists?string) + "'"/>
		<#if closedTimePeriods?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lctp=lctp + ",'" + StringUtil.wrapString(closedTimePeriods.get(i).customTimePeriodId?if_exists) + "'"/>
				<#assign lctpValue=lctpValue + ",'" +StringUtil.wrapString(closedTimePeriods.get(i).periodName?if_exists) + ":" + StringUtil.wrapString(closedTimePeriods.get(i).fromDate?string?if_exists)
						+ "-" + StringUtil.wrapString(closedTimePeriods.get(i).thruDate?string?if_exists) + "'"/>
			</#list>
		</#if>
		<#assign lctp=lctp + "];"/>
		<#assign lctpValue=lctpValue + "];"/>
    <#else>
    	<#assign lctp="var lctp = [];"/>
    	<#assign lctpValue="var lctpValue = [];"/>
    </#if>
	${lctp}
	${lctpValue}
	var dataCtp = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["customTimePeriodId"] = lctpValue[i];
        row["periodName"] = lctp[i];
        dataCtp[i] = row;
    };
    var parentPeriodRenderer = function (row, column, value) {
        if (value.indexOf('#') != -1) {
            value = value.substring(0, value.indexOf('#'));
        }
        var fb = false;
        for(i=0;i<lotp.length;i++){
        	if(lotp[i]===value){
        		fb=true;
        		return "<span>" + lotpValue[i] + "</span>";
        	}
        };
        for(i=0;i<lctp.length;i++){
        	if(lotp[i]===value){
        		fb=true;
        		return "<span>" + lctpValue[i] + "</span>";
        	}
        };
        return "<span>" + value + "</span>";
    };
    var cellsrendererIsclose= function (row, columnfield, value, defaulthtml, columnproperties) {
    	var tmpData = $('#jqxgrid').jqxGrid('getrowdata', row);
    	if(tmpData.isClosed=='N'){
    		var tmpId = 'tmpIc' + tmpData.customTimePeriodId;
    		var html = '<input type="button" onclick="changeState('+row+')" style="opacity: 0.99; position: absolute; top: 0%; left: 0%; padding: 0px; margin-top: 2px; margin-left: 2px; width: 96px; height: 21px;" value="${StringUtil.wrapString(uiLabelMap.commonClose)}" hidefocus="true" id="' + tmpId + '" role="button" class="jqx-rc-all jqx-rc-all-base jqx-button jqx-button-base jqx-widget jqx-widget-base jqx-fill-state-pressed jqx-fill-state-pressed-base" aria-disabled="false">';
    		return html;
    	}else{
    		return "<span>" + value + "</span>";
    	}
    }
    function changeState(rowIndex){
    	var tmpData = $('#jqxgrid').jqxGrid('getrowdata', rowIndex);
      	var data = 'columnList0' + '=' + 'customTimePeriodId'; 
		data = data + '&' + 'columnValues0' + '=' +  tmpData.customTimePeriodId;
		data += "&rl=1";
      	$.ajax({
            type: "POST",                        
            url: 'jqxGeneralServicer?&jqaction=U&sname=closeFinancialTimePeriod',
            data: data,
            success: function(odata, status, xhr) {
                // update command is executed.
                if(odata.responseMessage == "error"){
                	$('#jqxNotification').jqxNotification({ template: 'info'});
                	$('#jqxNotification').text(odata.results);
                	$('#jqxNotification').jqxNotification('open');
                }else{
                	$('#jqxgrid').jqxGrid('updatebounddata');
                	$('#container').empty();
                	$('#jqxNotification').jqxNotification({ template: 'info'});
                	$('#jqxNotification').text("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
                	$('#jqxNotification').jqxNotification('open');
                }
            },
            error: function(arg1) {
            	alert(arg1);
            }
        });  
    }
</script>

	<#assign dataField="[{ name: 'customTimePeriodId', type: 'string' },
						 { name: 'parentPeriodId', type: 'string' },
						 { name: 'periodTypeId', type: 'string' },
						 { name: 'periodNum', type: 'number' },
						 { name: 'fromDate', type: 'date'},
						 { name: 'thruDate', type: 'date'},
						 { name: 'periodName', type: 'string' },
						 { name: 'isClosed', type: 'string' }]
						"/>
<#assign columnlist="{ text: '${uiLabelMap.CustomTimePeriodId}', datafield: 'customTimePeriodId', width: 150},
					 { text: '${uiLabelMap.accParentPeriodId}', datafield: 'parentPeriodId', width: 150, cellsrenderer:parentPeriodRenderer},
					 { text: '${uiLabelMap.accPeriodTypeId}', width:150, datafield: 'periodTypeId', columntype: 'dropdownlist', filtertype: 'checkedlist', 
							cellsrenderer: function (row, column, value) {
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	        						for(i = 0 ; i < dataPT.length; i++){
	        							if(data.periodTypeId == dataPT[i].periodTypeId){
	        								return '<span title=' + value +'>' + dataPT[i].description + '</span>';
		        							}
		        						}
		        						
		        						return '<span title=' + value +'>' + value + '</span>';
		    						},
		    					createfilterwidget: function (column, columnElement, widget) {
					   				var filterBoxAdapter2 = new $.jqx.dataAdapter(dataPT,
					                {
					                    autoBind: true
					                });
					                var empty = {periodTypeId: '', description: 'Empty'};
					   				var uniqueRecords2 = filterBoxAdapter2.records;
					   				uniqueRecords2.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
					   				uniqueRecords2.splice(1, 0, empty);
					   				widget.jqxDropDownList({ source: uniqueRecords2, displayMember: 'periodTypeId', valueMember : 'periodTypeId', renderer: function (index, label, value) 
									{
										for(i=0;i < uniqueRecords2.length; i++){
											if(uniqueRecords2[i].roleTypeId == value){
												return uniqueRecords2[i].description;
											}
										}
									    return value;
									}});
					   			}},	    
                     { text: '${uiLabelMap.accPeriodNumber}', datafield: 'periodNum', width: 150 },
                     { text: '${uiLabelMap.accStartDate}', datafield: 'fromDate', filtertype: 'range', width: 150, cellsformat: 'dd/MM/yyyy'},
                     { text: '${uiLabelMap.accEndDate}', datafield: 'thruDate', filtertype: 'range',cellsformat: 'dd/MM/yyyy',  width: 150 },
                     { text: '${uiLabelMap.accPeriodName}', datafield: 'periodName'}                     
					 "/>
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListOpenTimePeriod" dataField=dataField columnlist=columnlist
		 addrow="true" updateUrl="jqxGeneralServicer?jqaction=U&sname=updateCustomTimePeriod" addType="popup" id="jqxgrid" filtersimplemode="true" showtoolbar="true"
		 createUrl="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&jqaction=C&sname=createCustomTimePeriod"
		 addColumns="periodName;periodNum(java.lang.Long);parentPeriodId;isClosed;periodTypeId;fromDate(java.sql.Date);thruDate(java.sql.Date);organizationPartyId[${parameters.organizationPartyId}]" clearfilteringbutton="true"
		 alternativeAddPopup="alterpopupWindow"
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=closeFinancialTimePeriod&jqaction=D"  
		 deleteColumn="customTimePeriodId" 	mouseRightMenu="true" contextMenuId="contextMenu" customTitleProperties="${uiLabelMap.AccountingOpenTimePeriods}"  
		 />

<div id='contextMenu' style="display:none;">
<ul>
    <li><i class="icon-ok open-sans"></i>${StringUtil.wrapString(uiLabelMap.DARefresh)}</li>
    <li><i class="icon-trash open-sans"></i>${StringUtil.wrapString(uiLabelMap.accIsClosed)}</li>
</ul>
</div>
<script type="text/javascript">
$.jqx.theme = 'olbius';  
theme = $.jqx.theme;
$("#contextMenu").jqxMenu({ width: 200, autoOpenPopup: false, mode: 'popup', theme: theme});
$("#contextMenu").on('itemclick', function (event) {
	var args = event.args;
    var rowindex = $("#jqxgrid").jqxGrid('getselectedrowindex');
    
    var tmpKey = $.trim($(args).text());
    if (tmpKey == "${StringUtil.wrapString(uiLabelMap.DARefresh)}") 
    {
    	$("#jqxgrid").jqxGrid('updatebounddata');
    } 
    else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.accIsClosed)}") 
    {		
    	var tmpData = $('#jqxgrid').jqxGrid('getrowdata', rowindex);
      	var data = 'columnList0' + '=' + 'customTimePeriodId'; 
		data = data + '&' + 'columnValues0' + '=' +  tmpData.customTimePeriodId;
		data += "&rl=1";
      	$.ajax({
            type: "POST",                        
            url: 'jqxGeneralServicer?&jqaction=U&sname=closeFinancialTimePeriod',
            data: data,
            success: function(odata, status, xhr) 
            {
                // update command is executed.
                if(odata.responseMessage == "error")
                {
                	$('#jqxNotification').jqxNotification({ template: 'info'});
                	$('#jqxNotification').text(odata.results);
                	$('#jqxNotification').jqxNotification('open');
                }
                else
                {
                	$('#jqxgrid').jqxGrid('updatebounddata');
                	$('#jqxGridClosed').jqxGrid('updatebounddata');
                	
                	$('#container').empty();
                	$('#jqxNotification').jqxNotification({ template: 'info'});
                	$('#jqxNotification').text("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
                	$('#jqxNotification').jqxNotification('open');
                }
            },
            error: function(arg1) 
            {
            	alert(arg1);
            }
        });      	    	
    } 
    
});
</script>

<div id="alterpopupWindow" style="display:none;">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accParentPeriodId}:</td>
	 			<td align="left"><div id="parentPeriodId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accPeriodTypeId}:</td>
	 			<td align="left"><div id="periodTypeId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accPeriodNumber}:</td>
	 			<td align="left"><div id="periodNum"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accPeriodName}:</td>
	 			<td align="left"><input id="periodName"/></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accStartDate}:</td>
	 			<td align="left"><div id="fromDate"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accEndDate}:</td>
	 			<td align="left"><div id="thruDate"></div></td>
    	 	</tr>
    	 	
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div>
<script type="text/javascript">
	var icData = new Array();
	var row = {};
	
	
	var row = {};
	
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	var sourceIc =
    {
        localdata: icData,
        datatype: "array"
    };
    var dataAdapterIc = new $.jqx.dataAdapter(sourceIc);
    var sourcePPI =
    {
        localdata: dataOtp,
        datatype: "array"
    };
    var dataAdapterPPI = new $.jqx.dataAdapter(sourcePPI);
    var sourcePT =
    {
        localdata: dataPT,
        datatype: "array"
    };  
    
    $('#periodTypeId').jqxDropDownList({ selectedIndex: 0,  source: dataPT, displayMember: "description", valueMember: "periodTypeId"});
    $('#parentPeriodId').jqxDropDownList({ selectedIndex: 0,  source: dataAdapterPPI, displayMember: "periodName", valueMember: "customTimePeriodId"});
	$("#fromDate").jqxDateTimeInput({width: '200px', height: '25px'});
	$("#thruDate").jqxDateTimeInput({width: '200px', height: '25px'});
	$("#periodName").jqxInput({width: '195px'});
	
	$("#periodNum").jqxNumberInput({ width: '200', height: '25px', inputMode: 'simple', spinButtons: true });
    
	$("#alterpopupWindow").jqxWindow({
        width: 580, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });

    $("#alterCancel").jqxButton();
    $("#alterSave").jqxButton();

    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
    	var row;
        row = { 
        		fromDate:$('#fromDate').jqxDateTimeInput('getDate'),
        		isClosed:"N",
        		parentPeriodId:$('#parentPeriodId').val(),
        		periodName:$('#periodName').val(),
        		periodNum:$('#periodNum').val(),
        		periodTypeId:$('#periodTypeId').val(),
        		thruDate: $('#thruDate').jqxDateTimeInput('getDate'),            
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
        // select the first row and clear the selection.
        $("#jqxgrid").jqxGrid('clearSelection');                        
        $("#jqxgrid").jqxGrid('selectRow', 0);  
        $("#alterpopupWindow").jqxWindow('close');
       
        
    });   
</script>
