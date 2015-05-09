<script type="text/javascript">
	
	var dataPartyNameView = new Array();
	<#list 0..(listPartyNameView.size() - 1) as i>
		var row = {};
	    row["partyId"] = "${StringUtil.wrapString(listPartyNameView.get(i).partyId?if_exists)}";
	    row["description"] = "${StringUtil.wrapString(listPartyNameView.get(i).lastName?if_exists)+ StringUtil.wrapString(listPartyNameView.get(i).groupName?if_exists) + StringUtil.wrapString(listPartyNameView.get(i).firstName?if_exists)}";
	    dataPartyNameView[${i}] = row;
	</#list>
	
	var dataStatusItem = new Array();
	<#list 0..(listStatusItem.size() - 1) as i>
		var row = {};
	    row["statusId"] = "${StringUtil.wrapString(listStatusItem.get(i).statusId?if_exists)}";
	    row["description"] = "${StringUtil.wrapString(listStatusItem.get(i).description?if_exists)}";
	    dataStatusItem[${i}] = row;
	</#list>
	var dataPaymentType = new Array();
	<#list 0..(listPaymentType.size() - 1) as i>
		row = {};
	    row["paymentTypeId"] = "${StringUtil.wrapString(listPaymentType.get(i).paymentTypeId?if_exists)}";
	    row["description"] = "${StringUtil.wrapString(listPaymentType.get(i).description?if_exists)}";
	    dataPaymentType[${i}] = row;
	</#list>
</script>
<div id="jqxwindowpartyIdTo">
	<div>${uiLabelMap.SelectPartyId}</div>
	<div style="overflow: hidden;">
		<table id="PartyId">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdTokey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdTovalue" value=""/>
					<div id="jqxgridpartyidto"></div>
				</td>
			</tr>
		    <tr>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
		</table>
	</div>
</div>
<div id="jqxwindowpartyIdFrom">
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
	$("#alterSave3").jqxButton({theme: theme});
	$("#alterCancel3").jqxButton({theme: theme});
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
	$("#jqxwindowpartyIdTo").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxWindow').on('open', function (event) {
    	var offset = $("#jqxgrid").offset();
   		$("#jqxwindowpartyIdTo").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave").jqxButton({theme: theme});
	$("#alterCancel").jqxButton({theme: theme});
	$("#alterSave").click(function () {
		var tIndex = $('#jqxgridpartyidto').jqxGrid('selectedrowindex');
		var data = $('#jqxgridpartyidto').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindowpartyIdTokey').val()).val(data.partyId);
		$("#jqxwindowpartyIdTo").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindowpartyIdTokey').val()).trigger(e);
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
            $("#jqxgridpartyidto").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridpartyidto").jqxGrid('updatebounddata');
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
    $('#jqxgridpartyidto').jqxGrid(
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
<#assign dataField="[{ name: 'paymentId', type: 'string' },
					 { name: 'paymentTypeId', type: 'string'},
					 { name: 'statusId', type: 'string'},
					 { name: 'comments', type: 'string'},
					 { name: 'partyIdFrom', type: 'string'},
					 { name: 'partyIdTo', type: 'string'},
					 { name: 'effectiveDate', type: 'date', other:'Timestamp'},
					 { name: 'amount', type: 'number'},
					 { name: 'amountToApply', type: 'number'},
					 { name: 'currencyUomId', type: 'string'}]
					 "/>
<#assign columnlist="{ text: '${uiLabelMap.FormFieldTitle_paymentId}', width:100, filtertype:'input', datafield: 'paymentId', cellsrenderer:
                     	 function(row, colum, value)
                        {
                        	return \"<span><a href='/delys/control/accAppaymentOverview?paymentId=\" + value + \"'>\" + value + \"</a></span>\";
                        }},
					 { text: '${uiLabelMap.FormFieldTitle_paymentTypeId}', filtertype: 'checkedlist', width:200, datafield: 'paymentTypeId', cellsrenderer:
                     	 function(row, colum, value)
                        {
                        	for(i=0; i<dataPaymentType.length;i++){
                        		if(dataPaymentType[i].paymentTypeId==value){
                        			return \"<span>\" + dataPaymentType[i].description +\"</span>\";
                    			}
                        	}
                        	return \"<span>\" + value + \"</span>\";
                        },
			   			createfilterwidget: function (column, columnElement, widget) {
			   				var sourcePT =
						    {
						        localdata: dataPaymentType,
						        datatype: \"array\"
						    };
			   				var filterBoxAdapterPT = new $.jqx.dataAdapter(sourcePT,
			                {
			                    autoBind: true
			                });
			                var uniqueRecordsPT = filterBoxAdapterPT.records;
			   				uniqueRecordsPT.splice(0, 0, '(Select All)');
			   				widget.jqxDropDownList({ source: uniqueRecordsPT, displayMember: 'paymentTypeId', valueMember : 'paymentTypeId', renderer: function (index, label, value) 
							{
								for(i=0;i < dataPaymentType.length; i++){
									if(dataPaymentType[i].paymentTypeId == value){
										return dataPaymentType[i].description;
									}
								}
							    return value;
							}});
							//widget.jqxDropDownList('checkAll');
			   			}},
					 { text: '${uiLabelMap.FormFieldTitle_statusId}', filtertype: 'checkedlist', width:180, datafield: 'statusId', cellsrenderer:
                     	 function(row, colum, value)
                        {
                        	for(i=0; i<dataStatusItem.length;i++){
                        		if(dataStatusItem[i].statusId==value){
                        			return \"<span>\" + dataStatusItem[i].description +\"</span>\";
                    			}
                        	}
                        	return \"<span>\" + value + \"</span>\";
                        },
			   			createfilterwidget: function (column, columnElement, widget) {
			   				var sourceSI =
						    {
						        localdata: dataStatusItem,
						        datatype: \"array\"
						    };
			   				var filterBoxAdapterSI = new $.jqx.dataAdapter(sourceSI,
			                {
			                    autoBind: true
			                });
			                var uniqueRecordsSI = filterBoxAdapterSI.records;
			   				uniqueRecordsSI.splice(0, 0, '(Select All)');
			   				widget.jqxDropDownList({ source: uniqueRecordsSI, displayMember: 'statusId', valueMember : 'statusId', height: '25px',renderer: function (index, label, value) 
							{
								for(i=0;i < dataStatusItem.length; i++){
									if(dataStatusItem[i].statusId == value){
										return dataStatusItem[i].description;
									}
								}
							    return value;
							}});
							widget.jqxDropDownList('checkAll');
			   			}},
					 { text: '${uiLabelMap.FormFieldTitle_comments}', filtertype:'input', width:100, datafield: 'comments'},
					 { text: '${uiLabelMap.FormFieldTitle_partyIdFrom}', filtertype: 'olbiusdropgrid', width:500, datafield: 'partyIdFrom', cellsrenderer:
                     	 function(row, colum, value)
                        {
                        	for(i=0; i<dataPartyNameView.length;i++){
                        		if(dataPartyNameView[i].partyId==value){
                        			return \"<span>\" + dataPartyNameView[i].description + \"&nbsp;<a href='/partymgr/control/viewprofile?partyId=\" + value + \"'>[\" + value + \"]</a></span>\";
                    			}
                        	}
                        	return \"<span><a href='/partymgr/control/viewprofile?partyId=\" + value + \"'>[\" + value + \"</a></span>\";
                        },
			   			createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(490);
			   			}},
					 { text: '${uiLabelMap.FormFieldTitle_partyIdTo}', filtertype: 'olbiusdropgrid', width:150, datafield: 'partyIdTo', cellsrenderer:
                     	 function(row, colum, value)
                        {
                        	for(i=0; i<dataPartyNameView.length;i++){
                        		if(dataPartyNameView[i].partyId==value){
                        			return \"<span>\" + dataPartyNameView[i].description + \"&nbsp;<a href='/partymgr/control/viewprofile?partyId=\" + value + \"'>[\" + value + \"]</a></span>\";
                    			}
                        	}
                        	return \"<span>\" + value + \"</span>\";
                        },
			   			createfilterwidget: function (column, columnElement, widget) {
			   				widget.width(140);
			   			}},
					 { text: '${uiLabelMap.FormFieldTitle_effectiveDate}', filtertype: 'range', width:100, datafield: 'effectiveDate', cellsformat: 'dd/MM/yyyy'},
					 { text: '${uiLabelMap.FormFieldTitle_amount}', sortable: false, filterable: false, width:150, datafield: 'amount', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + formatcurrency(data.amount,data.currencyUomId) + \"</span>\";
					 	}},
					 { text: '${uiLabelMap.FormFieldTitle_amountToApply}', sortable: false, filterable: false, width:150, datafield: 'amountToApply', cellsrenderer:
					 	function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					 		return \"<span>\" + formatcurrency(data.amountToApply,data.currencyUomId) + \"</span>\";
					 	}}
					"/>
<div id="jqxPanel" style="width:400px;">
	<table style="margin:0 auto;margin-top:10px;width:100%;position:relative;">
		<tr>
			<td>
				<input type="button" value="${uiLabelMap.newInPayment}" id='jqxButton1' />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;  
	$("#jqxPanel").jqxPanel({ height: 50, theme:theme});
	$("#jqxButton1").jqxButton({ width: '150', theme: theme});
	var globalPaymentType = "I";
	$("#jqxButton1").on('click', function () {
		$('#alterpopupWindow').jqxWindow('open');
    });
</script>
<@jqGrid url="jqxGeneralServicer?sname=JQListAPPayment" dataField=dataField columnlist=columnlist jqGridMinimumLibEnable="false" filterable="true" filtersimplemode="true"
		 otherParams="amountToApply:S-getListApPayment(inputValue{paymentId})<outputValue>" usecurrencyfunction="true"
		 createUrl="jqxGeneralServicer?jqaction=C&sname=createPaymentAndFinAccountTrans" addrefresh="true"
		 addColumns="statusId[PMNT_NOT_PAID];currencyUomId[${defaultOrganizationPartyCurrencyUomId}];partyIdFrom;paymentTypeId;partyIdTo;paymentMethodId;paymentRefNum;overrideGlAccountId;amount(java.math.BigDecimal);comments;isDepositWithDrawPayment[Y];finAccountTransTypeId[WITHDRAWAL]" showtoolbar="false" addrow="true" showtoolbar="false"/>					
<form id="alterpopupWindowform">
	<div id="alterpopupWindow">
	    <div>${uiLabelMap.accCreateNew}</div>
	    <div style="overflow: hidden;">
			<table>
				<tr>
					<td align="left">
						${uiLabelMap.organizationPartyId}
					</td>
					<td align="left">
				       <div id="organizationPartyId"></div>
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.partyIdTo}
					</td>
					<td align="left">
				       <div id="jqxdropdownbuttonToParty">
				       	 <div id="jqxgridToParty"></div>
				       </div>
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.AccountingPaymentType}
					</td>
					<td align="left">
				       <div id="paymentTypeId"></div>
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.AccountingPaymentMethodId}
					</td>
					<td align="left">
				       <div id="paymentMethodId"></div>
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.paymentRefNum}
					</td>
					<td align="left">
				       <input id="paymentRefNum"/>
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.overrideGlAccountId}
					</td>
					<td align="left">
				       <div id="jqxdropdownbuttonoverrideGlAccountId">
				       	 <div id="jqxgridoverrideGlAccountId"></div>
				       </div>
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.amount}
					</td>
					<td align="left">
				       <input id="amount" />
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.comments}
					</td>
					<td align="left">
				       <input id="comments" />
				    </td>
				</tr>
				<tr>
					<td align="left">
						${uiLabelMap.finAccountId}
					</td>
					<td align="left">
				       <div id="finAccountId"></div>
				    </td>
				</tr>
				<tr>
			        <td align="right"></td>
			        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave4" value="${uiLabelMap.CommonSave}" /><input id="alterCancel4" type="button" value="${uiLabelMap.CommonCancel}" /></td>
			    </tr>
			</table>
		</div>
	</div>		
</form>	
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script type="text/javascript">
	var dataPAGA = new Array();
    var row;
    <#list listPartyAcctgPrefAndGroup as lpaga>
        row = {};
        row["partyId"] = "${lpaga.partyId}";
        row["groupName"] = "${lpaga.groupName}";
        dataPAGA[${lpaga_index}] = row;
    </#list>
    

	var dataPTE = new Array();
    <#list listPaymentTypeExport as lpte>
        row = {};
        row["paymentTypeId"] = "${lpte.paymentTypeId}";
        row["description"] = "${lpte.description}";
        dataPTE[${lpte_index}] = row;
    </#list>
    
    var dataPM = new Array();
    <#list listPaymentMethod as lpm>
        row = {};
        row["paymentMethodId"] = "${lpm.paymentTypeId}";
        row["description"] = "${lpm.description}";
        dataPM[${lpm_index}] = row;
    </#list>
    
    var dataFA = new Array();
    <#list listFinAccount as lfa>
        row = {};
        row["finAccountId"] = "${lfa.finAccountId}";
        row["description"] = "${lfa.finAccountName}[${lfa.finAccountId}]";
        dataFA[${lfa_index}] = row;
    </#list>
    
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;  
	var outFilterCondition = "";
	$("#alterpopupWindow").jqxWindow({
        width: 500, height: 430, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel4"), modalOpacity: 0.7, theme:theme           
    });
    $("#alterSave4").jqxButton({theme: theme});
	$("#alterCancel4").jqxButton({theme: theme});
	$("#organizationPartyId").jqxDropDownList({ theme: theme, source: dataPAGA, displayMember: "groupName", valueMember: "partyId", selectedIndex: 1, width: '200', height: '25'});
	$("#paymentTypeId").jqxDropDownList({ theme: theme, source: dataPTE, displayMember: "description", valueMember: "paymentTypeId", selectedIndex: 1, width: '200', height: '25'});
	$("#paymentMethodId").jqxDropDownList({ theme: theme, source: dataPM, displayMember: "description", valueMember: "paymentMethodId", selectedIndex: 1, width: '200', height: '25'});
	$("#finAccountId").jqxDropDownList({ theme: theme, source: dataFA, displayMember: "description", valueMember: "finAccountId", selectedIndex: 1, width: '200', height: '25'});
    $("#paymentRefNum").jqxInput({theme: theme, width:195});
    $("#amount").jqxInput({theme: theme, width:195});
    $("#comments").jqxInput({theme: theme, width:195});
    // GLAccount
    var sourceG =
    {
        datafields:
        [
            { name: 'glAccountId', type: 'string' },
            { name: 'accountName', type: 'string' },
            { name: 'glAccountTypeId', type: 'string' },
            { name: 'glAccountClassId', type: 'string' }
        ],
        cache: false,
        root: 'results',
        datatype: "json",
        updaterow: function (rowid, rowdata) {
            // synchronize with the server - send update command   
        },
        beforeprocessing: function (data) {
            sourceG.totalrecords = data.TotalRows;
        },
        filter: function () {
            // update the grid and send a request to the server.
            $("#jqxgridoverrideGlAccountId").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridoverrideGlAccountId").jqxGrid('updatebounddata');
        },
        sortcolumn: 'glAccountId',
		sortdirection: 'asc',
        type: 'POST',
        data: {
	        noConditionFind: 'Y',
	        conditionsFind: 'N',
	    },
	    pagesize:5,
        contentType: 'application/x-www-form-urlencoded',
        url: 'jqxGeneralServicer?sname=JQGetListGLAccounts',
    };
    var dataAdapterG = new $.jqx.dataAdapter(sourceG,
    {
    	formatData: function (data) {
	    	data.noConditionFind="Y";
			data.glAccountId_op="contains";
			data.glAccountId="";
			data.glAccountId_ic="Y";
			data.glAccountTypeId="";
			data.glAccountClassId_op="contains";
			data.glAccountClassId="";
			data.glAccountClassId_ic="Y";
            return data;
        },
        loadError: function (xhr, status, error) {
            alert(error);
        },
        downloadComplete: function (data, status, xhr) {
                if (!sourceG.totalRecords) {
                    sourceG.totalRecords = parseInt(data["odata.count"]);
                }
        }, 
        beforeLoadComplete: function (records) {
        	for (var i = 0; i < records.length; i++) {
        		if(typeof(records[i])=="object"){
        			for(var key in records[i]) {
        				var value = records[i][key];
        				if(value != null && typeof(value) == "object" && typeof(value) != null){
        					var date = new Date(records[i][key]["time"]);
        					records[i][key] = date;
        				}
        			}
        		}
        	}
        }
    });
    $("#jqxdropdownbuttonoverrideGlAccountId").jqxDropDownButton({theme: theme,  width: 200, height: 25});
    $("#jqxgridoverrideGlAccountId").jqxGrid({
    	width:800,
        source: dataAdapterG,
        filterable: false,
        virtualmode: true, 
        sortable:true,
        editable: false,
        theme: theme,
        autoheight:true,
        pageable: true,
        rendergridrows: function(obj)
		{
			return obj.data;
		},
        columns: [
          { text: '${uiLabelMap.FormFieldTitle_glAccountId}', datafield: 'glAccountId'},
          { text: '${uiLabelMap.FormFieldTitle_accountName}', datafield: 'accountName'},
          { text: '${uiLabelMap.FormFieldTitle_glAccountTypeId}', datafield: 'glAccountTypeId'},
          { text: '${uiLabelMap.FormFieldTitle_glAccountClassId}', datafield: 'glAccountClassId'}
        ]
    });
    $("#jqxgridoverrideGlAccountId").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxgridoverrideGlAccountId").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['glAccountId'] +'</div>';
        $('#jqxdropdownbuttonoverrideGlAccountId').jqxDropDownButton('setContent', dropDownContent);
    });
    // ToParty
    var sourceP2 =
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
            sourceP2.totalrecords = data.TotalRows;
        },
        filter: function () {
            // update the grid and send a request to the server.
            $("#jqxgridFromParty").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridToParty").jqxGrid('updatebounddata');
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
    var dataAdapterP2 = new $.jqx.dataAdapter(sourceP2,
    {
    	formatData: function (data) {
	    	data.noConditionFind="Y";
			data.partyId_op="contains";
			data.partyId="";
			data.partyId_ic="Y";
			data.partyTypeId="";
			data.firstName_op="contains";
			data.firstName="";
			data.firstName_ic="Y";
			data.lastName_op="contains";
			data.lastName="";
			data.lastName_ic="Y";
			data.groupName_op="contains";
			data.groupName="";
			data.groupName_ic="Y";
			data.presentation="layer";
            return data;
        },
        loadError: function (xhr, status, error) {
            alert(error);
        },
        downloadComplete: function (data, status, xhr) {
                if (!sourceP2.totalRecords) {
                    sourceP2.totalRecords = parseInt(data["odata.count"]);
                }
        }, 
        beforeLoadComplete: function (records) {
        	for (var i = 0; i < records.length; i++) {
        		if(typeof(records[i])=="object"){
        			for(var key in records[i]) {
        				var value = records[i][key];
        				if(value != null && typeof(value) == "object" && typeof(value) != null){
        					//var date = new Date(records[i][key]["time"]);
        					//records[i][key] = date;
        				}
        			}
        		}
        	}
        }
    });
    $("#jqxdropdownbuttonToParty").jqxDropDownButton({ theme: theme, width: 200, height: 25});
    $("#jqxgridToParty").jqxGrid({
    	width:800,
        source: dataAdapterP2,
        filterable: false,
        virtualmode: true, 
        sortable:true,
        theme: theme,
        editable: false,
        autoheight:true,
        pageable: true,
        rendergridrows: function(obj)
		{
			return obj.data;
		},
        columns: [
          { text: '${uiLabelMap.accApInvoice_partyId}', datafield: 'partyId'},
          { text: '${uiLabelMap.accApInvoice_partyTypeId}', datafield: 'partyTypeId'},
          { text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'firstName'},
          { text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName'},
          { text: '${uiLabelMap.accAccountingFromParty}', datafield: 'groupName'}
        ]
    });
    $("#jqxgridToParty").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxgridToParty").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['partyId'] +'</div>';
        $('#jqxdropdownbuttonToParty').jqxDropDownButton('setContent', dropDownContent);
    });
    $("#alterCancel").jqxButton({theme: theme});
    $("#alterSave4").jqxButton({theme: theme});

    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave4").click(function () {
    	if($('#alterpopupWindowform').jqxValidator('validate')){
	    	var row;
	        row = { 
	        		partyIdFrom:$('#organizationPartyId').val(),
	        		partyIdTo:$('#jqxdropdownbuttonToParty').val(),
	        		paymentTypeId:$('#paymentTypeId').val(),
	        		paymentMethodId:$('#paymentMethodId').val(),
	        		paymentRefNum:$('#paymentRefNum').val(),
	        		overrideGlAccountId:$('#jqxdropdownbuttonoverrideGlAccountId').val(),
	        		amount:$('#amount').val(),
	        		comments: $('#comments').val(),            
	        	  };
		   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	        // select the first row and clear the selection.
	        $("#jqxgrid").jqxGrid('clearSelection');                        
	        $("#jqxgrid").jqxGrid('selectRow', 0);  
	        $("#alterpopupWindow").jqxWindow('close');
        }else{
        	return;
        }
    });
    $('#alterpopupWindowform').jqxValidator({
        rules: [
                   {
                        input: "#organizationPartyId", message: "${uiLabelMap.CommonRequired}", action: 'blur', rule: function (input, commit) {
                            var index = $("#organizationPartyId").jqxDropDownList('getSelectedIndex');
                            return index != -1;
                        }
                   },
                   { input: '#amount', message: '${uiLabelMap.CommonRequired}', action: 'keyup, blur', rule: 'required' }
               ]
    });
</script>		
