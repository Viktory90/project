
<#assign dataField="[{ name: 'organizationPartyId', type: 'string' },
					{ name: 'organizationPartyName', type: 'string' },

						 { name: 'glAccountId', type: 'string' },"/>
<#assign listCategoryId = "" />						 
<#list glAccountCategories as glAccCategory>
	<#assign listCategoryId = listCategoryId + " " +  glAccCategory.glAccountCategoryId  !/>
    <#assign dataField= dataField + "{ name: '${glAccCategory.glAccountCategoryId}', type: 'string' },"/>
 </#list>
<#assign dataField= dataField + "{ name: 'accountCode', type: 'string' },
						 { name: 'accountName', type: 'string' }]" />

<#assign columnlist="{ text: '${uiLabelMap.OrganizationParty}', datafield: 'organizationPartyName', width: 150, editable: false, filterable: false, sortable: false},
					 { text: '', datafield: 'glAccountId', width: 150, editable: false, hidden: true},
					 { text: '', datafield: 'organizationPartyId', width: 150, editable: false, hidden: true},
                     { text: '${uiLabelMap.accountCode}', datafield: 'accountCode', width: 150, editable: false}," />
<#assign columnlist= columnlist   + "{ text: '${uiLabelMap.accountName}', datafield: 'accountName', editable: false},"/>                        
  <#list glAccountCategories as glAccCategory>
    <#assign columnlist= columnlist   + "{text: '${glAccCategory.description}', datafield: '${glAccCategory.glAccountCategoryId}', width: 150,filterable: false, sortable: false, cellsrenderer:
	 	function(row, colum, value){
	 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	 		
	 		var amount = data['${glAccCategory.glAccountCategoryId}'];
	 		if(amount){
	 			return amount;
	 		}else{
	 			return 0;
	 		}
	 	}}," />
  </#list>
               					 
<@jqGrid url="jqxGeneralServicer?sname=JQListGlAcctgAndAmountPercentage" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true" editable= "true"
 />
 <script type="text/javascript" src="/delys/images/js/costCenter.js"></script>
 <button id="saveCostCenters" style="float:right; padding-bottom: 5px;"  onclick="saveCostCenters('${listCategoryId}');">${uiLabelMap.Save}</button>
 <script type="text/javascript">
		$("#saveCostCenters").jqxButton({ template: "primary" });
</script>
 