<script>
	<#assign glAccounts = delegator.findList("GlAccount", null, null, null, null, false) />
	var glAccountData = new Array();
	<#list glAccounts as item>
		<#assign description = StringUtil.wrapString(item.accountCode?if_exists  + " - " + item.accountName?if_exists + "[" + item.glAccountId?if_exists + "]" ) />
		var row = {};
		row['description'] = '${description}';
		row['glAccountId'] = '${item.glAccountId}';
		glAccountData[${item_index}] = row;
	</#list>
	
</script>
<#assign columnlist="{ text: '${uiLabelMap.acctgTransId}', dataField: 'acctgTransId', width: 150,
	 					cellsrenderer: function (row, column, value) {
	 						return '<span><a href=EditAccountingTransaction?&organizationPartyId=${parameters.organizationPartyId}&acctgTransId=' + value +'>' + value + '</a></span>'
	 					}
					 },
					 { text: '${uiLabelMap.acctgTransEntrySeqId}', dataField: 'acctgTransEntrySeqId', width: 150},
					 { text: '${uiLabelMap.glAccountId}', dataField: 'glAccountId', width: 150,
	 					cellsrenderer: function (row, column, value) {
	 						for(i = 0; i < glAccountData.length; i++){
	 							if(glAccountData[i].glAccountId == value){
	 								return '<span><a href=GlAccountNavigate?glAccountId=' + glAccountData[i].glAccountId +'>' + glAccountData[i].description + '</a></span>'
	 							}
	 						}
	 					}
					 },
					 { text: '${uiLabelMap.partyId}', dataField: 'partyId', width: 250,
		 				cellsrenderer: function (row, column, value) {
		 					return '<span><a href=viewprofile?partyId=' + value +'>' + value + '</a></span>'
		 				}
					 },
					 { text: '${uiLabelMap.productId}', dataField: 'productId',width: 150},
					 { text: '${uiLabelMap.organizationPartyId}',dataField: 'organizationPartyId', width: 150,
		 				cellsrenderer: function (row, column, value) {
		 					return '<span><a href=viewprofile?organizationPartyId=' + value +'>' + value + '</a></span>'
		 				}
					 },
					 { text: '${uiLabelMap.amount}', dataField: 'amount', width: 150,
						 cellsrenderer: function(row, column, value){
							 var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							 return '<span>' + formatcurrency(value, data.currencyUomId) + '</span>'
						 }
					 }
					 "/>
<#assign dataField="[{ name: 'acctgTransId', type: 'string' },
                 	{ name: 'acctgTransEntrySeqId', type: 'string' },
                 	{ name: 'glAccountId', type: 'string' },
					{ name: 'partyId', type: 'string' },
					{ name: 'productId', type: 'string' },
                 	{ name: 'organizationPartyId', type: 'string' },
                 	{ name: 'amount', type: 'number' }
		 		 	]"/>	

<@jqGridMinimumLib/>
		 		 	
<div id="jqxPanel">
	<table style="width:80%;margin:0 auto;">
		 <tr>
		 	<td style="text-align: right; padding-right: 10px;">${uiLabelMap.FormFieldTitle_glAccountId}</td>
		 	<td>
		 		<div id="glAccountIdList"></div>
		 	</td>
		 </tr>
		 <tr>
		 	<td colspan="6" align="center">
		 	    <input type="button" value="${uiLabelMap.filter}" id='jqxButton' />
		 	</td>
		 </tr>
	</table>
</div>

<script type="text/javascript">
	//create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;  
	var outFilterCondition = "";
	$('#glAccountIdList').jqxDropDownList({ selectedIndex: 0,  source: glAccountData, displayMember: "description", valueMember: "glAccountId", theme: theme});
	$("#jqxPanel").jqxPanel({ height: 130, theme:theme});
	$("#jqxButton").jqxButton({ width: '150', height: '30', theme:theme});
	$("#jqxButton").on('click', function () {
		 outFilterCondition = "|OLBIUS|glAccountId";
		 outFilterCondition += "|SUIBLO|" + $('#glAccountIdList').val();
		 outFilterCondition += "|SUIBLO|" + "EQUAL";
		 outFilterCondition += "|SUIBLO|" + "or";
		 $('#jqxgrid').jqxGrid('updatebounddata');
	});
</script>

<div id='contextMenu'>
	<ul>
    	<li><i class="icon-ok"></i>${StringUtil.wrapString(uiLabelMap.AccountingCreateAcctRecons)}</li>
    </ul>
</div>
<script type="text/javascript">
$("#contextMenu").jqxMenu({ width: 300, height: 30, autoOpenPopup: false, mode: 'popup', theme: theme});
$("#contextMenu").on('itemclick', function (event) {
	var rowindexes = $("#jqxgrid").jqxGrid('selectedrowindexes');
	var data = {};
	for(i = 0; i < rowindexes.length; i++){
		var row = $("#jqxgrid").jqxGrid('getrowdata', rowindexes[i]);
		var acctgTransId = row.acctgTransId;
		var acctgTransEntrySeqId = row.acctgTransEntrySeqId;
		var amount = row.amount;
		var glAccountId = row.glAccountId;
		var organizationPartyId = row.organizationPartyId;
		var partyId = row.partyId;
		var productId =row.productId;
		data["acctgTransId_o_" + i] = acctgTransId;
		data["acctgTransEntrySeqId_o_" + i] = acctgTransEntrySeqId;
		data["amount_o_" + i] = amount;
		data["glAccountId_o_" + i] = glAccountId;
		data["organizationPartyId_o_" + i] = organizationPartyId;
		data["partyId_o_" + i] = partyId;
		data["productId_o_" + i] = productId;
		data["_rowSubmit_o_" + i] = 'Y';
	}
	var request = $.ajax({
		  url: "<@ofbizUrl>createReconcileAccount</@ofbizUrl>",
		  type: "POST",
		  data: data,
		  dataType: "html"
		});
	request.done(function(data) {
		var dataObj = $.parseJSON(data);
		var replace = "<@ofbizUrl>EditGlReconciliation?glReconciliationId=" + dataObj['glReconciliationId'] +"&organizationPartyId=company</@ofbizUrl>"
		location.replace(replace);
	});
	request.fail(function(){
		alert("${uiLabelMap.createAccountReconciliationFail}");
	});
});
</script>

<@jqGrid filtersimplemode="true" id="jqxgrid" usecurrencyfunction="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" filterable="false" alternativeAddPopup="alterpopupWindow" editable="false" 
		 url="jqxGeneralServicer?sname=JQListGlAccountReconciliation&organizationPartyId=${parameters.organizationPartyId}" autoload="false" mouseRightMenu="true" contextMenuId="contextMenu" selectionmode="checkbox" jqGridMinimumLibEnable="false"	 
	   />