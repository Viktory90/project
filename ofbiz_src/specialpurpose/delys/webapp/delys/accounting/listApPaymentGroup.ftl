<script>
	<#assign payGrTypes = delegator.findList("PaymentGroupType", null, null, null, null, false) />
	var payGrTypeData = new Array();
	<#list payGrTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['paymentGroupTypeId'] = '${item.paymentGroupTypeId}';
		row['description'] = '${description}';
		payGrTypeData[${item_index}] = row;
	</#list>
</script>
<#assign columnlist="{ text: '${uiLabelMap.paymentGroupId}', dataField: 'paymentGroupId', editable: false, width: 150,
					 	cellsrenderer: function(row, column, value){
					 		return '<span><a href=PaymentGroupOverview?paymentGroupId=' + value +'>' + value + '</a></span>'
					 	}
					},
                     { text: '${uiLabelMap.paymentGroupTypeId}', dataField: 'paymentGroupTypeId', editable: false, width: 150, 
                     	cellsrenderer: function(row, column, value){
                     		for(i = 0; i < payGrTypeData.length; i++){
                     			if(payGrTypeData[i].paymentGroupTypeId == value){
                     				return '<span title='+ value + '>' + payGrTypeData[i].description +'</span>'
                     			}
                     		}
                     	}
                     },
                     { text: '${uiLabelMap.paymentGroupName}', dataField: 'paymentGroupName', editable: true, width: 150}
                     "/>
<#assign dataField="[{ name: 'paymentGroupId', type: 'string' },
                 	{ name: 'paymentGroupTypeId', type: 'string' },
                 	{ name: 'paymentGroupName', type: 'string' }
		 		  	]"/>	
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" filterable="true" alternativeAddPopup="alterpopupWindow" editable="true"
		 url="jqxGeneralServicer?sname=JQApListPaymentGroup" createUrl="jqxGeneralServicer?jqaction=C&sname=createPaymentGroup"
		 addColumns="paymentGroupTypeId;paymentGroupName" updateUrl="jqxGeneralServicer?jqaction=U&sname=updatePaymentGroup" editColumns="paymentGroupId;paymentGroupName"
		/>

<div id="alterpopupWindow">
	<div>${uiLabelMap.accCreateNew}</div>
	<div style="overflow: hidden;">
    	<table>
	 		<tr>
	 			<td align="right">${uiLabelMap.paymentGroupTypeId}:</td>
	 			<td align="left"><div id="paymentGroupTypeIdAdd"></div></td>
	 		</tr>
	 		<tr>
	 		<td align="right">${uiLabelMap.paymentGroupName}:</td>
	 			<td align="left"><input id="paymentGroupNameAdd"></input></td>
	 		</tr>
	 		<tr>
	 			<td align="right"></td>
	 			<td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
	 		</tr>
	 	</table>
	 </div>
</div>
<script type="text/javascript">
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;

	$('#paymentGroupTypeIdAdd').jqxDropDownList({ selectedIndex: 0,  source: payGrTypeData, displayMember: "description", valueMember: "paymentGroupTypeId"});
	$('#paymentGroupNameAdd').jqxInput({width: '195px'});
	$("#alterpopupWindow").jqxWindow({
		width: 580, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});

	$("#alterCancel").jqxButton();
	$("#alterSave").jqxButton();

	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		var row;
		row = { 
				paymentGroupTypeId:$('#paymentGroupTypeIdAdd').val(),
				paymentGroupName:$('#paymentGroupNameAdd').val()
    	  	};
	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
    // select the first row and clear the selection.
    $("#jqxgrid").jqxGrid('clearSelection');                        
    $("#jqxgrid").jqxGrid('selectRow', 0);  
    $("#alterpopupWindow").jqxWindow('close');
	});
</script>