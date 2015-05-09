<#assign dataField="[{ name: 'rateDescription', type: 'string' },
						 { name: 'periodDescription', type: 'string' },
						 { name: 'firstName', type: 'string' },
						 { name: 'middleName', type: 'string' },
						 { name: 'lastName', type: 'string'},
						 { name: 'groupName', type: 'string'},
						 { name: 'employeePositionDescription', type: 'string'},
						 { name: 'workEffortName', type: 'string'},
						 { name: 'emplPositionTypeId', type: 'string'},
						 { name: 'rateAmount', type: 'number'},
						 { name: 'periodTypeId', type: 'string'},
						 { name: 'workEffortId', type: 'string'},
						 { name: 'rateTypeId', type: 'string'},		
						 { name: 'fromDate', type: 'date', other: 'Timestamp'},
						 { name: 'rateCurrencyUomId', type: 'string' },
						 { name: 'partyId', type: 'string' },
						 { name: 'rateTypeId', type: 'string' },
						 { name: 'partyNameResult', type: 'string'},
						 ]
						 "/>
<#assign columnlist="{ text: '${uiLabelMap.RateDescription}', datafield: 'rateDescription', width: 100},
					 { text: '${uiLabelMap.PeriodTypeId}', datafield: 'periodDescription', width: 190},
					 { text: '${uiLabelMap.PartyId}',filtertype: 'olbiusdropgrid', width:300, datafield: 'partyId', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + data.partyNameResult + '[' + data.partyId + ']' + \"</span>\";
					 	},
			   			createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(490);
			   			}},
                     {text : 'rateCurrencyUomId', datafield: 'rateCurrencyUomId' , hidden: true},

                     {text : 'periodTypeId', datafield: 'periodTypeId' , hidden: true},
                     {text : 'workEffortId', datafield: 'workEffortId' , hidden: true},
                     {text : 'fromDate', datafield: 'fromDate' , hidden: true},
                    
                     {text : 'rateTypeId', datafield: 'rateTypeId' , hidden: true},
                     
                     { text: '${uiLabelMap.WorkEffortId}', datafield: 'workEffortName', width: 150},
                     { text: '${uiLabelMap.EmplPositionTypeId}', datafield: 'emplPositionTypeId', width: 150 },
                     { text: '${uiLabelMap.RateAmount}', datafield: 'rateAmount',cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + formatcurrency(data.rateAmount,data.rateCurrencyUomId) + \"</span>\";
					 	}}
				
					 "/>
<@jqGrid url="jqxGeneralServicer?sname=JQListRates" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true" addrefresh="true"
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow" createUrl="jqxGeneralServicer?jqaction=C&sname=updateRateAmount"
		 addColumns="rateAmount(java.math.BigDecimal);rateDescription;partyId;emplPositionTypeId;workEffortId;rateCurrencyUomId;rateTypeId"
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=deleteRateAmount&jqaction=D" 
		 deleteColumn="emplPositionTypeId;periodTypeId;workEffortId;fromDate(java.sql.Timestamp);rateCurrencyUomId;partyId;rateTypeId" 
		 otherParams="partyNameResult:S-getPartyNameForDate(partyId)<fullName>;"
		 
 />
 
<div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.RateType}:</td>
	 			<td align="left"><div id="rateTypeId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.RateAmount}:</td>
	 			<td align="left"><div id="rateAmount"> </div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.PartyId}:</td>
	 			<td align="left">
	 				<div id="partyFilterIdFrom">
			            <div style="border-color: transparent;" id="jqxPartyFromFilterGrid">
			            </div>
		        	</div>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.WorkEffortId}:</td>
	 			<td align="left">
	 				<div id="WorkIdEffort">
			            <div style="border-color: transparent;" id="jqxWorkEffortFilterGrid">
			            </div>
		        	</div>
	 				
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.PeriodTypeId}:</td>
	 			<td align="left"><div  id='periodTypeId'></div><td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.currencyUomId}:</td>
	 			<td align="left"><div id='currencyUomId'></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.EmplPositionTypeId}:</td>
	 			<td align="left"><div id="emplPositionTypeId"></div></td>
    	 	</tr>
    	 
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div> 
<div id="jqxwindowpartyId">
	<div>${uiLabelMap.SelectPartyIdFrom}</div>
	<div style="overflow: hidden;">
		<table id="PartyIdFrom">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdkey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdvalue" value=""/>
					<div id="jqxgridpartyid"></div>
				</td>
			</tr>
		    <tr>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave3" value="${uiLabelMap.CommonSave}" /><input id="alterCancel3" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	<#assign itlength = listRateType.size()/>
	<#if listRateType?size gt 0>
	    <#assign lrt="var lrt = ['" + StringUtil.wrapString(listRateType.get(0).rateTypeId?if_exists) + "'"/>
		<#assign lrtValue="var lrtValue = [\"" + StringUtil.wrapString(listRateType.get(0).rateTypeId?if_exists) + ":" + StringUtil.wrapString(listRateType.get(0).description?if_exists) +"\""/>
		<#if listRateType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lrt=lrt + ",'" + StringUtil.wrapString(listRateType.get(i).rateTypeId?if_exists) + "'"/>
				<#assign lrtValue=lrtValue + ",\"" + StringUtil.wrapString(listRateType.get(i).rateTypeId?if_exists) + ":" + StringUtil.wrapString(listRateType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lrt=lrt + "];"/>
		<#assign lrtValue=lrtValue + "];"/>
	<#else>
		<#assign lrt="var lrt = [];"/>
		<#assign lrtValue="var lrtValue = [];"/>
	</#if>
	${lrt}
	${lrtValue}	
	
	var dataLRT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
	    var row = {};
	    row["rateTypeId"] = lrt[i];
	    row["description"] = lrtValue[i];
	    dataLRT[i] = row;
	}
	
	<#assign itlength = listPeriodType.size()/>
	<#if listPeriodType?size gt 0>
	    <#assign lpt="var lpt = ['" + StringUtil.wrapString(listPeriodType.get(0).periodTypeId?if_exists) + "'"/>
		<#assign lptValue="var lptValue = [\"" + StringUtil.wrapString(listPeriodType.get(0).periodTypeId?if_exists) + ":" + StringUtil.wrapString(listPeriodType.get(0).description?if_exists) +"\""/>
		<#if listRateType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lpt=lpt + ",'" + StringUtil.wrapString(listRateType.get(i).periodTypeId?if_exists) + "'"/>
				<#assign lptValue=lptValue + ",\"" + StringUtil.wrapString(listPeriodType.get(i).periodTypeId?if_exists) + ":" + StringUtil.wrapString(listPeriodType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lpt=lpt + "];"/>
		<#assign lptValue=lptValue + "];"/>
	<#else>
		<#assign lpt="var lpt = [];"/>
		<#assign lptValue="var lptValue = [];"/>
	</#if>
	${lpt}
	${lptValue}	
	
	var dataLPT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
	    var row = {};
	    row["periodTypeId"] = lpt[i];
	    row["description"] = lptValue[i];
	    dataLPT[i] = row;
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
	
	
	<#assign itlength = listEmplPositionType.size()/>
	<#if listEmplPositionType?size gt 0>
	    <#assign lept="var lept = ['" + StringUtil.wrapString(listEmplPositionType.get(0).emplPositionTypeId?if_exists) + "'"/>
		<#assign leptValue="var leptValue = [\"" + StringUtil.wrapString(listEmplPositionType.get(0).emplPositionTypeId?if_exists) + ":" + StringUtil.wrapString(listEmplPositionType.get(0).description?if_exists) +"\""/>
		<#if listEmplPositionType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lept=lept + ",'" + StringUtil.wrapString(listEmplPositionType.get(i).emplPositionTypeId?if_exists) + "'"/>
				<#assign leptValue=leptValue + ",\"" + StringUtil.wrapString(listEmplPositionType.get(i).emplPositionTypeId?if_exists) + ":" + StringUtil.wrapString(listEmplPositionType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lept=lept + "];"/>
		<#assign leptValue=leptValue + "];"/>
	<#else>
		<#assign lept="var lept = [];"/>
		<#assign leptValue="var leptValue = [];"/>
	</#if>
	${lept}
	${leptValue}	
	
	var dataLEPT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
	    var row = {};
	    row["emplPositionTypeId"] = lept[i];
	    row["description"] = leptValue[i];
	    dataLEPT[i] = row;
	}
	

</script> 

<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	var sourceLRT =
	{
	    localdata: dataLRT,
	    datatype: "array"
	};
	var dataAdapterLGT = new $.jqx.dataAdapter(sourceLRT);
	var sourceLPT =
	{
	    localdata: dataLPT,
	    datatype: "array"
	};
	var dataAdapterLPT = new $.jqx.dataAdapter(sourceLPT);
	
	
	var sourceLC =
	{
	    localdata: dataLC,
	    datatype: "array"
	};
	var dataAdapterLC = new $.jqx.dataAdapter(sourceLC);
	
	var sourceLEPT =
	{
	    localdata: dataLEPT,
	    datatype: "array"
	};
	var dataAdapterLEPT = new $.jqx.dataAdapter(sourceLEPT);
	
	$('#rateTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLGT, displayMember: "description", valueMember: "rateTypeId"});
	$('#periodTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLPT, displayMember: "description", valueMember: "periodTypeId"});
	$('#currencyUomId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLC, displayMember: "description", valueMember: "uomId"});
	$('#emplPositionTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLEPT, displayMember: "description", valueMember: "emplPositionTypeId"});
	$('#partyFilterIdFrom').jqxDropDownButton({ width: 200, height: 25});
	$('#WorkIdEffort').jqxDropDownButton({ width: 200, height: 25});
	
	$('#rateAmount').jqxNumberInput({ width: '200px', inputMode: 'simple', spinButtons: true });
	$("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
    
	$("#alterSave").click(function () {
		var row;
		
        row = {
        		rateTypeId: $('#rateTypeId').val(),
        		rateCurrencyUomId: $('#currencyUomId').val(),
        		rateAmount: $('#rateAmount').val(),
        		periodTypeId: $('#periodTypeId').val(),
        		emplPositionTypeId: $('#emplPositionTypeId').val(),
        		workEffortId : $('#WorkIdEffort').val(),
        		partyId:$('#partyFilterIdFrom').val()        
        	  };
        
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
       $("#alterpopupWindow").jqxWindow('close');
		
	});

</script>

 <script type="text/javascript">
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
		    return(formatted + ((parts) ? decimalseparator + parts[1].substr(0, 2) : "") + "&nbsp;" + currencysymbol);
		};
 </script>
 
 <script>
 	var sourceWorkEffort = { datafields: [
						      { name: 'workEffortId', type: 'string' },
						      { name: 'workEffortName', type: 'string' },
						      { name: 'workEffortTypeId', type: 'string'},
						      { name: 'description', type: 'string'}
						      
						    ],
				cache: false,
				root: 'results',
				datatype: "json",
				updaterow: function (rowid, rowdata) {
					// synchronize with the server - send update command   
				},
				beforeprocessing: function (data) {
					sourceWorkEffort.totalrecords = data.TotalRows;
				},
				filter: function () {
				   // update the grid and send a request to the server.
				   $("#jqxWorkEffortGrid").jqxGrid('updatebounddata');
				},
				pager: function (pagenum, pagesize, oldpagenum) {
				  // callback called when a page or page size is changed.
				},
				sort: function () {
				  $("#jqxWorkEffortGrid").jqxGrid('updatebounddata');
				},
				sortcolumn: 'workEffortId',
               	sortdirection: 'asc',
				type: 'POST',
				data: {
					noConditionFind: 'Y',
					conditionsFind: 'N',
				},
				pagesize:5,
				contentType: 'application/x-www-form-urlencoded',
				url: 'jqxGeneralServicer?sname=JQListWorkEffort',
			};
	
	var sourceParty = { datafields: [
						      { name: 'partyId', type: 'string' },
						      { name: 'firstName', type: 'string' },
						      { name: 'lastName', type: 'string' },
						      { name: 'middleName', type: 'string' },
						      { name: 'groupName', type: 'string' },
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
				   $("#jqxPartyGrid").jqxGrid('updatebounddata');
				},
				pager: function (pagenum, pagesize, oldpagenum) {
				  // callback called when a page or page size is changed.
				},
				sort: function () {
				  $("#jqxPartyGrid").jqxGrid('updatebounddata');
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
				url: 'jqxGeneralServicer?sname=JQGetListParties',
			};
	
	<@renderFilterType arrayName="dataStringFilterType"/>
	
	<@renderDateTimeFilterType arrayName="dataDatetimeFilterType"/>
	$("#jqxPartyFromFilterGrid").jqxGrid({
		width:400,
		source: sourceParty,
		filterable: true,
		virtualmode: true, 
		sortable:true,
		editable: false,
		autoheight:true,
		pageable: true,
		rendergridrows: function(obj)
		{	
			return obj.data;
		},
		columns: 
		[
			{ text: 'partyId', datafield: 'partyId'},
			{ text: 'firstName', datafield: 'firstName'},
			{ text: 'middleName', datafield: 'middleName'},
			{ text: 'lastName', datafield: 'lastName'},
			{ text: 'groupName', datafield: 'groupName'},
		]
	});
	
	
	$("#jqxWorkEffortFilterGrid").jqxGrid({
		width:400,
		source: sourceWorkEffort,
		filterable: true,
		virtualmode: true, 
		sortable:true,
		editable: false,
		autoheight:true,
		pageable: true,
		rendergridrows: function(obj)
		{	
			return obj.data;
		},
		columns: 
		[
			{ text: 'workEffortId', datafield: 'workEffortId'},
			{ text: 'workEffortName', datafield: 'workEffortName'},
			{ text: 'middleName', datafield: 'middleName'},
			{ text: 'workEffortTypeId', datafield: 'workEffortTypeId'},
			{ text: 'description', datafield: 'description'},
		]
	});
	
	$("#jqxPartyFromFilterGrid").on('rowselect', function (event) {
                var args = event.args;
                var row = $("#jqxPartyFromFilterGrid").jqxGrid('getrowdata', args.rowindex);
                var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['partyId'] + '</div>';
                $("#partyFilterIdFrom").jqxDropDownButton('setContent', dropDownContent);
            });    
	$("#jqxWorkEffortFilterGrid").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxWorkEffortFilterGrid").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['workEffortId'] + '</div>';
        $("#WorkIdEffort").jqxDropDownButton('setContent', dropDownContent);
    });    
	
	//search partyId
	$("#jqxwindowpartyId").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel3"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxwindowpartyId').on('open', function (event) {
    	var offset = $("#jqxgrid").offset();
   		$("#jqxwindowpartyId").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave3").jqxButton({theme: theme});
	$("#alterCancel3").jqxButton({theme: theme});
	$("#alterSave3").click(function () {
		var tIndex = $('#jqxgridpartyid').jqxGrid('selectedrowindex');
		var data = $('#jqxgridpartyid').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindowpartyIdkey').val()).val(data.partyId);
		$("#jqxwindowpartyId").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindowpartyIdkey').val()).trigger(e);
	});
	
	// FromParty
    var sourceP =
    {
        datafields:
        [
			{ name: 'partyId', type: 'string' },
			{ name: 'firstName', type: 'string' },
			{ name: 'lastName', type: 'string' },
			{ name: 'middleName', type: 'string' },
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
            $("#jqxgridpartyid").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridpartyid").jqxGrid('updatebounddata');
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
        url: 'jqxGeneralServicer?sname=JQGetListParties',
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
    $('#jqxgridpartyid').jqxGrid(
    {
        width:800,
        source: dataAdapterP,
        filterable: true,
        virtualmode: true, 
        sortable:true,
        theme: theme, 
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
					{ text: 'partyId', datafield: 'partyId', width: 150},
					{ text: 'firstName', datafield: 'firstName',  width: 150},
					{ text: 'middleName', datafield: 'middleName',  width: 150},
					{ text: 'lastName', datafield: 'lastName',  width: 150},
					{ text: 'groupName', datafield: 'groupName'},
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
</script>