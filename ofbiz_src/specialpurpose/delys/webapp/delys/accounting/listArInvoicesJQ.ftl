<script type="text/javascript">
	<#assign itlength = listInvoiceType.size()/>
    <#if listInvoiceType?size gt 0>
	    <#assign vaIT="var vaIT = ['" + StringUtil.wrapString(listInvoiceType.get(0).invoiceTypeId?if_exists) + "'"/>
		<#assign vaITValue="var vaITValue = [\"" + StringUtil.wrapString(listInvoiceType.get(0).description?if_exists) + "\""/>
		<#if listInvoiceType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign vaIT=vaIT + ",'" + StringUtil.wrapString(listInvoiceType.get(i).invoiceTypeId?if_exists) + "'"/>
				<#assign vaITValue=vaITValue + ",\"" + StringUtil.wrapString(listInvoiceType.get(i).description?if_exists) +"\""/>
			</#list>
		</#if>
		<#assign vaIT=vaIT + "];"/>
		<#assign vaITValue=vaITValue + "];"/>
	<#else>
    	<#assign vaIT="var vaIT = [];"/>
    	<#assign vaITValue="var vaITValue = [];"/>
    </#if>
	${vaIT}
	${vaITValue}
	<#assign itlength = listStatusItem.size()/>
    <#if listStatusItem?size gt 0>
	    <#assign vaSI="var vaSI = ['" + StringUtil.wrapString(listStatusItem.get(0).statusId?if_exists) + "'"/>
		<#assign vaSIValue="var vaSIValue = [\"" + StringUtil.wrapString(listStatusItem.get(0).description?if_exists) + "\""/>
		<#if listStatusItem?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign vaSI=vaSI + ",'" + StringUtil.wrapString(listStatusItem.get(i).statusId?if_exists) + "'"/>
				<#assign vaSIValue=vaSIValue + ",\"" + StringUtil.wrapString(listStatusItem.get(i).description?if_exists) +"\""/>
			</#list>
		</#if>
		<#assign vaSI=vaSI + "];"/>
		<#assign vaSIValue=vaSIValue + "];"/>
	<#else>
    	<#assign vaSI="var vaSI = [];"/>
    	<#assign vaSIValue="var vaSIValue = [];"/>
    </#if>
	${vaSI}
	${vaSIValue}	
	var dataStatusType = new Array();
	for(i=0;i < vaSI.length;i++){
		 var row = {};
	    row["statusId"] = vaSI[i];
	    row["description"] = vaSIValue[i];
	    dataStatusType[i] = row;
	}
	var dataInvoiceType = new Array();
	for(i=0;i < vaIT.length;i++){
		 var row = {};
	    row["invoiceTypeId"] = vaIT[i];
	    row["description"] = vaITValue[i];
	    dataInvoiceType[i] = row;
	}
</script>
<div id="jqxwindowpartyId" style="display:none;">
	<div>${uiLabelMap.SelectPartyId}</div>
	<div style="overflow: hidden;">
		<table id="PartyId">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdkey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdvalue" value=""/>
					<div id="jqxgridpartyid"></div>
				</td>
			</tr>
		    <tr>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
		</table>
	</div>
</div>
<div id="jqxwindowbillingAccountId" style="display:none;">
	<div>${uiLabelMap.SelectBillingAccountId}</div>
	<div style="overflow: hidden;">
		<table id="BillingAccountId">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowbillingAccountIdkey" value=""/>
					<input type="hidden" id="jqxwindowbillingAccountIdvalue" value=""/>
					<div id="jqxgridbillingaccountid"></div>
				</td>
			</tr>
		    <tr>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave2" value="${uiLabelMap.CommonSave}" /><input id="alterCancel2" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
		</table>
	</div>
</div>
<div id="jqxwindowpartyIdFrom" style="display:none;">
	<div>${uiLabelMap.SelectPartyIdFrom}</div>
	<div style="overflow: hidden;">
		<table id="PartyIdFrom">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdFromkey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdFromvalue" value=""/>
					<div id="jqxgridpartyidfrom"></div>
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
	$("#jqxwindowpartyIdFrom").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel3"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxwindowpartyIdFrom').on('open', function (event) {
    	var offset = $("#jqxgrid").offset();
   		$("#jqxwindowpartyIdFrom").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave3").click(function () {
		var tIndex = $('#jqxgridpartyidfrom').jqxGrid('selectedrowindex');
		var data = $('#jqxgridpartyidfrom').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindowpartyIdFromkey').val()).val(data.partyId);
		$("#jqxwindowpartyIdFrom").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindowpartyIdFromkey').val()).trigger(e);
	});
	// From party
    var sourceF =
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
            sourceF.totalrecords = data.TotalRows;
        },
        filter: function () {
            // update the grid and send a request to the server.
            $("#jqxgridpartyidfrom").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridpartyidfrom").jqxGrid('updatebounddata');
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
        url: 'jqxGeneralServicer?sname=getFromParty',
    };
    var dataAdapterF = new $.jqx.dataAdapter(sourceF,
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
                if (!sourceF.totalRecords) {
                    sourceF.totalRecords = parseInt(data['odata.count']);
                }
        }
    });
    $('#jqxgridpartyidfrom').jqxGrid(
    {
        width:800,
        source: dataAdapterF,
        filterable: true,
        virtualmode: true, 
        sortable:true,
        editable: false,
        showfilterrow: false,
        theme: theme, 
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
          { text: '${uiLabelMap.accApInvoice_ToPartyId}', datafield: 'partyId', width:150},
          { text: '${uiLabelMap.accApInvoice_ToPartyTypeId}', datafield: 'partyTypeId', width:200},
          { text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'firstName', width:150},
          { text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName', width:150},
          { text: '${uiLabelMap.accAccountingToParty}', datafield: 'groupName', width:150}
        ]
    });
</script>
<script type="text/javascript">
	$("#jqxwindowbillingAccountId").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel2"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxwindowbillingAccountId').on('open', function (event) {
    	var offset = $("#jqxgrid").offset();
   		$("#jqxwindowbillingAccountId").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave2").click(function () {
		var tIndex = $('#jqxgridbillingaccountid').jqxGrid('selectedrowindex');
		var data = $('#jqxgridbillingaccountid').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindowbillingAccountIdkey').val()).val(data.billingAccountId);
		$("#jqxwindowbillingAccountId").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindowbillingAccountIdkey').val()).trigger(e);
	});
	// BillingAccount
    var sourceB =
    {
        datafields:
        [
            { name: 'billingAccountId', type: 'string' },
            { name: 'description', type: 'string' },
            { name: 'externalAccountId', type: 'string' }
        ],
        cache: false,
        root: 'results',
        datatype: "json",
        updaterow: function (rowid, rowdata) {
            // synchronize with the server - send update command   
        },
        beforeprocessing: function (data) {
            sourceB.totalrecords = data.TotalRows;
        },
        filter: function () {
            // update the grid and send a request to the server.
            $("#jqxgridbillingaccountid").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridbillingaccountid").jqxGrid('updatebounddata');
        },
        sortcolumn: 'billingAccountId',
		sortdirection: 'asc',
        type: 'POST',
        data: {
	        noConditionFind: 'Y',
	        conditionsFind: 'N',
	    },
	    pagesize:5,
        contentType: 'application/x-www-form-urlencoded',
        url: 'jqxGeneralServicer?sname=JQGetListBillingAccoun',
    };
    var dataAdapterB = new $.jqx.dataAdapter(sourceB,
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
                if (!sourceB.totalRecords) {
                    sourceB.totalRecords = parseInt(data['odata.count']);
                }
        }
    });
    $('#jqxgridbillingaccountid').jqxGrid(
    {
        width:800,
        source: dataAdapterB,
        filterable: true,
        virtualmode: true, 
        sortable:true,
        editable: false,
        autoheight:true,
        pageable: true,
        theme: theme, 
        pagesizeoptions: ['5', '10', '15'],
        ready:function(){
        },
        rendergridrows: function(obj)
		{
			return obj.data;
		},
         columns: [
          { text: '${uiLabelMap.FormFieldTitle_billingAccountId}', datafield: 'billingAccountId'},
          { text: '${uiLabelMap.FormFieldTitle_description}', datafield: 'description'},
          { text: '${uiLabelMap.FormFieldTitle_externalAccountId}', datafield: 'externalAccountId'}
        ]
    });
</script>
<script type="text/javascript">
	$("#jqxwindowpartyId").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxWindow').on('open', function (event) {
    	//var offset = $("#jqxgrid").offset();
   		//$("#jqxwindowpartyId").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave").click(function () {
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
        url: 'jqxGeneralServicer?sname=getFromParty',
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
			  { text: '${uiLabelMap.accApInvoice_ToPartyId}', datafield: 'partyId', width:150},
	          { text: '${uiLabelMap.accApInvoice_ToPartyTypeId}', datafield: 'partyTypeId', width:200},
	          { text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'firstName', width:150},
	          { text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName', width:150},
	          { text: '${uiLabelMap.accAccountingToParty}', datafield: 'groupName', width:150}
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
<#assign dataField="[{ name: 'invoiceId', type: 'string' },
					 { name: 'invoiceTypeId', type: 'string'},
					 { name: 'invoiceDate', type: 'date', other:'Timestamp'},
					 { name: 'statusId', type: 'string'},
					 { name: 'description', type: 'string'},
					 { name: 'partyIdFrom', type: 'string'},
					 { name: 'billingAccountId', type: 'string'},
					 { name: 'partyId', type: 'string'},
					 { name: 'total', type: 'number'},
					 { name: 'currencyUomId', type: 'string'},
					 { name: 'amountToApply', type: 'number'},
					 { name: 'partyNameResultFrom', type: 'string'},
					 { name: 'partyNameResultTo', type: 'string'}
					 ]
					 "/>
<#assign columnlist="{ text: '${uiLabelMap.FormFieldTitle_invoiceId}', width:100, datafield: 'invoiceId', cellsrenderer:
                     	function(row, colum, value)
                        {
                        	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                        	return \"<span><a href='/delys/control/accArinvoiceOverview?invoiceId=\" + data.invoiceId + \"'>\" + data.invoiceId + \"</a></span>\";
                        }},
                     { text: '${uiLabelMap.accBillingAccountId}', filtertype: 'olbiusdropgrid', width:150, datafield: 'billingAccountId', hidden: true,
			   			createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(140);
			   			}},
					 { text: '${uiLabelMap.accAccountingToParty}', filtertype: 'olbiusdropgrid', width:150, datafield: 'partyId', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + data.partyNameResultTo + '[' + data.partyId + ']' + \"</span>\";
					 	},
			   			createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(140);
			   			}},
					 { text: '${uiLabelMap.accAccountingFromParty}', filtertype: 'olbiusdropgrid', width:500, datafield: 'partyIdFrom', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + data.partyNameResultFrom + '[' + data.partyIdFrom + ']' + \"</span>\";
					 	},
			   			createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(490);
			   			}},
					 { text: '${uiLabelMap.FormFieldTitle_invoiceTypeId}', filtertype: 'checkedlist', width:130, datafield: 'invoiceTypeId', cellsrenderer:
                     	function(row, colum, value)
                        {
                        	for(i=0; i < vaIT.length;i++){
                        		if(value==vaIT[i]){
                        			return \"<span>\" + vaITValue[i] + \"</span>\";
                        		}
                        	}
                        	return \"<span>\" + value + \"</span>\";
                        },
			   			createfilterwidget: function (column, columnElement, widget) {
			   				var sourceIT =
						    {
						        localdata: dataInvoiceType,
						        datatype: \"array\"
						    };
			   				var filterBoxAdapter = new $.jqx.dataAdapter(sourceIT,
			                {
			                    autoBind: true
			                });
			                var uniqueRecords = filterBoxAdapter.records;
			   				uniqueRecords.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
			   				widget.jqxDropDownList({ source: uniqueRecords, displayMember: 'invoiceTypeId', valueMember : 'invoiceTypeId', renderer: function (index, label, value) 
							{
								for(i=0;i < dataInvoiceType.length; i++){
									if(dataInvoiceType[i].invoiceTypeId == value){
										return dataInvoiceType[i].description;
									}
								}
							    return value;
							}});
							//widget.jqxDropDownList('checkAll');
			   			}},
					 { text: '${uiLabelMap.FormFieldTitle_invoiceDate}', filtertype: 'range', width:130, datafield: 'invoiceDate', cellsformat: 'dd/MM/yyyy'},
					 { text: '${uiLabelMap.CommonStatus}', filtertype: 'checkedlist', width:120, datafield: 'statusId', cellsrenderer:
                     	function(row, colum, value)
                        {
                        	for(i=0; i < vaSI.length;i++){
                        		if(value==vaSI[i]){
                        			return \"<span>\" + vaSIValue[i] + \"</span>\";
                        		}
                        	}
                        	return value;
                        },
			   			createfilterwidget: function (column, columnElement, widget) {
			   				var sourceST =
						    {
						        localdata: dataStatusType,
						        datatype: \"array\"
						    };
			   				var filterBoxAdapter2 = new $.jqx.dataAdapter(sourceST,
			                {
			                    autoBind: true
			                });
			                var uniqueRecords2 = filterBoxAdapter2.records;
			   				uniqueRecords2.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
			   				widget.jqxDropDownList({ source: uniqueRecords2, displayMember: 'statusId', valueMember : 'statusId', renderer: function (index, label, value) 
							{
								for(i=0;i < dataStatusType.length; i++){
									if(dataStatusType[i].statusId == value){
										return dataStatusType[i].description;
									}
								}
							    return value;
							}});
							//widget.jqxDropDownList('checkAll');
			   			}},
					 { text: '${uiLabelMap.description}', width:150, datafield: 'description'},
					 { text: '${uiLabelMap.FormFieldTitle_total}', sortable:false, filterable: false, width:200, datafield: 'total', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + formatcurrency(data.total,data.currencyUomId) + \"</span>\";
					 	}},
					 { text: '${uiLabelMap.FormFieldTitle_amountToApply}', sortable:false, filterable: false, width:200, datafield: 'amountToApply', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + formatcurrency(data.total,data.currencyUomId) + \"</span>\";
					 	}}"
					 />		

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdropdownlist.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcombobox.js"></script>
<style type="text/css">
	#addrowbutton{
		margin:0 !important;
		border-radius:0 !important;
	}
</style>
<div id="jqxPanel" style="width:40%;display:none;" >
	<table style="margin:0 auto;margin-top:10px;width:100%;position:relative;">
		<tr>
			<td>
				<div id="servicelist"></div>
			</td>
			<td align="left">
		       <input type="button" value="${uiLabelMap.CommonRun}" id='jqxButtonExecute' style="margin-left:8px;"/>
		    </td>
		</tr>
	</table>
</div>	 
<script type="text/javascript">
	/*var serviceList = new Array();
	var row = {};
	row.value = "<@ofbizUrl>PrintInvoices</@ofbizUrl>";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingPrintInvoices)}";
	serviceList[0] = row;
	row = {};
	row.value = "massInvoicesToApprove";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToApproved)}";
	serviceList[1] = row;
	row = {};
	row.value = "massInvoicesToSent";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToSent)}";
	serviceList[2] = row;
	row = {};
	row.value = "massInvoicesToReady";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToReady)}";
	serviceList[3] = row;
	row = {};
	row.value = "massInvoicesToPaid";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToPaid)}";
	serviceList[4] = row;
	row = {};
	row.value = "massInvoicesToWriteoff";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToWriteoff)}";
	serviceList[5] = row;
	row = {};
	row.value = "massInvoicesToCancel";
	row.description = "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToCancelled)}";
	serviceList[6] = row;
	$("#servicelist").jqxDropDownList({ checkboxes: false, source: serviceList, displayMember: "description", valueMember: "value", width: 270, height: 25});
	$("#jqxPanel").jqxPanel({ height: 60, theme:theme});
	$("#jqxButtonExecute").jqxButton({ width: '154', height: '30', theme:theme});
	*/
	function commonRun(serviceName){
		var selectedrowindexes = $('#jqxgrid').jqxGrid('selectedrowindexes');
		/*if($("#servicelist").val() == null || $("#servicelist").val() == ""){
			alert('Please choose action');
		}else if(selectedrowindexes.length == 0){
			alert('Please select invoices');
		}else{*/
		var row = $("#jqxgrid").jqxGrid('getrowdata', selectedrowindexes[0]);
		var arrInvoiceIds = row.invoiceId;
		for(i = 1; i < selectedrowindexes.length; i++){
			row = $("#jqxgrid").jqxGrid('getrowdata', selectedrowindexes[i]);
			arrInvoiceIds += "," + row.invoiceId;
		}
		if (serviceName == 'massInvoicesToApprove') {
            var statusIdType = "INVOICE_APPROVED";
        } else if (serviceName == 'massInvoicesToSent') {
            var statusIdType = "INVOICE_SENT";
        } else if (serviceName == 'massInvoicesToReady') {
            var statusIdType = "INVOICE_READY";
        } else if (serviceName == 'massInvoicesToPaid') {
            var statusIdType = "INVOICE_PAID";
        } else if (serviceName == 'massInvoicesToWriteoff') {
            var statusIdType = "INVOICE_WRITEOFF";
        } else if (serviceName == 'massInvoicesToCancel') {
            var statusIdType = "INVOICE_CANCELLED";
        }
        alert(statusIdType);
		var request = $.ajax({
		  url: "massChangeInvoiceStatus",
		  type: "POST",
		  
		  data: {serviceName : serviceName, 
		  		 organizationPartyId: '${defaultOrganizationPartyId?if_exists}', 
		  		 partyIdFrom: '${parameters.partyIdFrom?if_exists}', 
		  		 //statusId: '${parameters.statusId?if_exists}',
		  		 statusId : statusIdType,
		  		 fromInvoiceDate: '${parameters.fromInvoiceDate?if_exists}',
		  		 thruInvoiceDate: '${parameters.thruInvoiceDate?if_exists}',
		  		 fromDueDate: '${parameters.fromDueDate?if_exists}',
		  		 thruDueDate: '${parameters.thruDueDate?if_exists}',
		  		 invoiceStatusChange: '<@ofbizUrl>massChangeInvoiceStatus</@ofbizUrl>',
		  		 invoiceIds: arrInvoiceIds
		  		 },
		  dataType: "html"
		});
		
		request.done(function(data) {
		  	if(data.responseMessage == "error"){
            	$('#jqxNotification').jqxNotification({ template: 'error'});
            	$("#jqxNotification").text(data.errorMessage);
            	$("#jqxNotification").jqxNotification("open");
            }
            $("#jqxgrid").jqxGrid('updatebounddata');
		});
		
		request.fail(function(jqXHR, textStatus) {
		  alert( "Request failed: " + textStatus );
		});
		//}
	};
</script>
<div id='contextMenu' style="display:none;">
	<ul>
	    <li><i class="icon-ok"></i>${StringUtil.wrapString(uiLabelMap.commonRefresh)}</li>
	    <li>${StringUtil.wrapString(uiLabelMap.commonRun)}
	    	<ul style="width:250px;">
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingPrintInvoices)}</a></li>
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToApproved)}</a></li>
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToSent)}</a></li>
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToReady)}</a></li>
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToPaid)}</a></li>
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToWriteoff)}</a></li>
                <li><a href="#">${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToCancelled)}</a></li>
            </ul>
	    </li>
	</ul>
</div>
<script type="text/javascript">
	$("#contextMenu").jqxMenu({ width: 200, height: 58, autoOpenPopup: false, mode: 'popup', theme: theme});
	$("#contextMenu").on('itemclick', function (event) {
		var args = event.args;
        var rowindex = $("#jqxgrid").jqxGrid('getselectedrowindex');
        var tmpKey = $.trim($(args).text());
        if (tmpKey == "${StringUtil.wrapString(uiLabelMap.commonRefresh)}") {
        	$("#jqxgrid").jqxGrid('updatebounddata');
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingPrintInvoices)}") {
        	var selectedrowindexes = $('#jqxgrid').jqxGrid('selectedrowindexes');
        	var row = $("#jqxgrid").jqxGrid('getrowdata', selectedrowindexes[0]);
			var arrInvoiceIds = row.invoiceId;
			for(i = 1; i < selectedrowindexes.length; i++){
				row = $("#jqxgrid").jqxGrid('getrowdata', selectedrowindexes[i]);
				arrInvoiceIds += "," + row.invoiceId;
			}
        	var request = $.ajax({
			  url: "<@ofbizUrl>PrintInvoices</@ofbizUrl>",
			  type: "POST",
			  data: {
			  		 organizationPartyId: '${defaultOrganizationPartyId?if_exists}', 
			  		 partyIdFrom: '${parameters.partyIdFrom?if_exists}', 
			  		 statusId: '${parameters.statusId?if_exists}',
			  		 fromInvoiceDate: '${parameters.fromInvoiceDate?if_exists}',
			  		 thruInvoiceDate: '${parameters.thruInvoiceDate?if_exists}',
			  		 fromDueDate: '${parameters.fromDueDate?if_exists}',
			  		 thruDueDate: '${parameters.thruDueDate?if_exists}',
			  		 invoiceStatusChange: '<@ofbizUrl>massChangeInvoiceStatus</@ofbizUrl>',
			  		 invoiceIds: arrInvoiceIds
			  		 },
			  dataType: "html"
			});
			
			request.done(function(data) {
			  	if(data.responseMessage == "error"){
	            	$('#jqxNotification').jqxNotification({ template: 'error'});
	            	$("#jqxNotification").text(data.errorMessage);
	            	$("#jqxNotification").jqxNotification("open");
	            }
			});
			
			request.fail(function(jqXHR, textStatus) {
			  alert( "Request failed: " + textStatus );
			});
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToApproved)}") {
        	commonRun("massInvoicesToApprove");
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToSent)}") {
        	commonRun("massInvoicesToSent");
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToReady)}") {
        	commonRun("massInvoicesToReady");
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToPaid)}") {
        	commonRun("massInvoicesToPaid");
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToWriteoff)}") {
        	commonRun("massInvoicesToWriteoff");
        }else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.AccountingInvoiceStatusToCancelled)}") {
        	commonRun("massInvoicesToCancel");
        }
	});
</script>
<@jqGrid url="jqxGeneralServicer?sname=JQGetListARInvoice" dataField=dataField columnlist=columnlist jqGridMinimumLibEnable="false" filterable="true" filtersimplemode="true" addrow="true" addType="popup"
		 otherParams="total:S-getInvoiceTotal(inputValue{invoiceId})<outputValue>;amountToApply:S-getInvoiceNotApplied(inputValue{invoiceId})<outputValue>;partyNameResultFrom:S-getPartyNameForDate(partyId{partyIdFrom},compareDate{invoiceDate},lastNameFirst*Y)<fullName>;partyNameResultTo:S-getPartyNameForDate(partyId,compareDate{invoiceDate},lastNameFirst*Y)<fullName>"
		 addColumns="invoiceId" showtoolbar="false" alternativeAddPopup="alterpopupWindow" id="jqxgrid" selectionmode="checkbox" altrows="true" mouseRightMenu="true" contextMenuId="contextMenu"
		 defaultSortColumn="-invoiceDate" usecurrencyfunction="true"/>
