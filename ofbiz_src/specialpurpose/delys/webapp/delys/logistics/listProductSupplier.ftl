<script>
$(document).ready(function() {
	var mytab = "<li><span class='divider'><i class='icon-angle-right'></i></span>${uiLabelMap.ListSuppliers}</li>";
	$(".breadcrumb").append(mytab);
	
	<#if listSup?exists>
		<#list listSup as item>
			var row = {};
			<#assign groupName = StringUtil.wrapString(item.groupName) />
			row['groupName'] = "${groupName}";
			row['partyId'] = '${item.partyId?if_exists}';
			listSupplier[${item_index}] = row;
		</#list>
	</#if>
	<#if listUom?exists>
		<#list listUom as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description) />
			row['uomId'] = '${item.uomId?if_exists}';
			row['description'] = "${description}";
			listUom[${item_index}] = row;
		</#list>
	</#if>
});
var listSupplier = new Array();
var listUom = new Array();
function getDateTimeStamp(fromDate) {
	if (fromDate != null) {
		fromDate =  new Date(fromDate);
		var date = fromDate.getDate();
		if (date < 10) {
			date = "0" + date;
		}
        var month = fromDate.getMonth() + 1;
        if (month < 10) {
        	month = "0" + month;
		}
        var year = fromDate.getFullYear();
        var fullYear = date + '/' + month + '/' + year;
        return fullYear;
	} else {
		 return "";
	}
}
</script>

<#assign dataField="[{ name: 'productId', type: 'string'},
			{ name: 'partyId', type: 'string'},
			{ name: 'supplierProductId', type: 'string'},
			{ name: 'supplierProductName', type: 'string'},
			{ name: 'availableFromDate', type: 'date', other: 'Timestamp'},
			{ name: 'availableThruDate', type: 'string', other: 'Timestamp'},
			{ name: 'minimumOrderQuantity', type: 'number'},
			{ name: 'orderQtyIncrements', type: 'number'},
			{ name: 'agreementId', type: 'string'},
			{ name: 'lastPrice', type: 'number'},
			{ name: 'currencyUomId', type: 'string'},
			{ name: 'shippingPrice', type: 'number'}, 
			{ name: 'agreementItemSeqId', type: 'string'},
			{ name: 'canDropShip', type: 'string'},
			{ name: 'comments', type: 'string'},
			{ name: 'quantityUomId', type: 'string'},
			]"/>

<#assign columnlist="
				{ text: '${uiLabelMap.FormFieldTitle_productId}', datafield: 'productId', minwidth: 150, editable: false},
				{ text: '${uiLabelMap.partyId}', datafield: 'partyId', width: 150, editable: false},
				{ text: '${uiLabelMap.Supplier}', datafield: 'supplierProductId', minwidth: 150, editable: true, columntype: 'dropdownlist', createeditor: 
					function(row, column, editor){
						editor.jqxDropDownList({ autoDropDownHeight: true, source: listSupplier, displayMember: 'partyId', valueMember: 'partyId' ,
                            renderer: function (index, label, value) {
			                    var datarecord = listSupplier[index];
			                    return datarecord.groupName;
			                } });
					}, cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                        if (newvalue == '') return oldvalue;
                    }
                },
				{ text: '${uiLabelMap.FormFieldTitle_supplierProductName}',  datafield: 'supplierProductName', minwidth: 140, editable: false},
				{ text: '${uiLabelMap.FormFieldTitle_availableFromDate}',  datafield: 'availableFromDate', minwidth: 150, editable: false,
					cellsformat: 'dd/MM/yyyy - hh:mm:ss'
				},
				{ text: '${uiLabelMap.FormFieldTitle_availableThruDate}',  datafield: 'availableThruDate', width: 150, columntype: 'datetimeinput', editable: true, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var thruDate = data.availableThruDate;
			        var dateShow = getDateTimeStamp(thruDate);
			        return '<span>' + dateShow + '</span>';
		        },validation: function (cell, value) {
		        	var thisRow = cell.row;
		        	var cellFD = $('#jqxgrid').jqxGrid('getCell', thisRow, 'availableFromDate');
		        	var thisFD = cellFD.value;
		        	if (value == null){
                    	return true;
                    }
                     if (thisFD > value) {
                         return { result: false, message: 'Thru Date can not before From Date' };
                     }
                     return true;
                 }
               },
				{ text: '${uiLabelMap.FormFieldTitle_minimumOrderQuantity}',  datafield: 'minimumOrderQuantity', width: 180, editable: false},
				{ text: '${uiLabelMap.FormFieldTitle_orderQtyIncrements}',  datafield: 'orderQtyIncrements', width: 160, editable: false},
				{ text: '${uiLabelMap.FormFieldTitle_agreementId}',  datafield: 'agreementId', width: 140, editable: false},
				{ text: '${uiLabelMap.FormFieldTitle_lastPrice}',  datafield: 'lastPrice', width: 140, editable: true},
				{ text: '${uiLabelMap.currencyUomId}',  datafield: 'currencyUomId', width: 100, editable: false},
				{ text: '${uiLabelMap.FormFieldTitle_shippingPrice}',  datafield: 'shippingPrice', width: 140, editable: true},
				"/>
<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false"
				showtoolbar="true" addrow="true" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true"
				url="jqxGeneralServicer?sname=JQGetListProductSupplier&productId=${productId}" updateUrl="jqxGeneralServicer?sname=updateSupplierProduct&jqaction=U"
				createUrl="jqxGeneralServicer?sname=createSupplierProduct&jqaction=C"
				editColumns="agreementId;agreementItemSeqId;availableFromDate(java.sql.Timestamp);availableThruDate(java.sql.Timestamp);canDropShip;comments;currencyUomId;lastPrice(java.math.BigDecimal);minimumOrderQuantity(java.math.BigDecimal);orderQtyIncrements(java.math.BigDecimal);partyId;productId;quantityUomId;shippingPrice(java.math.BigDecimal);supplierProductId;supplierProductName"
				addColumns="agreementId;agreementItemSeqId;availableFromDate(java.sql.Timestamp);availableThruDate(java.sql.Timestamp);canDropShip;comments;currencyUomId;lastPrice(java.math.BigDecimal);minimumOrderQuantity(java.math.BigDecimal);orderQtyIncrements(java.math.BigDecimal);partyId;productId;quantityUomId;shippingPrice(java.math.BigDecimal);supplierProductId;supplierProductName"
				/>
				
				<div id="alterpopupWindow" style="display:none;">
		        <div>${uiLabelMap.AddNewProductSupplier}</div>
		        <div style="overflow-y: scroll;">
		        	<div class="row-fluid">
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.ProductSupplier}:</div>
		    	 			<div class="span3"><div id="ProductSupplier1"></div></div>
		    	 			<div class="span3">${uiLabelMap.ProductCurrencyUomId}:</div>
		    	 			<div class="span3"><div id="ProductCurrencyUomId1"></div></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.AvailableFromDate}:</div>
		    	 			<div class="span3"><div id="availableFromDate1"></div></div>
		    	 			<div class="span3">${uiLabelMap.FormFieldTitle_lastPrice}:</div>
		    	 			<div class="span3"><div id="lastPrice1"/></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.AvailableThruDate}:</div>
		        	 		<div class="span3"><div id="AvailableThruDate1"></div></div>
		        	 		<div class="span3">${uiLabelMap.FormFieldTitle_shippingPrice}:</div>
		    	 			<div class="span3"><div id="shippingPrice1"/></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.FormFieldTitle_agreementId}:</div>
		        	 		<div class="span3"><input type='text' id="agreementId1"></input></div>
		        	 		<div class="span3">${uiLabelMap.FormFieldTitle_supplierProductName}:</div>
		        	 		<div class="span3"><input type='text' id="supplierProductName1"></input></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.FormFieldTitle_supplierProductId}:</div>
		        	 		<div class="span3"><input type='text' id="supplierProductId1"></input></div>
		        	 		<div class="span3">${uiLabelMap.FormFieldTitle_minimumOrderQuantity}:</div>
		        	 		<div class="span3"><div id="minimumOrderQuantity1"></div></div>
	        	 		</div>
	    	 			<div class="span12 no-left-margin">
		        	 		<div class="span3">${uiLabelMap.FormFieldTitle_comments}:</div>
		        	 		<div class="span9"><input type='text' id="comments1" /></div>
	        	 		</div>
		                <div class="span12 no-left-margin">
		                	<div class="span5"></div>
		                	<div class="span7"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div>
		                </div>
		            </table>
		        </div>
		    </div>
		    <script>
		     	$.jqx.theme = 'olbius';
		     	var listSupplier = new Array();
		     	var listUom = new Array();
		     	<#if listSup?exists>
				<#list listSup as item>
					var row = {};
					<#assign groupName = StringUtil.wrapString(item.groupName) />
					row['groupName'] = "${groupName}";
					row['partyId'] = '${item.partyId?if_exists}';
					listSupplier[${item_index}] = row;
				</#list>
			</#if>
			<#if listUom?exists>
				<#list listUom as item>
					var row = {};
					<#assign description = StringUtil.wrapString(item.description) />
					row['uomId'] = '${item.uomId?if_exists}';
					row['description'] = "${description}";
					listUom[${item_index}] = row;
				</#list>
			</#if>
		    	theme = $.jqx.theme;
		    	$("#ProductSupplier1").jqxDropDownList({ source: listSupplier, displayMember: 'groupName', valueMember: 'partyId'});
		    	$("#ProductCurrencyUomId1").jqxDropDownList({ source: listUom, displayMember: 'description', valueMember: 'uomId'});
		    	$("#availableFromDate1").jqxDateTimeInput();
		    	$("#AvailableThruDate1").jqxDateTimeInput();
		    	
		    	$("#lastPrice1").jqxNumberInput({inputMode: 'simple', spinButtons: true });
		    	$("#shippingPrice1").jqxNumberInput({inputMode: 'simple', spinButtons: true });
		    	$("#minimumOrderQuantity1").jqxNumberInput({inputMode: 'simple', spinButtons: true });
		    	$("#alterpopupWindow").jqxWindow({
		            width: 1150, maxWidth: 1000, minHeight: 320, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7
		        });
		        $("#alterCancel").jqxButton();
		        $("#alterSave").jqxButton();
		        $("#alterSave").click(function () {
		        	var row;
        			var tempFrDate = $('#availableFromDate1').val();
        			var dateFRM1 = tempFrDate.split('/');
    		        var frmDate = new Date(dateFRM1[2], dateFRM1[1] - 1, dateFRM1[0], 0, 0, 0, 0);
    		        var tempThrDate = $('#AvailableThruDate1').val();
        			var dateTHR1 = tempThrDate.split('/');
    		        var thrDate = new Date(dateTHR1[2], dateTHR1[1] - 1, dateTHR1[0], 0, 0, 0, 0);
		            row = {
		            		agreementId:$('#agreementId1').val(),
		            		productId:'${productId}',
		            		comments:$('#comments1').val(),
		            		currencyUomId:$('#ProductCurrencyUomId1').val(),
		            		lastPrice:$('#lastPrice1').val(),
		            		minimumOrderQuantity:$('#minimumOrderQuantity1').val(),
		            		partyId:$('#ProductSupplier1').val(),
		            		shippingPrice:$('#shippingPrice1').val(),
		            		supplierProductId:$('#supplierProductId1').val(),
		            		supplierProductName:$('#supplierProductName1').val(),
		            		availableFromDate:frmDate,
		            		availableThruDate:thrDate,
		            	  };
		            console.log(row);
		    	   	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
		            $("#jqxgrid").jqxGrid('clearSelection');
		            $("#jqxgrid").jqxGrid('selectRow', 0);
		            $("#alterpopupWindow").jqxWindow('close');
		        });
		    </script>