<#assign columnlist="{ text: '${uiLabelMap.acctgTransId}', dataField: 'acctgTransId', width: 150, cellsrenderer: linkacctgtransrenderer },
                     { text: '${uiLabelMap.acctgTransEntrySeqId}', dataField: 'acctgTransEntrySeqId', width: 200 },
                     { text: '${uiLabelMap.isPosted}', dataField: 'isPosted', width: 150 },
                     { text: '${uiLabelMap.glFiscalTypeId}', dataField: 'glFiscalTypeId', width: 200 },                     
					 { text: '${uiLabelMap.transTypeDescription}', datafield: 'transTypeDescription', width: 200 },                           
		     		 { text: '${uiLabelMap.transactionDate}', dataField: 'transactionDate', filtertype: 'date' , cellsformat: 'dd-MM-yyyy h:mm:ss' ,  width: 170 },
		             { text: '${uiLabelMap.postedDate}', dataField: 'postedDate', filtertype: 'date',  cellsformat: 'dd-MM-yyyy h:mm:ss', width: 170 },	   		     
		             { text: '${uiLabelMap.glJournalName}', dataField: 'glJournalName', width: 250 },
                     { text: '${uiLabelMap.paymentId}', dataField: 'paymentId', width: 150, cellsrenderer : linkpaymentrenderer },
	             { text: '${uiLabelMap.fixedAssetId}', dataField: 'fixedAssetId', width: 150 },
	             { text: '${uiLabelMap.productId}', dataField: 'productId', width: 150 },
	             { text: '${uiLabelMap.debitCreditFlag}', dataField: 'debitCreditFlag', width: 150 },
	             { text: '${uiLabelMap.apAmount}', dataField: 'amount', width: 150, cellsformat: 'c2' },
	             { text: '${uiLabelMap.origAmount}t', dataField: 'origAmount', width: 150, cellsformat: 'c2' },
	             { text: '${uiLabelMap.accountCode}', dataField: 'accountCode', width: 150 },
	             { text: '${uiLabelMap.accountName}', dataField: 'accountName', width: 150 },
	             { text: '${uiLabelMap.apPartyId}', dataField: 'partyId', width: 150, cellsrenderer: linkrenderer },
	             { text: '${uiLabelMap.reconcileStatusName}', dataField: 'reconcileStatusName', width: 150 }
                      "/>
<#assign dataField="{ name: 'acctgTransId', type: 'string' },
                 { name: 'acctgTransEntrySeqId', type: 'string' },
                 { name: 'isPosted', type: 'string' },
                 { name: 'glFiscalTypeId', type: 'string' }, 
                 { name: 'transTypeDescription', type: 'string'},                                             
                 { name: 'transactionDate', type: 'date' },
 		 { name: 'postedDate', type: 'date' },
		 { name: 'glJournalName', type: 'string' },
		 { name: 'paymentId', type: 'string' },
		 { name: 'fixedAssetId', type: 'string' },
		 { name: 'productId', type: 'string' },
		 { name: 'debitCreditFlag', type: 'string' },
		 { name: 'amount', type: 'number' },
		 { name: 'origAmount', type: 'number' },
		 { name: 'accountCode', type: 'string' },
		 { name: 'accountName', type: 'string' },
		 { name: 'partyId', type: 'string' },
		 { name: 'reconcileStatusName', type: 'string' }
		 		 "/>
<@jqGrid url="/delys/control/listJQQuery" defaultSortColumn="acctgTransId;acctgTransEntrySeqId" columnlist=columnlist dataField=dataField  height="400"  currencySymbol="₫" id="jqxgridAtat"
		 entityName="AcctgTransAndEntriesAndLink" primaryColumn="acctgTransId" updateUrl="" createUrl="" conditionsFind ="${conditionsFind}" otherCondition="" updaterow="false" showtoolbar="false" editable="false" deleterow="false" addrow="false" doubleClick="false" noConditionFind="N"
		 addmultiplerows="false" excelExport="false" toPrint="false" filterbutton="false" clearfilteringbutton="false" updatemultiplerows="false" removeUrl="" updateMulUrl="" keyvalue="glAccountId;accountCode;accountName" filtersimplemode="false"
		 dictionaryColumns="acctgTransId;acctgTransEntrySeqId;isPosted;glFiscalTypeId;transTypeDescription;transactionDate;postedDate;glJournalName;paymentId;fixedAssetId;productId;debitCreditFlag;amount;origAmount;accountCode;accountName;partyId;reconcileStatusName" editColumns="" />                	


<#--<@jqTable pageable="true" url="/delys/control/listGlAccountOrganization2" columnlist=columnlist dataField=dataField entityName="GlAccount"/> -->