<script>
	var facilityId = '${parameters.facilityId}';
</script>
<div>
	
	<#assign dataField="[
	{ name: 'productId', type: 'string'},
	{ name: 'internalName', type: 'string' },
	{ name: 'quantityOnHandTotal', type: 'string' },
	{ name: 'availableToPromiseTotal', type: 'string' },
	{ name: 'quantityOnOrder', type: 'string' },
	]"/>
	<#assign columnlist="
	{ text: '${uiLabelMap.ProductProductId}', datafield: 'productId', editable: false},
	{ text: '${uiLabelMap.ProductProductName}', datafield: 'internalName', editable: false},
	{ text: '${uiLabelMap.FormFieldTitle_quantityOnHandTotal}', datafield: 'quantityOnHandTotal',editable: false},
	{ text: '${uiLabelMap.FormFieldTitle_availableToPromiseTotal}', datafield: 'availableToPromiseTotal', editable: false},
	{ text: '${uiLabelMap.QuantityOnOrder}', datafield: 'quantityOnOrder', editable: false}
	"/>
	
	<@jqGrid filtersimplemode="true" id="jqxgrid" filterable="true"  dataField=dataField columnlist=columnlist  editable="false" showtoolbar="true" editmode="click" selectionmode="singlecell"
		url="jqxGeneralServicer?sname=JQXgetListInventoryItem&facilityId=${parameters.facilityId}"
	/>
</div>