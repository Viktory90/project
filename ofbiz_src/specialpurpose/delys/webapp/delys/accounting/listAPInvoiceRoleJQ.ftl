 <#assign columnlist="{ text: '${uiLabelMap.FormFieldTitle_organizationPartyId}', dataField: 'partyId', cellsrenderer:
	                 	function(row, colum, value)
	                    {
                    		return \"<span><a href='/partymgr/control/viewprofile?partyId=\" + value + \"'>\" + value + \"</span>\";
	                    }},
                     { text: '${uiLabelMap.FormFieldTitle_name}', dataField: 'name'},
                     { text: '${uiLabelMap.roleTypeId}', dataField: 'roleTypeId'},
                     { text: '${uiLabelMap.FormFieldTitle_percentage}', dataField: 'percentage'},                     
					 { text: '${uiLabelMap.FormFieldTitle_datetimePerformed}', datafield: 'datetimePerformed', cellsformat: 'dd/MM/yyyy hh:mm:ss'}
                      "/>
<#assign dataField="[{ name: 'partyId', type: 'string' },
                 { name: 'name', type: 'string' },
                 { name: 'roleTypeId', type: 'string' },
                 { name: 'percentage', type: 'string' }, 
                 { name: 'datetimePerformed', type: 'date'}]
		 		 "/>	
<style type="text/css">
	#jqxgrid3 .jqx-grid-header-olbius{
		height:25px !important;
	}	
	#jqxgrid3 .jqx-grid-header-olbius{
		height:25px !important;
	}
	#jqxgrid3{
		width: calc(100% - 2px) !important;
	}
</style>			 		 
<@jqGrid url="jqxGeneralServicer?invoiceId=${parameters.invoiceId}&sname=JQListAPInvoiceRole" dataField=dataField columnlist=columnlist filterable="true" filtersimplemode="false"
		 id="jqxgrid3" customTitleProperties="${uiLabelMap.AccountingInvoiceRoles}"/>