<#assign columnlist="{ text: '${uiLabelMap.paymentId}', dataField: 'paymentId'},
					 { text: '${uiLabelMap.partyIdFrom}', dataField: 'partyIdFrom'},
					 { text: '${uiLabelMap.partyIdTo}', dataField: 'partyIdTo'},
					 { text: '${uiLabelMap.paymentTypeId}', dataField: 'paymentTypeId'},
					 { text: '${uiLabelMap.statusId}', dataField: 'statusId'},
					 { text: '${uiLabelMap.amount}', dataField: 'amount'},
					 { text: '${uiLabelMap.fromDate}', dataField: 'fromDate'},
                     { text: '${uiLabelMap.thruDate}', dataField: 'thruDate'},
                     "/>
<#assign dataField="[{ name: 'paymentId', type: 'string' },
                 	{ name: 'partyIdFrom', type: 'string' },
                 	{ name: 'partyIdTo', type: 'string' },
                 	{ name: 'paymentTypeId', type: 'string' },
                 	{ name: 'statusId', type: 'string' },
                 	{ name: 'amount', type: 'number' },
                 	{ name: 'fromDate', type: 'date' },
                 	{ name: 'thruDate', type: 'date' },
		 		  	]"/>

<div class="widget-box transparent no-bottom-border" style="padding-left: 20px;" >
	<div class="widget-header">
		<h4>${uiLabelMap.AccountingPaymentGroupMembers}</h4>
	</div>
</div>
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showstatusbar="false" showtoolbar="true" addrow="false" filterable="true" editable="false"
		 url="jqxGeneralServicer?sname=JQApListPaymentGroupMember&paymentGroupId=${parameters.paymentGroupId}"
		/>
<style type="text/css">
	#jqxgrid{
		padding-left: 20px;
	}
	.jqx-grid-statusbar-olbius{
		display: none;
	}
</style>