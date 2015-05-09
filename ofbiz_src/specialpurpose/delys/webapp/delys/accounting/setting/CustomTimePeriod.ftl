<script type="text/javascript" language="Javascript">

	<#assign periodTypeList = delegator.findList("PeriodType",  Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("groupPeriodTypeId", Static["org.ofbiz.entity.condition.EntityOperator"].EQUALS , "FISCAL_ACCOUNT"), null, null, null, false) />
	var dataPT = new Array();
	<#list periodTypeList as periodType>
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
    
    <#assign partiesList = delegator.findList("PartyAcctgPreference",  null, null, null, null, false) />  
	
	<#assign illength = partiesList.size()/>
	${illength} 
	<#assign partyIn = "" />
	<#if partiesList?has_content && partiesList?size gt 0>
		<#if partiesList?size gt 1>
			<#list 0..(illength - 2) as ii>					
					<#assign partyIn =partyIn + "\"" + StringUtil.wrapString(partiesList.get(ii).partyId?if_exists)  + "\"," />				
			</#list>
			<#assign partyIn =partyIn + "\"" + StringUtil.wrapString(partiesList.get(illength - 1).partyId?if_exists) + "\"" />
		<#else>	
			<#assign partyIn = "\"" + StringUtil.wrapString(partiesList.get(0).partyId?if_exists) + "\"" />
		</#if>
    <#else>
		<#assign partyIn=""/>	
	</#if>			
	${partyIn}	
		
	<#assign Parties = delegator.findList("PartyNameView", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("partyId", Static["org.ofbiz.entity.condition.EntityOperator"].IN , ["company"]), null, null, null, false) />
	var partyData =  new Array();
	<#list Parties as item>
		var row = {};
		<#assign firstName = StringUtil.wrapString(item.firstName?if_exists)>
		<#assign middleName = StringUtil.wrapString(item.middleName?if_exists)>
		<#assign lastName = StringUtil.wrapString(item.lastName?if_exists)>
		<#assign groupName = StringUtil.wrapString(item.groupName?if_exists)>

		row['partyId'] = '${item.partyId?if_exists}';
		row['firstName'] = "${firstName}";
		row['middleName'] = "${middleName}";
		row['lastName'] = "${lastName}";
		row['groupName'] = "${groupName}";
		partyData[${item_index}] = row;
	</#list>
	
</script>

<div id="jqxwindoworganizationPartyId" style="display:none;">
<div>${uiLabelMap.SelectPartyIdFrom}</div>
<div style="overflow: hidden;">
	<table id="OrganizationPartyId">
		<tr>
			<td>
				<input type="hidden" id="jqxwindoworganizationPartyIdkey" value=""/>
				<input type="hidden" id="jqxwindoworganizationPartyIdvalue" value=""/>
				<div id="jqxgridorganizationPartyId"></div>
			</td>
		</tr>
	    <tr>
	        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave3" value="${uiLabelMap.CommonSave}" /><input id="alterCancel3" type="button" value="${uiLabelMap.CommonCancel}" /></td>
	    </tr>
	</table>
</div>
</div>
<@jqGridMinimumLib/>
<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;  
	$("#jqxwindoworganizationPartyId").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel3"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });	
	$('#jqxwindoworganizationPartyId').on('open', function (event) {
		var offset = $("#jqxgrid").offset();
			$("#jqxwindoworganizationPartyId").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	
	$("#alterSave3").jqxButton({theme: theme});
	$("#alterCancel3").jqxButton({theme: theme});	
	
	$("#alterSave3").click(function () {
		var tIndex = $('#jqxgridorganizationPartyId').jqxGrid('selectedrowindex');
		var data = $('#jqxgridorganizationPartyId').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindoworganizationPartyIdkey').val()).val(data.partyId);
		$("#jqxwindoworganizationPartyId").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindoworganizationPartyIdkey').val()).trigger(e);
	});
	// FromParty
	var sourceP =
	{
	    datafields:
	    [
	        { name: 'partyId', type: 'string' },
	        { name: 'partyTypeId', type: 'string' },
	        { name: 'firstName', type: 'string' },
	        { name: 'lastName', type: 'string' },
	        { name: 'groupName', type: 'string' }
	    ],
	    cache: false,
	    root: 'results',
	    datatype: "json",
	    updaterow: function (rowid, rowdata) {
	        // synchronize with the server - send update command   
	    },
	    beforeprocessing: function (data) {
	        sourceP.totalrecords = data.TotalRows;
	    },
	    filter: function () {
	        // update the grid and send a request to the server.
	        $("#jqxgridorganizationPartyId").jqxGrid('updatebounddata');
	    },
	    pager: function (pagenum, pagesize, oldpagenum) {
	        // callback called when a page or page size is changed.
	    },
	    sort: function () {
	        $("#jqxgridorganizationPartyId").jqxGrid('updatebounddata');
	    },
	    sortcolumn: 'partyId',
		sortdirection: 'asc',
	    type: 'POST',
	    data: {
	        noConditionFind: 'Y',
	        conditionsFind: 'N',
	    },
	    pagesize:5,
	    contentType: 'application/x-www-form-urlencoded',
	    url: 'jqxGeneralServicer?sname=JQGetListPartiesAcctgPreference',
	};
	var dataAdapterP = new $.jqx.dataAdapter(sourceP,
	{
		autoBind: true,
		formatData: function (data) {
			if (data.filterscount) {
	            var filterListFields = "";
	            for (var i = 0; i < data.filterscount; i++) {
	                var filterValue = data["filtervalue" + i];
	                var filterCondition = data["filtercondition" + i];
	                var filterDataField = data["filterdatafield" + i];
	                var filterOperator = data["filteroperator" + i];
	                filterListFields += "|OLBIUS|" + filterDataField;
	                filterListFields += "|SUIBLO|" + filterValue;
	                filterListFields += "|SUIBLO|" + filterCondition;
	                filterListFields += "|SUIBLO|" + filterOperator;
	            }
	            data.filterListFields = filterListFields;
	        }
	        return data;
	    },
	    loadError: function (xhr, status, error) {
	        alert(error);
	    },
	    downloadComplete: function (data, status, xhr) {
	            if (!sourceP.totalRecords) {
	                sourceP.totalRecords = parseInt(data['odata.count']);
	            }
	    }
	});
	$('#jqxgridorganizationPartyId').jqxGrid(
	{
	    width:800,
	    source: dataAdapterP,
	    filterable: true,
	    virtualmode: true, 
	    sortable:true,
	    theme: theme, 
		showfilterrow: true,
	    editable: false,
	    autoheight:true,
	    pageable: true,
	    pagesizeoptions: ['5', '10', '15'],
	    ready:function(){
	    },
	    rendergridrows: function(obj)
		{
			return obj.data;
		},
	     columns: [
			  { text: '${uiLabelMap.DAFormFieldTitle_organizationPartyId}', datafield: 'partyId', width:150},
	          { text: '${uiLabelMap.accPeriodPartyTypeId}', datafield: 'partyTypeId', width:200},
	          { text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'firstName', width:150},
	          { text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName', width:150},
	          { text: '${uiLabelMap.organizationName}', datafield: 'groupName'}
			]
	});
	
	$(document).keydown(function(event){
	    if(event.ctrlKey)
	        cntrlIsPressed = true;
	});
	
	$(document).keyup(function(event){
		if(event.which=='17')
	    	cntrlIsPressed = false;
	});
	var cntrlIsPressed = false;
	
	var cellclass = function (row, columnfield, value) {
		var now = new Date();
		now.setHours(0,0,0,0);
		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		if (data.thruDate != undefined && data.thruDate != null && Date.parseExact(data.thruDate,"dd/MM/yyyy HH:mm:ss") <= now) {
		    return 'background-red';
		}
	}
</script>

<#assign dataField="[{ name: 'customTimePeriodId', type: 'string' },
					 { name: 'parentPeriodId', type: 'string' },
					 { name: 'periodTypeId', type: 'string' },
					 { name: 'organizationPartyId', type: 'string' },					 
					 { name: 'periodNum', type: 'number' },
					 { name: 'fromDate', type: 'date'},
					 { name: 'thruDate', type: 'date'},
					 { name: 'periodName', type: 'string' }]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.CustomTimePeriodId}', datafield: 'customTimePeriodId', width: 100,  editable:false },
					 { text: '${uiLabelMap.accParentPeriodId}', datafield: 'parentPeriodId', width: 190, cellsrenderer:parentPeriodRenderer},
				 	 { text: '${uiLabelMap.OrganizationParty}', width:150, datafield: 'organizationPartyId', filtertype: 'olbiusdropgrid', cellclassname: cellclass,
					 	cellsrenderer: function (row, column, value) {
							for(i = 0; i < partyData.length; i++){
								if(partyData[i].partyId == value){
									var result = '<a title=\"' + value + '\"' + ' style = \"margin-left: 10px\" ' +  ' href=\"' + '/partymgr/control/viewprofile?partyId=' + value + '\">' + partyData[i].firstName + '&nbsp' + partyData[i].middleName + '&nbsp' + partyData[i].lastName + '&nbsp' + partyData[i].groupName + '&nbsp' + '</a>';
									return result;
								}
							}
        					return '<a title= \"' + value  + '\"' +' style = \"margin-left: 10px\" href=' + '/partymgr/control/viewprofile?partyId=' + value + '>' + value + '</a>'
    					},
					 	createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(490);
			   			},				   			
				 	 },					 
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
				   			},
				   			createeditor: function (row, column, editor) {
	                            var sourceDPT =
					            {
					                localdata: dataPT,
					                datatype: \"array\"
					            };
					            var dataAdapterDPT = new $.jqx.dataAdapter(sourceDPT);
	                            editor.jqxDropDownList({source: dataAdapterDPT, displayMember:\"periodTypeId\", valueMember: \"periodTypeId\",
	                            renderer: function (index, label, value) {
				                    var datarecord = dataPT[index];
				                    return datarecord.description;
				                } 
	                        })},	    
					 },
                     { text: '${uiLabelMap.accPeriodNumber}', datafield: 'periodNum', width: 150 },
                     { text: '${uiLabelMap.accStartDate}', datafield: 'fromDate', filtertype: 'range', columntype: 'template', width: 150, cellsformat: 'dd/MM/yyyy', 
                      	createeditor: function (row, column, editor) {
                     		editor.jqxDateTimeInput({ width: '150px', height: '25px',  formatString: 'dd/MM/yyyy' });
                     	}},
                     { text: '${uiLabelMap.accEndDate}', datafield: 'thruDate', filtertype: 'range', columntype: 'template',cellsformat: 'dd/MM/yyyy',  width: 150,
                      	createeditor: function (row, column, editor) {
                     		editor.jqxDateTimeInput({ width: '150px', height: '25px',  formatString: 'dd/MM/yyyy' });
                     	}},
                     { text: '${uiLabelMap.accPeriodName}', datafield: 'periodName'}
					 "/>
<@jqGrid url="jqxGeneralServicer?sname=JQListCustomTimePeriod" dataField=dataField columnlist=columnlist editmode="selectedcell"
		 addrow="true" updateUrl="jqxGeneralServicer?jqaction=U&sname=updateCustomTimePeriod"   updaterow="true"
		 addType="popup" id="jqxgrid" filtersimplemode="true" showtoolbar="true" editable="true"
		 editColumns="isClosed" createUrl="jqxGeneralServicer?jqaction=C&sname=createCustomTimePeriod"
	     deleterow="true" removeUrl="jqxGeneralServicer?jqaction=D&sname=deleteCustomTimePeriod" deleteColumn="customTimePeriodId"
		 addColumns="periodName;periodNum(java.lang.Long);parentPeriodId;isClosed;periodTypeId;fromDate(java.sql.Date);thruDate(java.sql.Date);organizationPartyId" clearfilteringbutton="true"
		 alternativeAddPopup="alterpopupWindow"
		 />

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>


<div id="alterpopupWindow" style="display:none;">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accParentPeriodId}:</td>
	 			<td align="left"><div id="parentPeriodId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.DAFormFieldTitle_organizationPartyId}:</td>
	 			<td align="left">
	 				<div id="orgPartyId">
	 					<div id="jqxOrgPartyIdGridId" />
	 				</div>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accPeriodTypeId}:</tpd>
	 			<td align="left"><div id="periodTypeId"/></td>
    	 	</tr>    	 	
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accPeriodNumber}:</td>
	 			<td align="left"><input id="periodNum"/></td>
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
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
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
    var dataAdapterPT = new $.jqx.dataAdapter(sourcePT);
    
    var sourceParty = {
			datafields:[{name: 'partyId', type: 'string'},
				   		{name: 'firstName', type: 'string'},
				      	{name: 'lastName', type: 'string'},
				      	{name: 'middleName', type: 'string'},
				      	{name: 'groupName', type: 'string'},
		    ],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
			    sourceParty.totalrecords = data.TotalRows;
			},
			filter: function () {
			   	// update the grid and send a request to the server.
			   	$("#jqxOrgPartyIdGridId").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
			  	// callback called when a page or page size is changed.
			},
			sort: function () {
			  	$("#jqxOrgPartyIdGridId").jqxGrid('updatebounddata');
			},
			sortcolumn: 'partyId',
           	sortdirection: 'asc',
			type: 'POST',
			data: {
				noConditionFind: 'Y',
				conditionsFind: 'N',
			},
			pagesize:5,
			contentType: 'application/x-www-form-urlencoded',
			url: 'jqxGeneralServicer?sname=JQGetListPartiesAcctgPreference',
    };

	var dataAdapterParty = new $.jqx.dataAdapter(sourceParty,
	{
		autoBind: true,
		formatData: function (data) {
			if (data.filterscount) {
	            var filterListFields = "";
	            for (var i = 0; i < data.filterscount; i++) {
	                var filterValue = data["filtervalue" + i];
	                var filterCondition = data["filtercondition" + i];
	                var filterDataField = data["filterdatafield" + i];
	                var filterOperator = data["filteroperator" + i];
	                filterListFields += "|OLBIUS|" + filterDataField;
	                filterListFields += "|SUIBLO|" + filterValue;
	                filterListFields += "|SUIBLO|" + filterCondition;
	                filterListFields += "|SUIBLO|" + filterOperator;
	            }
	            data.filterListFields = filterListFields;
	        }
	        return data;
	    },
	    loadError: function (xhr, status, error) {
	        alert(error);
	    },
	    downloadComplete: function (data, status, xhr) {
	            if (!sourceParty.totalRecords) {
	                sourceParty.totalRecords = parseInt(data['odata.count']);
	            }
	    }
	});	    
	    
	$('#orgPartyId').jqxDropDownButton({ width: 200, height: 25});
	$("#jqxOrgPartyIdGridId").jqxGrid({
		width:600,
		source: dataAdapterParty,
		filterable: true,
		virtualmode: true, 
		sortable:true,
		editable: false,
		autoheight:true,
		pageable: true,
		showfilterrow: true,
		rendergridrows: function(obj) {	
			return obj.data;
		},
		
		columns:[{text: '${uiLabelMap.DAFormFieldTitle_organizationPartyId}', datafield: 'partyId', width: '20%'},
					{text: '${uiLabelMap.accPeriodPartyTypeId}', datafield: 'firstName', width: '20%'},
					{text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'middleName', width: '20%'},
					{text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName', width: '20%'},
					{text: '${uiLabelMap.organizationName}', datafield: 'groupName'},
				]
	});
	$("#jqxOrgPartyIdGridId").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxOrgPartyIdGridId").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['partyId'] + '</div>';
        $("#orgPartyId").jqxDropDownButton('setContent', dropDownContent);
    });    
    
    $('#periodTypeId').jqxDropDownList({ selectedIndex: 0,  source: dataPT, displayMember: "description", valueMember: "periodTypeId"});
    $('#parentPeriodId').jqxDropDownList({ selectedIndex: 0,  source: dataAdapterPPI, displayMember: "periodName", valueMember: "customTimePeriodId"});
	$("#fromDate").jqxDateTimeInput({width: '200px', height: '25px'});
	$("#thruDate").jqxDateTimeInput({width: '200px', height: '25px'});
	$("#periodName").jqxInput({width: '195px'});
	$("#periodNum").jqxInput({width: '195px'});
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
        		parentPeriodId:$('#parentPeriodId').val(),
        		organizationPartyId:$('#orgPartyId').val(),
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
