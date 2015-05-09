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
					<span><div id="inventoryItemId" name="inventoryItemId"></div></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.physicalInventoryId}</span>
				</td>
				<td align="left">
					<span><div id="physicalInventoryId" name="physicalInventoryId"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.receiptId}</span>
				</td>
				<td align="left">
					<span><div id="receiptId" name="receiptId"></div></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.theirAcctgTransId}</span>
				</td>
				<td align="left">
					<span><div id="theirAcctgTransId" name="theirAcctgTransId"></div></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span>${uiLabelMap.voucherRef}</span>
				</td>
				<td align="left">
					<span><div id="voucherRef" name="voucherRef" ></div></span>
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
					<span><div id="description" name="description"></div></span>
				</td>
				<td align="right" style="min-width: 200px;">
					<span>${uiLabelMap.finAccountTransId}</span>
				</td>
				<td align="left">
					<span><div id="finAccountTransId" name="finAccountTransId">
					</div>
					</span>
				</td>
			</tr>
		</table>
	<form>
</div>		
<script type="text/javascript">
	
	//Set acctgTransTypeId
	<#assign acctgTransTypeId = acctgTrans.acctgTransTypeId?if_exists />
	$('#acctgTransTypeId').text('${acctgTransTypeId}');
	
	//Set glFiscalTypeId
	<#assign glFiscalTypeId = acctgTrans.glFiscalTypeId?if_exists />
	$('#glFiscalTypeId').text('${glFiscalTypeId}');
	//Set glJournalId
	<#assign glJournalId = acctgTrans.glJournalId?if_exists />
	$('#glJournalId').text('${glJournalId}');
	//Set groupStatusId
	<#assign groupStatusId = acctgTrans.groupStatusId?if_exists />
	$('#groupStatusId').text('${groupStatusId}');
	//Set roleTypeId
	<#assign roleTypeId = acctgTrans.roleTypeId?if_exists />
	$('#roleTypeId').text('${roleTypeId}');
	//Set transactionDate
	<#assign transactionDate = acctgTrans.transactionDate?if_exists />
	$('#transactionDate').text('${transactionDate}');
	//Set scheduledPostingDate
	<#assign scheduledPostingDate = acctgTrans.scheduledPostingDate?if_exists />
	$('#scheduledPostingDate').text('${scheduledPostingDate}');
	//Set isPosted
	<#assign isPosted = acctgTrans.isPosted?if_exists />
	$('#isPosted').text('${isPosted}');
	//Set postedDate
	<#assign postedDate = acctgTrans.postedDate?if_exists />
	$('#postedDate').text('${postedDate}');
	//Set inventoryItemId
	<#assign inventoryItemId = acctgTrans.inventoryItemId?if_exists />
	$('#inventoryItemId').text('${inventoryItemId}');
	
	//Set inventoryItemId
	<#assign physicalInventoryId = acctgTrans.physicalInventoryId?if_exists />
	$('#physicalInventoryId').text('${physicalInventoryId}');
	
	//Set receiptId
	<#assign receiptId = acctgTrans.receiptId?if_exists />
	$('#receiptId').text('${receiptId}');
	
	//Set theirAcctgTransId
	<#assign theirAcctgTransId = acctgTrans.theirAcctgTransId?if_exists />
	$('#theirAcctgTransId').text('${theirAcctgTransId}');
	
	//Set voucherRef
	<#assign voucherRef = acctgTrans.voucherRef?if_exists />
	$('#voucherRef').text('${voucherRef}');
	
	//Set voucherDate
	<#assign voucherDate = acctgTrans.voucherDate?if_exists />
	$('#voucherDate').text('${voucherDate}');
	//Set description
	<#assign description = acctgTrans.description?if_exists />
	$('#description').text('${description}');
	
	//Set description
	<#assign finAccountTransId = acctgTrans.finAccountTransId?if_exists />
	$('#finAccountTransId').text('${finAccountTransId}');
	
	//Set isPosted
	<#assign fixedAssetId = acctgTrans.fixedAssetId?if_exists />
	$('#fixedAssetId').text('${fixedAssetId}');
	
	//Set createdDate
	<#assign createdDate = acctgTrans.createdDate?if_exists />
	$('#createdDate').text('${createdDate}');
	//Set lastModifiedDate
	<#assign lastModifiedDate = acctgTrans.lastModifiedDate?if_exists />
	$('#lastModifiedDate').text('${lastModifiedDate}');
	//Set partyId
	<#assign partyId = acctgTrans.partyId?if_exists />
	$('#partyId').text('${partyId}');
	//Set invoiceId
	<#assign invoiceId = acctgTrans.invoiceId?if_exists />
	$('#invoiceId').text('${invoiceId}');
	//Set paymentId
	<#assign paymentId = acctgTrans.paymentId?if_exists />
	$('#paymentId').text('${paymentId}');
	//Set productId
	<#assign productId = acctgTrans.productId?if_exists />
	$('#productId').text('${productId}');
	//Set workEffortId
	<#assign workEffortId = acctgTrans.workEffortId?if_exists />
	$('#workEffortId').text('${workEffortId}');
	//Set shipmentId
	<#assign shipmentId = acctgTrans.shipmentId?if_exists />
	$('#shipmentId').text('${shipmentId}');
	//Set acctgTransId
	<#assign acctgTransId = acctgTrans.acctgTransId?if_exists />
	$('#acctgTransId').text('${acctgTransId}');
</script>
<style type="text/css">
	td span{
		margin-bottom: 10px;
		display: block;
		padding-right: 15px;
	}
</style>