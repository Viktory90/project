<script>
	<#assign acctgTransTypes = delegator.findList("AcctgTransType", null, null, null, null, false) />
	var acctgTransTypesData =  new Array();
	<#list acctgTransTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)>
		row['acctgTransTypeId'] = "${item.acctgTransTypeId?if_exists}";
		row['description'] = "${description}";
		acctgTransTypesData[${item_index}] = row;
	</#list>
	
	<#assign glFiscalTypes = delegator.findList("GlFiscalType", null, null, null, null, false) />
	var glFiscalTypesData =  new Array();
	<#list glFiscalTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)>
		row['glFiscalTypeId'] = "${item.glFiscalTypeId?if_exists}";
		row['description'] = "${description}";
		glFiscalTypesData[${item_index}] = row;
	</#list>
	
	<#assign roleTypes = delegator.findList("RoleType", null, null, null, null, false) />
	var roleTypesData =  new Array();
	<#list roleTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)>
		row['roleTypeId'] = "${item.roleTypeId?if_exists}";
		row['description'] = "${description}";
		roleTypesData[${item_index}] = row;
	</#list>
	
	<#assign fixedAssets = delegator.findList("FixedAsset", null, null, null, null, false) />
	var fixedAssetsData =  new Array();
	<#list fixedAssets as item>
		var row = {};
		row['fixedAssetId'] = "${item.fixedAssetId?if_exists}";
		row['fixedAssetId'] = "${item.fixedAssetId?if_exists}";
		fixedAssetsData[${item_index}] = row;
	</#list>
	
	<#assign glAccountOACs = delegator.findList("GlAccountOrganizationAndClass", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("organizationPartyId", "company"), null, null, null, false) />
	var glAccountOACsData =  new Array();
	<#list glAccountOACs as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.accountCode?if_exists + "-" + item.accountName?if_exists + "[" + item.glAccountId?if_exists +"]")>
		row['glAccountId'] = "${item.fixedAssetId?if_exists}";
		row['description'] = "${description?if_exists}";
		glAccountOACsData[${item_index}] = row;
	</#list>
	
	<#assign glJournals = delegator.findList("GlJournal", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("organizationPartyId", "company"), null, null, null, false) />
	var glJournalsData =  new Array();
	<#list glJournals as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.glJournalName?if_exists + "[" + item.glJournalId?if_exists +"]")>
		row['glJournalId'] = "${item.glJournalId?if_exists}";
		row['description'] = "${description?if_exists}";
		glJournalsData[${item_index}] = row;
	</#list>
	
	<#assign statusItems = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "ACCTG_ENREC_STATUS"), null, null, null, false) />
	var statusItemsData =  new Array();
	<#list statusItems as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['statusId'] = "${item.statusId?if_exists}";
		row['description'] = "${description?if_exists}";
		statusItemsData[${item_index}] = row;
	</#list>
	
	var isPostedData = new Array();
	var row1 = {};
	row1['isPosted'] = 'Y';
	row1['description'] = 'Yes';
	isPostedData[0] = row1;
	var row2 = {};
	row2['isPosted'] = 'N';
	row2['description'] = 'No';
	isPostedData[1] = row2;
</script>
<@jqGridMinimumLib />
	<div class="widget-box transparent no-bottom-border">
		<div class="widget-header">
			<h4>${uiLabelMap.PageTitleEditTransaction}</h4>
		</div>
	</div>
	<form action="<@ofbizUrl>updateAcctgTrans</@ofbizUrl>" method="post" id="updateAcctgTrans">
		<table>
			<tr>
				<td align="right">
					<span>${uiLabelMap.acctgTransId}</span>
				</td>
				<td align="left">
					<span>
						<div id="acctgTransId"></div>
						<input id="acctgTransIdInput" name="acctgTransId" type="hidden"/>
					</span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.acctgTransTypeId}</span>
				</td>
				<td align="left">
			       <span><div id="acctgTransTypeId" name="acctgTransTypeId"></div></span>
			    </td>
			    
			    <td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.glFiscalTypeId}</span>
				</td>
				<td align="left">
					<span><div id="glFiscalTypeId" name="glFiscalTypeId" ></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.glJournalId}</span>
				</td>
				<td align="left">
			       <span><div id="glJournalId" name="glJournalId"/></span>
			    </td>
			    
			    <td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.groupStatusId}</span>
				</td>
				<td align="left">
					<span><div id="groupStatusId" name="groupStatusId"/></span>
				</td>
			</tr>
			<tr>
				<td align="right" >
					<span>${uiLabelMap.partyId}</span>
				</td>
				<td align="left">
					<span><div id="partyId" name="partyId">
						<div id="jqxGridPartyId" />
					</div>
					</span>
			    </td>
			    <td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.roleTypeId}</span>
				</td>
				<td align="left">
					<span><div id="roleTypeId" name="roleTypeId"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.transactionDate}</span>
				</td>
				<td align="left">
					<span><div id="transactionDate" name="transactionDate"></div></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.scheduledPostingDate}</span>
				</td>
				<td align="left">
					<span><div id="scheduledPostingDate" name="scheduledPostingDate"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.isPosted}</span>
				</td>
				<td align="left">
					<span><div id="isPosted" name="isPosted"></div></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.postedDate}</span>
				</td>
				<td align="left">
					<span><div id="postedDate" name="postedDate"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.inventoryItemId}</span>
				</td>
				<td align="left">
					<span><input id="inventoryItemId" name="inventoryItemId"></input></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.physicalInventoryId}</span>
				</td>
				<td align="left">
					<span><input id="physicalInventoryId" name="physicalInventoryId"></input></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.receiptId}</span>
				</td>
				<td align="left">
					<span><input id="receiptId" name="receiptId"></input></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.theirAcctgTransId}</span>
				</td>
				<td align="left">
					<span><input id="theirAcctgTransId" name="theirAcctgTransId"></input></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.voucherRef}</span>
				</td>
				<td align="left">
					<span><input id="voucherRef" name="voucherRef" ></input></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.voucherDate}</span>
				</td>
				<td align="left">
					<span><div id="voucherDate" name="voucherDate"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.invoiceId}</span>
				</td>
				<td align="left">
			       <div id="invoiceId" name="invoiceId" >
			       		<span><div id="jqxGridInvoice"/></span>
			       </div>
			    </td>
			    <td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.paymentId}</span>
				</td>
				<td align="left">
					<span>
						<div id="paymentId" name="paymentId">
		       				<div id="jqxGridPay"/>
		       			</div>
		       		</span>
		       	</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.productId}</span>
				</td>
				<td align="left">
			       <span>
			       		<div id="productId" name="productId">
			       			<div id="jqxGridProd"/>
			       		</div>
			       </span>
			    </td>
			    <td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.workEffortId}</span>
				</td>
				<td align="left">
					<span>
						<div id="workEffortId" name="workEffortId">
		       				<div id="jqxGridWE"/>
		       			</div>
		       		</span>
		       	</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.shipmentId}</span>
				</td>
				<td align="left">
			       <span>
			       		<div id="shipmentId" name="shipmentId">
			       			<div id="jqxGridShip" />
			       		</div>
			       </span>
			    </td>
			    <td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.fixedAssetId}</span>
				</td>
				<td align="left">
					<span><div id="fixedAssetId" name="fixedAssetId"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.lastModifiedDate}</span>
				</td>
				<td align="left">
					<span><div id="lastModifiedDate" name="lastModifiedDate"></div></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.createdDate}</span>
				</td>
				<td align="left">
					<span><div id="createdDate" name="createdDate"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.description}</span>
				</td>
				<td align="left">
					<span><input id="description" name="description"></input></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.finAccountTransId}</span>
				</td>
				<td align="left">
					<span><input id="finAccountTransId" name="finAccountTransId">
					</input>
					</span>
				</td>
			</tr>
			<tr>
		        <td align="right"></td>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
		</table>
	<form>
</div>		
<script type="text/javascript">
	
	//Set acctgTransTypeId
	<#assign acctgTransTypeId = acctgTrans.acctgTransTypeId?if_exists />
	var acctgTransTypeIdIndex = 0;
	for(i = 0; i < acctgTransTypesData.length; i++){
		if(acctgTransTypesData[i].acctgTransTypeId == '${acctgTransTypeId}'){
			acctgTransTypeIdIndex = i;
			break;
		}
	}
	
	//Set glFiscalTypeId
	<#assign glFiscalTypeId = acctgTrans.glFiscalTypeId?if_exists />
	var glFiscalTypeIdIndex = 0;
	for(i = 0; i < glFiscalTypesData.length; i++){
		if(glFiscalTypesData[i].glFiscalTypeId == '${glFiscalTypeId}'){
			glFiscalTypeIdIndex = i;
			break;
		}
	}
	
	//Set glJournalId
	<#assign glJournalId = acctgTrans.glJournalId?if_exists />
	var glJournalIdIndex = 0;
	for(i = 0; i < glJournalsData.length; i++){
		if(glJournalsData[i].glJournalId == '${glJournalId}'){
			glJournalIdIndex = i;
			break;
		}
	}
	
	//Set groupStatusId
	<#assign groupStatusId = acctgTrans.groupStatusId?if_exists />
	var groupStatusIdIndex = 0;
	for(i = 0; i < statusItemsData.length; i++){
		if(statusItemsData[i].groupStatusId == '${groupStatusId}'){
			groupStatusIdIndex = i;
			break;
		}
	}
	
	//Set roleTypeId
	<#assign roleTypeId = acctgTrans.roleTypeId?if_exists />
	var roleTypeIdIndex = 0;
	for(i = 0; i < roleTypesData.length; i++){
		if(roleTypesData[i].roleTypeId == '${roleTypeId}'){
			roleTypeIdIndex = i;
			break;
		}
	}
	
	//Set transactionDate
	<#assign transactionDate = acctgTrans.transactionDate?if_exists />
	var transactionDate = new Date();
	if('${transactionDate}' != null && '${transactionDate}' != ''){
		transactionDate = new Date('${transactionDate}');
	}
	//Set scheduledPostingDate
	<#assign scheduledPostingDate = acctgTrans.scheduledPostingDate?if_exists />
	var scheduledPostingDate = new Date();
	if('${scheduledPostingDate}' != null && '${scheduledPostingDate}' != ''){
		scheduledPostingDate = new Date('${scheduledPostingDate}');
	}
	
	//Set isPosted
	<#assign isPosted = acctgTrans.isPosted?if_exists />
	var isPostedIndex = 0;
	for(i = 0; i < isPostedData.length; i++){
		if(isPostedData[i].isPosted == '${isPosted}'){
			isPostedIndex = i;
			break;
		}
	}
	
	//Set postedDate
	<#assign postedDate = acctgTrans.postedDate?if_exists />
	var postedDate = new Date();
	if('${postedDate}' != null && '${postedDate}' != ''){
		postedDate = new Date('${postedDate}');
	}
	
	//Set inventoryItemId
	<#assign inventoryItemId = acctgTrans.inventoryItemId?if_exists />
	var inventoryItemId = '${inventoryItemId}';
	
	//Set inventoryItemId
	<#assign physicalInventoryId = acctgTrans.physicalInventoryId?if_exists />
	var physicalInventoryId = '${physicalInventoryId}';
	
	//Set receiptId
	<#assign receiptId = acctgTrans.receiptId?if_exists />
	var receiptId = '${receiptId}';
	
	//Set theirAcctgTransId
	<#assign theirAcctgTransId = acctgTrans.theirAcctgTransId?if_exists />
	var theirAcctgTransId = '${theirAcctgTransId}';
	
	//Set voucherRef
	<#assign voucherRef = acctgTrans.voucherRef?if_exists />
	var voucherRef = '${voucherRef}';
	
	//Set voucherDate
	<#assign voucherDate = acctgTrans.voucherDate?if_exists />
	var voucherDate = new Date();
	if('${voucherDate}' != null && '${voucherDate}' != ''){
		voucherDate = new Date('${voucherDate}');
	}
	
	//Set description
	<#assign description = acctgTrans.description?if_exists />
	var description = '${description}';
	
	//Set description
	<#assign finAccountTransId = acctgTrans.finAccountTransId?if_exists />
	var finAccountTransId = '${finAccountTransId}';
	
	//Set isPosted
	<#assign fixedAssetId = acctgTrans.fixedAssetId?if_exists />
	var fixedAssetIdIndex = 0;
	for(i = 0; i < fixedAssetsData.length; i++){
		if(fixedAssetsData[i].isPosted == '${fixedAssetId}'){
			fixedAssetIdIndex = i;
			break;
		}
	}
	
	//Set createdDate
	<#assign createdDate = acctgTrans.createdDate?if_exists />
	var createdDate = new Date();
	if('${createdDate}' != null && '${createdDate}' != ''){
		createdDate = new Date('${createdDate}');
	}
	
	//Set lastModifiedDate
	<#assign lastModifiedDate = acctgTrans.lastModifiedDate?if_exists />
	var lastModifiedDate = new Date();
	if('${lastModifiedDate}' != null && '${lastModifiedDate}' != ''){
		lastModifiedDate = new Date('${lastModifiedDate}');
	}
	
	//Set acctgTransId
	<#assign acctgTransId = acctgTrans.acctgTransId?if_exists />
	
	$('#acctgTransId').text('${acctgTransId}');
	
	$('#acctgTransIdInput').val('${acctgTransId}');
	
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;  
	var outFilterCondition = "";
	$("#alterSave").jqxButton({width:100, height: 25, theme: theme});
	$("#alterCancel").jqxButton({width:100, height: 25,theme: theme});
	$("#acctgTransTypeId").jqxDropDownList({ theme: theme, source: acctgTransTypesData, displayMember: "description", valueMember: "acctgTransTypeId", selectedIndex: acctgTransTypeIdIndex, width: '200', height: '25'});
	$("#glFiscalTypeId").jqxDropDownList({ theme: theme, source: glFiscalTypesData, displayMember: "description", valueMember: "glFiscalTypeId", selectedIndex: glFiscalTypeIdIndex, width: '200', height: '25'});
	$("#glJournalId").jqxDropDownList({ theme: theme, source: glJournalsData, displayMember: "description", valueMember: "glJournalId", selectedIndex: glJournalIdIndex, width: '200', height: '25'});
	$("#groupStatusId").jqxDropDownList({ theme: theme, source: statusItemsData, displayMember: "description", valueMember: "statusId", selectedIndex: groupStatusIdIndex, width: '200', height: '25'});
	$("#finAccountTransId").jqxInput({width:200, height: 25});
	$("#roleTypeId").jqxDropDownList({ theme: theme, source: roleTypesData, displayMember: "description", valueMember: "roleTypeId", selectedIndex: roleTypeIdIndex, width: '200', height: '25'});
	$('#inventoryItemId').jqxInput({width:200, height: 25}).jqxInput('val', inventoryItemId);
	$('#physicalInventoryId').jqxInput({width:200, height: 25}).jqxInput('val', physicalInventoryId);
	$('#receiptId').jqxInput({width:200, height: 25}).jqxInput('val', receiptId);
	$('#theirAcctgTransId').jqxInput({width:200, height: 25}).jqxInput('val', theirAcctgTransId);
	$('#voucherRef').jqxInput({width:200, height: 25}).jqxInput('val', voucherRef);
	$("#voucherDate").jqxDateTimeInput({value: voucherDate, width: '200px', height: '25px', formatString: 'yyyy-MM-dd hh:mm:ss'});
	$("#isPosted").jqxDropDownList({ theme: theme, source: isPostedData, displayMember: "description", valueMember: "isPosted", selectedIndex: isPostedIndex, width: '200', height: '25'});
	$("#postedDate").jqxDateTimeInput({value: postedDate, width: '200px', height: '25px', formatString: 'yyyy-MM-dd hh:mm:ss'});
	$("#lastModifiedDate").jqxDateTimeInput({value: lastModifiedDate, width: '200px', height: '25px', formatString: 'yyyy-MM-dd hh:mm:ss'});
	$("#createdDate").jqxDateTimeInput({value:createdDate ,width: '200px', height: '25px', formatString: 'yyyy-MM-dd hh:mm:ss'});
	$("#fixedAssetId").jqxDropDownList({ theme: theme, source: fixedAssetsData, displayMember: "fixedAssetId", valueMember: "fixedAssetId", selectedIndex: fixedAssetIdIndex, width: '200', height: '25'});
	$("#transactionDate").jqxDateTimeInput({value: transactionDate, width: '200px', height: '25px', formatString: 'yyyy-MM-dd hh:mm:ss'});
	$("#scheduledPostingDate").jqxDateTimeInput({value: scheduledPostingDate, width: '200px', height: '25px', formatString: 'yyyy-MM-dd hh:mm:ss'});
	$('#description').jqxInput({width: 200, height: 25}).jqxInput('val', description);
	$('#finAccountTransId').jqxInput({width: 200, height: 25}).jqxInput('val', finAccountTransId);
	
	// Party Grid
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
				$("#jqxGridPartyId").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxGridPartyId").jqxGrid('updatebounddata');
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
	var dataAdapterP = new $.jqx.dataAdapter(sourceP);
	$("#partyId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxGridPartyId").jqxGrid({
		source: dataAdapterP,
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
      { text: '${uiLabelMap.partyId}', datafield: 'partyId'},
      { text: '${uiLabelMap.partyTypeId}', datafield: 'partyTypeId'},
      { text: '${uiLabelMap.firstName}', datafield: 'firstName'},
      { text: '${uiLabelMap.lastName}', datafield: 'lastName'},
      { text: '${uiLabelMap.groupName}', datafield: 'groupName'}
    ]
	});
	$("#jqxGridPartyId").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxGridPartyId").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['partyId'] +'</div>' + '<input type=\"hidden\" id=\"partyId\" name=\"partyId\" value=\"' + row['partyId'] +'\" /> ';
		$('#partyId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	<#assign partyId = acctgTrans.partyId?if_exists />
	var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">' + '${partyId}' +'</div>' + '<input type=\"hidden\" id=\"partyId\" name=\"partyId\" value=\"' + '${partyId}' +'\" /> ';
	$('#partyId').jqxDropDownButton('setContent', dropDownContent);
	//Invoice Grid
	var sourceINV =
		{	
			datafields:
				[
				 { name: 'invoiceId', type: 'string' },
				 { name: 'invoiceTypeId', type: 'string' },
				 { name: 'partyIdFrom', type: 'string' },
				 { name: 'partyId', type: 'string' },
				 { name: 'statusId', type: 'string' },
				 { name: 'description', type: 'string'}
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceINV.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxGridInvoice").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxGridInvoice").jqxGrid('updatebounddata');
			},
			sortcolumn: 'invoiceId',
			sortdirection: 'asc',
			type: 'POST',
			data: {
				noConditionFind: 'Y',
				conditionsFind: 'N',
			},
			pagesize:5,
			contentType: 'application/x-www-form-urlencoded',
			url: 'jqxGeneralServicer?sname=getListInvoice',
		};
	var dataAdapterINV = new $.jqx.dataAdapter(sourceINV);
	$("#invoiceId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxGridInvoice").jqxGrid({
		source: dataAdapterINV,
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
		          { text: '${uiLabelMap.invoiceId}', datafield: 'invoiceId' },
				  { text: '${uiLabelMap.invoiceTypeId}', datafield: 'invoiceTypeId' },
				  { text: '${uiLabelMap.partyIdFrom}', datafield: 'partyIdFrom' },
				  { text: '${uiLabelMap.partyId}', datafield: 'partyId' },
				  { text: '${uiLabelMap.statusId}', datafield: 'statusId' },
				  { text: '${uiLabelMap.description}', datafield: 'description'}
		         ]
			});
	$("#jqxGridInvoice").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxGridInvoice").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['invoiceId'] +'</div>' + '<input type=\"hidden\" id=\"invoiceId\" name=\"invoiceId\" value=\"' + row['invoiceId'] +'\" /> ';
		$('#invoiceId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	<#assign invoiceId = acctgTrans.invoiceId?if_exists />
	var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">' + '${invoiceId}' +'</div>' + '<input type=\"hidden\" id=\"invoiceId\" name=\"invoiceId\" value=\"' + '${invoiceId}' +'\" /> ';
	$('#invoiceId').jqxDropDownButton('setContent', dropDownContent);
	
	//Payment Grid
	var sourcePay =
		{	
			datafields:
				[
				 { name: 'paymentId', type: 'string' },
				 { name: 'partyIdFrom', type: 'string' },
				 { name: 'partyIdTo', type: 'string' },
				 { name: 'effectiveDate', type: 'string' },
				 { name: 'amount', type: 'string' },
				 { name: 'currencyUomId', type: 'string'}
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceINV.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxGridPay").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxGridPay").jqxGrid('updatebounddata');
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
	var dataAdapterPay = new $.jqx.dataAdapter(sourcePay);
	$("#paymentId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxGridPay").jqxGrid({
		source: dataAdapterPay,
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
		          { text: '${uiLabelMap.paymentId}', datafield: 'paymentId' },
				  { text: '${uiLabelMap.partyIdFrom}', datafield: 'partyIdFrom' },
				  { text: '${uiLabelMap.partyIdTo}', datafield: 'partyIdTo' },
				  { text: '${uiLabelMap.effectiveDate}', datafield: 'effectiveDate' },
				  { text: '${uiLabelMap.amount}', datafield: 'amount' },
				  { text: '${uiLabelMap.currencyUomId}', datafield: 'currencyUomId'}
		         ]
			});
	$("#jqxGridPay").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxGridPay").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">' + row['paymentId'] + '</div>' + '<input type=\"hidden\" id=\"paymentId\" name=\"paymentId\" value=\"' + row['paymentId'] +'\" /> ';
		$('#paymentId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	<#assign paymentId = acctgTrans.paymentId?if_exists />
	var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ '${paymentId}' +'</div>'+ '<input type=\"hidden\" id=\"paymentId\" name=\"paymentId\" value=\"' + '${paymentId}' +'\" /> ';
	$('#paymentId').jqxDropDownButton('setContent', dropDownContent);
	
	//Product Grid
	var sourceProd =
		{	
			datafields:
				[
				 { name: 'productId', type: 'string' },
				 { name: 'brandName', type: 'string' },
				 { name: 'internalName', type: 'string' },
				 { name: 'productTypeId', type: 'string' }
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceProd.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxGridProd").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxGridProd").jqxGrid('updatebounddata');
			},
			sortcolumn: 'productId',
			sortdirection: 'asc',
			type: 'POST',
			data: {
				noConditionFind: 'Y',
				conditionsFind: 'N',
			},
			pagesize:5,
			contentType: 'application/x-www-form-urlencoded',
			url: 'jqxGeneralServicer?sname=getListProduct',
		};
	var dataAdapterProd = new $.jqx.dataAdapter(sourceProd);
	$("#productId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxGridProd").jqxGrid({
		source: dataAdapterProd,
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
		          { text: '${uiLabelMap.productId}', datafield: 'productId' },
				  { text: '${uiLabelMap.brandName}', datafield: 'brandName' },
				  { text: '${uiLabelMap.internalName}', datafield: 'internalName' },
				  { text: '${uiLabelMap.productTypeId}', datafield: 'productTypeId' }
		         ]
			});
	$("#jqxGridProd").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxGridProd").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['productId'] +'</div>' + '<input type=\"hidden\" id=\"productId\" name=\"productId\" value=\"' + row['productId'] +'\" /> ';
		$('#productId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	<#assign productId = acctgTrans.productId?if_exists />
	var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ '${productId}' +'</div>'+ '<input type=\"hidden\" id=\"productId\" name=\"productId\" value=\"' + '${productId}' +'\" /> ';
	$('#productId').jqxDropDownButton('setContent', dropDownContent);
	
	//WorkEffort Grid
	var sourceWE =
		{	
			datafields:
				[
				 { name: 'workEffortId', type: 'string' },
				 { name: 'workEffortName', type: 'string' },
				 { name: 'workEffortTypeId', type: 'string' },
				 { name: 'contactMechTypeId', type: 'string' }
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceWE.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxGridWE").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxGridWE").jqxGrid('updatebounddata');
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
			url: 'jqxGeneralServicer?sname=getListWorkEffort',
		};
	var dataAdapterWE = new $.jqx.dataAdapter(sourceWE);
	$("#workEffortId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxGridWE").jqxGrid({
		source: dataAdapterWE,
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
		          { text: '${uiLabelMap.workEffortId}', datafield: 'workEffortId' },
				  { text: '${uiLabelMap.workEffortName}', datafield: 'workEffortName' },
				  { text: '${uiLabelMap.workEffortTypeId}', datafield: 'workEffortTypeId' },
				  { text: '${uiLabelMap.contactMechTypeId}', datafield: 'contactMechTypeId' }
		         ]
			});
	$("#jqxGridWE").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxGridWE").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['workEffortId'] +'</div>'+ '<input type=\"hidden\" id=\"workEffortId\" name=\"workEffortId\" value=\"' + row['workEffortId'] +'\" /> ';
		$('#workEffortId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	<#assign workEffortId = acctgTrans.workEffortId?if_exists />
	var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ '${workEffortId}' +'</div>'+ '<input type=\"hidden\" id=\"workEffortId\" name=\"workEffortId\" value=\"' + '${workEffortId}' +'\" /> ';
	$('#workEffortId').jqxDropDownButton('setContent', dropDownContent);
	
	//Shipment Grid
	var sourceShip =
		{	
			datafields:
				[
				 { name: 'shipmentId', type: 'string' },
				 { name: 'shipmentTypeId', type: 'string' },
				 { name: 'statusId', type: 'string' },
				 { name: 'partyIdFrom', type: 'string' },
				 { name: 'partyIdTo', type: 'string' }
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceShip.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxGridShip").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxGridShip").jqxGrid('updatebounddata');
			},
			sortcolumn: 'shipmentId',
			sortdirection: 'asc',
			type: 'POST',
			data: {
				noConditionFind: 'Y',
				conditionsFind: 'N',
			},
			pagesize:5,
			contentType: 'application/x-www-form-urlencoded',
			url: 'jqxGeneralServicer?sname=getListShipment',
		};
	var dataAdapterShip = new $.jqx.dataAdapter(sourceShip);
	$("#shipmentId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxGridShip").jqxGrid({
		source: dataAdapterShip,
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
		          { text: '${uiLabelMap.shipmentId}', datafield: 'shipmentId' },
				  { text: '${uiLabelMap.shipmentTypeId}', datafield: 'shipmentTypeId' },
				  { text: '${uiLabelMap.statusId}', datafield: 'statusId' },
				  { text: '${uiLabelMap.partyIdFrom}', datafield: 'partyIdFrom' },
				  { text: '${uiLabelMap.partyIdTo}', datafield: 'partyIdTo' }
		         ]
			});
	$("#jqxGridShip").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxGridShip").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['shipmentId'] +'</div>' + '<input type=\"hidden\" id=\"shipmentId\" name=\"shipmentId\" value=\"' + row['shipmentId'] +'\" /> ';
		$('#shipmentId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	<#assign shipmentId = acctgTrans.shipmentId?if_exists />
	var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ '${shipmentId}' +'</div>'+ '<input type=\"hidden\" id=\"shipmentId\" name=\"shipmentId\" value=\"' + '${shipmentId}' +'\" /> ';
	$('#shipmentId').jqxDropDownButton('setContent', dropDownContent);
	
	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		$('#updateAcctgTrans').submit();
	}); 
</script>
<style type="text/css">
	td span{
		margin-bottom: 10px;
		display: block;
		padding-right: 15px;
	}
</style>