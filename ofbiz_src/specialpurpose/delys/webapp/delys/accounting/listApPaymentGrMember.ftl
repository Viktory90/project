<script>
	<#assign listParty = delegator.findList("PartyNameView", null, null, null, null, false) />
	var paData = new Array();
	<#list listParty as item>
		var row = {};
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + StringUtil.wrapString(item.middleName?if_exists) + StringUtil.wrapString(item.lastName?if_exists) + StringUtil.wrapString(item.groupName?if_exists)) />
		row['partyId'] = '${item.partyId?if_exists}';
		row['description'] = '${description?if_exists}';
		paData[${item_index}] = row;
	</#list>
	
	<#assign payTypes = delegator.findList("PaymentType", null, null, null, null, false) />
	var payData = new Array();
	<#list payTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description) />
		row['paymentTypeId'] = '${item.paymentTypeId}';
		row['description'] = '${item.description}';
		payData[${item_index}] = row;
	</#list>
	
	<#assign payMethodTypes = delegator.findList("PaymentMethodType", null, null, null, null, false) />
	var payMethodData = new Array();
	<#list payMethodTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description) />
		row['paymentMethodTypeId'] = '${item.paymentMethodTypeId}';
		row['description'] = '${description}';
		payMethodData[${item_index}] = row;
	</#list>
</script>
<#assign dataField="[{ name: 'paymentId', type: 'string' },
					 { name: 'paymentGroupId', type: 'string' },
					 { name: 'paymentRefNum', type: 'number'},
					 { name: 'partyIdFrom', type: 'string'},
					 { name: 'partyIdTo', type: 'string'},
					 { name: 'paymentTypeId', type: 'string'},
					 { name: 'currencyUomId', type: 'string'},
					 { name: 'paymentMethodTypeId', type: 'string'},
					 { name: 'amount', type: 'number'},
					 { name: 'fromDate', type: 'date'},
					 { name: 'thruDate', type: 'date'}
					 ]"/>

<#assign columnlist="{ text: '${uiLabelMap.paymentId}', datafield: 'paymentId', editable: false, 
						cellsrenderer: function(row, column, value){
							return '<span><a href=paymentOverview?paymentId='+ value +'>' + value + '</a></span>';
						}
					 },
					 { text: '${uiLabelMap.paymentRefNum}', datafield: 'paymentRefNum', editable: false},
					 { text: '${uiLabelMap.partyIdFrom}', datafield: 'partyIdFrom', editable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < paData.length; i++){
								 if(paData[i].partyId == value){
									 return '<span>' + paData[i].description + '<a href=viewprofile?partyId=' + value + '>[' + value +']</a></span>'
								 }
							 }
							 return ;
						 }
					 },
					 { text: '${uiLabelMap.partyIdTo}', datafield: 'partyIdTo', editable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < paData.length; i++){
								 if(paData[i].partyId == value){
									 return '<span>' + paData[i].description + '<a href=viewprofile?partyId=' + value + '>[' + value +']</a></span>'
								 }
							 }
							 return ;
					   }
					 },
					 { text: '${uiLabelMap.paymentTypeId}', datafield: 'paymentTypeId', editable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < payData.length; i++){
								 if(payData[i].paymentTypeId == value){
									 return '<span title=' + value +'>' + payData[i].description + '</span>'
								 }
							 }
							 return;
						 }
					 },
					 { text: '${uiLabelMap.paymentMethodTypeId}', datafield: 'paymentMethodTypeId', editable: false,
						 cellsrenderer: function(row, column, value){
							 for(i = 0; i < payMethodData.length; i++){
								 if(payMethodData[i].paymentMethodTypeId == value){
									 return '<span title=' + value +'>' + payMethodData[i].description + '</span>'
								 }
							 }
							 return;
						 }
					 },
					 { text: '${uiLabelMap.amount}', datafield: 'amount', editable: false, filterable: false, sortable: false,
						 cellsrenderer: function(row, column, value){
							 var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							 return '<span>' + formatcurrency(data.amount,data.currencyUomId) +'</span>';
						 }
					 },
					 { text: '${uiLabelMap.fromDate}', datafield: 'fromDate', editable: false, cellsformat: 'dd/MM/yyyy hh:mm:ss fff'},
					 { text: '${uiLabelMap.thruDate}', datafield: 'thruDate', editable: true, cellsformat: 'dd/MM/yyyy'}
					"/>
<@jqGrid    filtersimplemode="false" addrefresh="true" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow" editable="true"
		 	url="jqxGeneralServicer?sname=JQApListPaymentGroupMember&paymentGroupId=${parameters.paymentGroupId}"
		 	removeUrl="jqxGeneralServicer?sname=expirePaymentGroupMember&jqaction=D&paymentGroupId=${parameters.paymentGroupId}"
		 	deleteColumn="paymentGroupId;paymentId;fromDate(java.sql.Timestamp)"
		 	createUrl="jqxGeneralServicer?sname=createPaymentGroupMember&jqaction=C&paymentGroupId=${parameters.paymentGroupId}"
		 	addColumns="paymentGroupId[${parameters.paymentGroupId}];paymentId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);sequenceNum(java.lang.Long)"
		 	updateUrl="jqxGeneralServicer?sname=updatePaymentGroupMember&jqaction=U&paymentGroupId=${parameters.paymentGroupId}"
		 	editColumns="paymentGroupId;paymentId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp)"
		 	/>
<div id="alterpopupWindow">
	<div>${uiLabelMap.accCreateNew}</div>
	<div style="overflow: hidden;">
		<table>
			<tr>
				<td align="left">
					${uiLabelMap.paymentId}
				</td>
				<td align="left">
					<div id="paymentIdAdd">
						<div id="jqxPayGrid"/>
					</div>
				</td>
			</tr>
			<tr>
				<td align="left">
					${uiLabelMap.fromDate}
				</td>
				<td align="left">
					<div id="fromDateAdd">
		       	 	</div>
		       	 </td>
		   </tr>
		   <tr>
				<td align="left">
					${uiLabelMap.thruDate}
				</td>
				<td align="left">
					<div id="thruDateAdd"></div>
				</td>
			</tr>
			<tr>
				<td align="left">
					${uiLabelMap.sequenceNum}
				</td>
				<td align="left">
					<input id="sequenceNumAdd"></input>
				</td>
			</tr>
			<tr>
	        	<td align="right"></td>
	        	<td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
	        </tr>
	     </table>
	 </div>
</div>
<script>
	//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	//Create Popup Window
	$("#alterpopupWindow").jqxWindow({
        width: 500, height: 300, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	
	//Create Button
	$("#alterSave").jqxButton({theme: theme});
	$("#alterCancel").jqxButton({theme: theme});
	
	//Create fromDate
	$("#fromDateAdd").jqxDateTimeInput({width: '200px', height: '25px'});
	
	//Create thruDate
	$("#thruDateAdd").jqxDateTimeInput({width: '200px', height: '25px'});
	
	$("#sequenceNumAdd").jqxInput({width: '195px'});
	//Create paymentId
	var sourcePayment =
		{
			datafields:
				[
				 { name: 'paymentId', type: 'string' },
				 { name: 'partyIdFrom', type: 'string' },
				 { name: 'partyIdTo', type: 'string' },
				 { name: 'effectiveDate', type: 'date' },
				 { name: 'amount', type: 'number' },
				 { name: 'currencyUomId', type: 'string' }
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourcePayment.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxPayGrid").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxPayGrid").jqxGrid('updatebounddata');
			},
			sortcolumn: 'paymentId',
			sortdirection: 'asc',
			type: 'POST',
			data: {
				noConditionFind: 'Y',
				conditionsFind: 'N',
			},
			pagesize:5,
			contentType: 'application/x-www-form-urlencoded',
			url: 'jqxGeneralServicer?sname=getListPayment',
		};
	var dataAdapterPayment = new $.jqx.dataAdapter(sourcePayment);
	$("#paymentIdAdd").jqxDropDownButton({theme: theme,  width: 200, height: 25});
	$("#jqxPayGrid").jqxGrid({
	width:800,
    source: dataAdapterPayment,
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
      { text: '${uiLabelMap.paymentId}', datafield: 'paymentId'},
      { text: '${uiLabelMap.partyIdFrom}', datafield: 'partyIdFrom'},
      { text: '${uiLabelMap.partyIdTo}', datafield: 'partyIdTo'},
      { text: '${uiLabelMap.effectiveDate}', datafield: 'effectiveDate'},
      { text: '${uiLabelMap.amount}', datafield: 'amount'},
      { text: '${uiLabelMap.currencyUomId}', datafield: 'currencyUomId'}
    ]
	});
	$("#jqxPayGrid").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxPayGrid").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['paymentId'] +'</div>';
		alert(dropDownContent);
		$('#paymentId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	// update the edited row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
	    var row;
	    row = { 
	    		paymentId:$('#paymentId').val(),
	    		fromDate:$('#fromDate').jqxDateTimeInput('getDate'),
	    		thruDate:$('#thruDate').jqxDateTimeInput('getDate'),
	    		sequenceNum:$('#sequenceNum').val()
	        };
		$("#jqxgrid").jqxGrid('addRow', null, row, "first");
	    // select the first row and clear the selection.
	    $("#jqxgrid").jqxGrid('clearSelection');                        
	    $("#jqxgrid").jqxGrid('selectRow', 0);  
	    $("#alterpopupWindow").jqxWindow('close');
    });
</script>