 <#assign dataField="[{name: 'invoiceItemSeqId', type: 'string' },
	                 {name: 'invoiceItemTypeName', type: 'string'},
	                 { name: 'inventoryItemId', type: 'string' },
	                 { name: 'productId', type: 'string' },
	                 { name: 'uomId', type: 'string' },
	                 { name: 'quantity', type: 'number' },
			 		 { name: 'amount', type: 'number' },
					 { name: 'description', type: 'string' },
					 { name: 'overrideGlAccountId', type: 'string' },
	   				 { name: 'orderId', type: 'string' }, 
	   				 { name: 'total', type: 'number'}]"/>
 <#assign columnlist="{ text: '${uiLabelMap.invoiceItemSeqId}', dataField: 'invoiceItemSeqId', width: 80 },
                     { text: '${uiLabelMap.invoiceItemTypeName}', dataField: 'invoiceItemTypeName', width: 150 },
                     { text: '${uiLabelMap.DAInventoryItemId}', dataField: 'inventoryItemId', width: 150 },
                     { text: '${uiLabelMap.AccountingProduct}', dataField: 'productId', width: 200, cellsrenderer:
	                 	function(row, colum, value)
	                    {
                    		return \"<span><a href='/catalog/control/EditProduct?productId=\" + value + \"'>\" + value + \"</span>\";
	                    }},
	                 { text: '${uiLabelMap.accOverrideGlAccountId}', dataField: 'overrideGlAccountId', width: 200, cellsrenderer:
	                 	function(row, colum, value)
	                    {
                    		return \"<span><a href='accApGlAccountNavigate?glAccountId=\" + value + \"'>\" + value + \"</span>\";
	                    }},
                     { text: '${uiLabelMap.uomId}', dataField: 'uomId', width: 100 },
		    		 { text: '${uiLabelMap.quantity}', dataField: 'quantity', cellsformat: 'D',  width: 150, cellsrenderer:
 	                 	function(row, colum, value)
	                    {
	                    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	                    	if(data.quantity == null){
	                    		return \"<span>\" + 1 + \"</span>\";
                    		}
                    		return \"<span>\" + data.quantity + \"</span>\";
	                    }},                    	                     	 
		    		 { text: '${uiLabelMap.unitPrice}', dataField: 'amount', width: 150,
	                    	cellsrenderer:
	     					 	function(row, colum, value){
	     					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);					 		
	     					 		return \"<span>\" + formatcurrency(data.amount,data.uomId) + \"</span>\";						 		
	     					 	}},	
		   		     { text: '${uiLabelMap.description}', dataField: 'description', width: 300 },
		    		 { text: '${uiLabelMap.DAOrderId}', dataField: 'orderId', width: 150, cellsrenderer:
	                 	function(row, colum, value)
	                    {
                    		return \"<span><a href='/ordermgr/control/orderview?orderId=\" + value + \"'>\" + value + \"</span>\";
	                    }},
                     { text: '${uiLabelMap.ApTotal}', dataField: 'total', width: 200, cellsrenderer:
	                 	function(row, colum, value)
	                    {
	                    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	                    	if(data.quantity != null && data.amount!=null){
	                    		return \"<span>\" + formatcurrency(parseFloat(data.quantity)*parseFloat(data.amount),data.uomId) + \"</span>\";	
	                    		
                    		}else{
                    			return null;
                    		}
	                    }}  
                     "/>
                     
<@jqGrid url="jqxGeneralServicer?invoiceId=${parameters.invoiceId}&sname=JQListAPInvItemAndOrdItem" dataField=dataField columnlist=columnlist filterable="true" filtersimplemode="false"
		 id="jqxgrid" customTitleProperties="${uiLabelMap.AccountingInvoiceItems}"/>

