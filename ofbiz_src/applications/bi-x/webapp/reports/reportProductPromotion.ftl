<#assign dataField="[   {name: 'productPromoId', type: 'string'},
						{name: 'promoName', type: 'string'}, 
						{name: 'productPromoTypeId', type: 'string'}, 
						{name: 'promoBugetDistributor', type: 'string'},
						{name: 'revenueMiniId', type: 'string'},
						{name: 'promoSalesTargets', type:'string'},
						{name:'fromDateValue', type:'date'},
						{name:'thruDateValue', type:'date'}
						]"/>


<#assign columnlist="   {text:'${StringUtil.wrapString(uiLabelMap.DelysPromoProductPromoId)}',dataField:'productPromoId',width: '100px', cellsalign: 'center',cellsrenderer: function(row, colum, value) {
	                        	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	                        	return \"<span><a href='/delys/control/viewReportproductPromo?productPromoId=\" + data.productPromoId + \"'>\" + data.productPromoId + \"</a></span>\";
	                        }},
                        {text: '${StringUtil.wrapString(uiLabelMap.DelysPromoPromotionName)}', dataField: 'promoName'},
                        {text: '${StringUtil.wrapString(uiLabelMap.DelysPromotionType)}', dataField: 'productPromoTypeId', width: '180px',cellsalign: 'left'},
                        {text: '${StringUtil.wrapString(uiLabelMap.DelysBudgetTotal)}', dataField: 'promoBugetDistributor', width: '100px', cellsalign: 'center',cellsrenderer: function(row, column, value) {
					 		var data = $(\"#jqxgrid\").jqxGrid(\"getrowdata\", row);
					 		var str = \"<div style='text-align:right; width:95%; margin-left:0!important'>\";
							str += formatcurrency(value,data.currencyUom);
							str += \"</div>\";
							return str;
					 	},filterable:false},
                        {text: '${StringUtil.wrapString(uiLabelMap.DelysMiniRevenue)}', dataField: 'revenueMiniId', width: '100px', cellsalign: 'center',cellsrenderer: function(row, column, value) {
					 		var data = $(\"#jqxgrid\").jqxGrid(\"getrowdata\", row);
					 		var str = \"<div style='text-align:right; width:95%; margin-left:0!important'>\";
							str += formatcurrency(value,data.currencyUom);
							str += \"</div>\";
							return str;
					 	},filterable:false},
                        {text:'${StringUtil.wrapString(uiLabelMap.OlapSalesTargets)}', dataField: 'promoSalesTargets', width: '100px', cellsalign: 'center',cellsrenderer: function(row, column, value) {
					 		var data = $(\"#jqxgrid\").jqxGrid(\"getrowdata\", row);
					 		var str = \"<div style='text-align:right; width:95%; margin-left:0!important'>\";
							str += formatcurrency(value,data.currencyUom);
							str += \"</div>\";
							return str;
					 	},filterable:false},
                        {text:'${StringUtil.wrapString(uiLabelMap.CommonFromDate)}', dataField: 'fromDateValue', width: '100px', cellsalign: 'center',cellsformat: 'dd/MM/yyyy',filterable:false},
                        {text:'${StringUtil.wrapString(uiLabelMap.CommonThruDate)}', dataField: 'thruDateValue', width: '100px', cellsalign: 'center',cellsformat: 'dd/MM/yyyy',filterable:false}
                        "
/>

<@jqGrid filtersimplemode="true" filterable="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" selectionmode="multiplerowsextended"
    showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" addrefresh="true" editrefresh="true"
    url="jqxGeneralServicer?sname=jqxPromotionReport"
/>