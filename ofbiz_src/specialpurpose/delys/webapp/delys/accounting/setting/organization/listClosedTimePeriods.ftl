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
						 { name: 'periodName', type: 'string' }
						 ]
						"/>
<#assign columnlist="{ text: '${uiLabelMap.CustomTimePeriodId}', datafield: 'customTimePeriodId', width: 150},
					 { text: '${uiLabelMap.accParentPeriodId}', datafield: 'parentPeriodId', width: 150, cellsrenderer:parentPeriodRenderer},
					 { text: '${uiLabelMap.accPeriodTypeId}', width:150, datafield: 'periodTypeId', columntype: 'dropdownlist', filtertype: 'checkedlist', 
							cellsrenderer: function (row, column, value) {
								var data = $('#jqxGridClosed').jqxGrid('getrowdata', row);
	        						for(i = 0 ; i < dataPT.length; i++)
	        						{
	        							if(data.periodTypeId == dataPT[i].periodTypeId)
	        							{	
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
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListClosedTimePeriod" dataField=dataField columnlist=columnlist
		 addrow="false"  addType="popup" filtersimplemode="true" showtoolbar="true"
		 createUrl="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&jqaction=C&sname=createCustomTimePeriod" customTitleProperties="${uiLabelMap.AccountingClosedTimePeriods}"
		 addColumns="periodName;periodNum(java.lang.Long);parentPeriodId;isClosed;periodTypeId;fromDate(java.sql.Date);thruDate(java.sql.Date);organizationPartyId[${parameters.organizationPartyId}]" clearfilteringbutton="true"		 
		 id="jqxGridClosed"
		 />
<script type="text/javascript">
var row = {};

$.jqx.theme = 'olbius';  
theme = $.jqx.theme;

$('#periodTypeId').jqxDropDownList({ selectedIndex: 0,  source: dataPT, displayMember: "description", valueMember: "periodTypeId"});
</script>
