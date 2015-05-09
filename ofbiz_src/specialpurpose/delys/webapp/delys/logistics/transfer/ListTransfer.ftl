<script>
	<#assign statuses = delegator.findList("StatusItem", null, null, null, null, false) />
	var statusData = new Array();
	<#list statuses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description)>
		row['statusId'] = '${item.statusId?if_exists}';
		row['description'] = '${item.description?if_exists}';
		statusData[${item_index}] = row;
	</#list>
	
	<#assign parties = delegator.findList("PartyNameView", null, null, null, null, false) />
	var partyData = new Array();
	<#list parties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + " " + StringUtil.wrapString(item.middleName?if_exists) + " " + StringUtil.wrapString(item.lastName?if_exists) + " " + StringUtil.wrapString(item.groupName?if_exists) + "[" + StringUtil.wrapString(item.partyId)) +"]" >
		row['partyId'] = '${item.partyId?if_exists}';
		row['description'] = '${description?if_exists}';
		partyData[${item_index}] = row;
	</#list>
	
	<#assign postalAddresses = delegator.findList("PostalAddress", null, null, null, null, false)>
	var pstAddrData = new Array();
	<#list postalAddresses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.address1)/>
		row['contactMechId'] = '${item.contactMechId?if_exists}';
		row['description'] = '${description?if_exists}';
		pstAddrData[${item_index}] = row;
	</#list>
	
	<#assign facilities = delegator.findList("Facility", null, null, null, null, false)>
	var faciData = new Array();
	<#list facilities as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.facilityId?if_exists}';
		row['description'] = '${description?if_exists}';
		faciData[${item_index}] = row;
	</#list>
	
	<#assign currencyUoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "CURRENCY_MEASURE"), null, null, null, false)>
	var currencyUomData = new Array();
	<#list currencyUoms as item>
		var row = {};
		<#assign abbreviation = StringUtil.wrapString(item.abbreviation?if_exists)/>
		row['currencyUomId'] = '${item.uomId?if_exists}';
		row['description'] = '${abbreviation?if_exists}';
		currencyUomData[${item_index}] = row;
	</#list>
	
	<#assign packingUoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "PRODUCT_PACKING"), null, null, null, false)>
	var packingData = new Array();
	<#list packingUoms as item>
		var row = {};
		<#assign abbreviation = StringUtil.wrapString(item.abbreviation?if_exists)/>
		row['quantityUomId'] = '${item.uomId?if_exists}';
		row['description'] = '${abbreviation?if_exists}';
		packingData[${item_index}] = row;
	</#list>

	<#assign transferTypes = delegator.findList("TransferType", null, null, null, null, false)>
	var transferTypeData = new Array();
	<#list transferTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['transferTypeId'] = '${item.transferTypeId?if_exists}';
		row['description'] = '${description?if_exists}';
		transferTypeData[${item_index}] = row;
	</#list>
	
	<#assign productTypes = delegator.findList("ProductType", null, null, null, null, false)>
	var productTypeData = new Array();
	<#list productTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['productTypeId'] = '${item.productTypeId?if_exists}';
		row['description'] = '${description?if_exists}';
		productTypeData[${item_index}] = row;
	</#list>
</script>
<div id="transfer-list" class="tab-pane">
	<#assign columnlist="{ text: '${uiLabelMap.TransferId}', dataField: 'transferId', width: 150, filtertype:'input',
							cellsrenderer: function (row, column, value) {
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								return '<a style = \"margin-left: 10px\" href=' + 'viewTransfer?transferId=' + data.transferId + '>' +  data.transferId + '</a>'
							}
						},
					 { text: '${uiLabelMap.TransferType}', dataField: 'transferTypeId', width: 150,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < transferTypeData.length; i++){
								if(transferTypeData[i].transferTypeId == value){
									return '<span title=' + value + '>' + transferTypeData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.FacilityFrom}', dataField: 'originFacilityId', width: 150,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < faciData.length; i++){
								if(faciData[i].facilityId == value){
									return '<span title=' + value + '>' + faciData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.FacilityTo}', dataField: 'destFacilityId', width: 150,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < faciData.length; i++){
								if(faciData[i].facilityId == value){
									return '<span title=' + value + '>' + faciData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 },
						{ text: '${uiLabelMap.Status}', dataField: 'statusId', width: 150,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.createDate}', dataField: 'createDate', width: 150, cellsformat: 'd', filtertype: 'range'},
					 { text: '${uiLabelMap.TransferDate}', dataField: 'transferDate', width: 150, cellsformat: 'd', filtertype: 'range'},
					 { text: '${uiLabelMap.Description}', dataField: 'description', minwidth: 150},
					 "/>
	<#assign dataField="[{ name: 'transferId', type: 'string' },
					{ name: 'transferTypeId', type: 'string' },
                 	{ name: 'originFacilityId', type: 'string' },
                 	{ name: 'destFacilityId', type: 'string' },
                 	{ name: 'statusId', type: 'string' },
					{ name: 'createDate', type: 'date', other: 'Timestamp' },
					{ name: 'transferDate', type: 'date', other: 'Timestamp' },
					{ name: 'description', type: 'string' },
		 		 	]"/>
	<@jqGrid filtersimplemode="true" sortdirection="desc" defaultSortColumn="createDate" sortable="true" id="jqxgrid" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" addrefresh="true" showtoolbar="true" addrow="true" filterable="true" alternativeAddPopup="alterpopupWindow" editable="false" 
		 url="jqxGeneralServicer?sname=getListTransfer" createUrl="jqxGeneralServicer?sname=createTransfer&jqaction=C" updateUrl="jqxGeneralServicer?sname=updateTransfer&jqaction=U"
		 addColumns="transferId;transferTypeId;originFacilityId;destFacilityId;statusId;description;carrierPartyId;shipmentMethodTypeId;originContactMechId;destContactMechId;shipBeforeDate(java.sql.Timestamp);shipAfterDate(java.sql.Timestamp);listProducts(java.util.List);"/>
</div>

<div id="transfer-new" class="tab-pane">
<#assign columnlist="{ text: '${uiLabelMap.ProductProductId}', dataField: 'productId', minwidth: 100, align: 'center', editable: false, filtertype:'input'},
				 { text: '${uiLabelMap.ProductName}', dataField: 'internalName', align: 'center', minwidth: 100, editable: false,filtertype: 'input'},
				 { text: '${uiLabelMap.ProductType}', dataField: 'productTypeId', align: 'center', minwidth: 100, editable: false,
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < productTypeData.length; i++){
							if(productTypeData[i].productTypeId == value){
								return '<span title=' + value + '>' + productTypeData[i].description + '</span>'
							}
						}
					},
					filtertype: 'input'
				 },
				 { text: '${uiLabelMap.ExpireDate}', dataField: 'expireDate', minwidth: 100, align: 'center', cellsformat: 'd', editable: false, filterable: false, filtertype: 'input'},
				 { text: '${uiLabelMap.QuantityToTransfer}', dataField: 'quantity', width: 100, align: 'center', cellsalign: 'right', columntype: 'numberinput', filterable: false, editable: true,
                     validation: function (cell, value) {
                         if (value < 0) {
                             return { result: false, message: '${uiLabelMap.QuantityMustBeGreateThanZero}'};
                         }
                         return true;
                     },
                     createeditor: function (row, cellvalue, editor) {
                         editor.jqxNumberInput({ decimalDigits: 0, digits: 10 });
                     }
				 },
				 { text: '${uiLabelMap.QuantityUom}', dataField: 'quantityUomIdToTransfer', width: 100, align: 'center', cellsalign: 'right', filterable: false, columntype: 'dropdownlist', 
					 cellsrenderer: function(row, column, value){
						for(var i = 0; i < packingData.length; i++){
							if(packingData[i].quantityUomId == value){
								return '<span title=' + value + '>' + packingData[i].description + '</span>'
							}
						}
					},
					 initeditor: function (row, cellvalue, editor) {
		                   var packingUomData = new Array();
		                   var data = $('#jqxgridProduct').jqxGrid('getrowdata', row);
		                   var packingUomIdArray = data['qtyUomIds'];
		                   for (var i = 0; i < packingUomIdArray.length; i++) {
			                    var packingUomIdItem = packingUomIdArray[i];
			                    var row = {};
			                    row['quantityUomId'] = '' + packingUomIdItem.uomId;
			                    row['description'] = '' + packingUomIdItem.description;
			                    packingUomData[i] = row;
		                   }
		                   var sourceDataPacking =
		                   {
			                   localdata: packingUomData,
			                   datatype: 'array'
		                   };
		                   var dataAdapterPacking = new $.jqx.dataAdapter(sourceDataPacking);
		                   editor.jqxDropDownList({ selectedIndex: 0, source: dataAdapterPacking, displayMember: 'description', valueMember: 'quantityUomId'
		                   });
					 },
				 },
				 { text: '${uiLabelMap.ATPTotal}', dataField: 'ATP', minwidth: 100, align: 'center', filterable: false, editable: false,
						cellsrenderer: function(row, column, value){
							var data = $('#jqxgridProduct').jqxGrid('getrowdata', row);
							for(var i = 0; i < packingData.length; i++){
								if(packingData[i].quantityUomId == data.quantityUomId){
									return '<span>' + value +' (' + packingData[i].description +  ')</span>';
								}
							}
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.QOHTotal}', dataField: 'QOH', minwidth: 100, align: 'center', filterable: false, editable: false,
						cellsrenderer: function(row, column, value){
							var data = $('#jqxgridProduct').jqxGrid('getrowdata', row);
							for(var i = 0; i < packingData.length; i++){
								if(packingData[i].quantityUomId == data.quantityUomId){
									return '<span>' + value +' (' + packingData[i].description +  ')</span>';
								}
							}
						},
						filtertype: 'input'
					 },
				 "/>
<#assign dataField="[{ name: 'productId', type: 'string' },
             	{ name: 'internalName', type: 'string' },
             	{ name: 'productTypeId', type: 'string' },
				{ name: 'ATP', type: 'string' },
             	{ name: 'QOH', type: 'string' },
             	{ name: 'expireDate',  type: 'date', other: 'Timestamp'},
             	{ name: 'quantity', type: 'string' },
             	{ name: 'quantityUomId', type: 'string' },
             	{ name: 'quantityUomIdToTransfer', type: 'string' },
             	{ name: 'qtyUomIds', type: 'string' }
	 		 	]"/>
</div>

<div id="alterpopupWindow" class="hide" style="min-height: 550px;">
	<div>${uiLabelMap.NewTransfer}</div>
		<div style="overflow: hidden;">
		<table>
			<input type="hidden" id="shipmentMethodTypeId" value="NO_SHIPPING"></input>
			<input type="hidden" id="carrierPartyId" value="_NA_"></input>
			<tr style="display:none;">
				<td style="max-width: 100%; display: block;" colspan="4">
					<h4 class="row header smaller lighter blue" style="margin-left: 50px !important">
						${uiLabelMap.Transfer}
					</h4>
				</td>
			</tr>
			<tr>
				<td align="right">
					${uiLabelMap.TransferType}:
				</td>
				<td align="left">
			       <div id="transferTypeId" style="width: 200px" class="green-label">
			       </div>
			    </td>
			   
			    <td align="right">
					${uiLabelMap.description}:
				</td>
				<td align="left">
					<input id="description" style="width: 198px; margin-top: 1px;"></input>
			    </td>
			</tr>
				
			<tr>
				<td align="right">
					${uiLabelMap.FacilityFrom}:
				</td>
				<td align="left">
			       <div id="originFacilityId" style="width: 200px" class="green-label">
			       </div>
			    </td>
			   
			   	<td align="right">
					${uiLabelMap.FacilityTo}:
				</td>
				<td align="left">
			       <div id="destFacilityId" style="width: 200px" class="green-label"></div>
			    </td>
			</tr>
			<tr>
				<td align="right">
					${uiLabelMap.OriginContactMech}:
				</td>
				<td align="left">
			       <div id="originContactMechId" style="width: 200px" class="green-label">
			       </div>
			    </td>
			   
			   	<td align="right">
					${uiLabelMap.DestinationContactMech}:
				</td>
				<td align="left">
			       <div id="destContactMechId" style="width: 200px" class="green-label"></div>
			    </td>
			</tr>
			<tr>
				<td align="right" style="min-width: 180px;">
					${uiLabelMap.ShipBeforeDate}:
				</td>
				<td align="left">
					<div id="shipBeforeDate"></div>
				</td>
				
				<td align="right" style="min-width: 180px;">
					${uiLabelMap.ShipAfterDate}:
				</td>
				<td align="left">
				<div id="shipAfterDate"></div>
				</td>
			</tr>
			<tr>
			    <td colspan="4">
			    <div style="margin-left: 20px"><div id="jqxgridProduct"></div></div>
				</td>
		    </tr>
		    <tr>
		        <td colspan="4" style="width: 100%; display: block;vertical-align:middle;">
		        	<div style="margin:0px auto;width:950px;">
		        		<div style="margin:0px auto;width:250px;">
				        	<input type="button" id="alterSave" value="${uiLabelMap.CommonSave}" />
				        	<input style="margin-right: 5px;" id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" />
			        	</div>
		        	</div>
		        </td>
	        </tr>
		</table>
	</div>
</div>
<style type="text/css">
	#statusbarjqxgridProduct{
		display:none;
	}
</style>
<div id='Menu'>
	<ul>
		<#if security.hasPermission("TRANSFER_ADMIN", userLogin)>
	    	<li id='menuAppoveTransfer'>${uiLabelMap.Approve}</li>
    	</#if>
    	<li id='menuDeleteTransfer'>${uiLabelMap.CommonDelete}</li>
	</ul>
</div>
<div id="confirmDeletePopupWindow" class="hide">
	<div>${uiLabelMap.DAAreYouSureDelete}</div>
	<div style="overflow: hidden;">
		<table>
			<tr>
			    <td align="left"><input type="hidden" id="transferId" /> </td>
			</tr>
			<tr>
			    <td style="margin-left: 10px" align="right"><input type="button" id="ConfirmDelete" value="${uiLabelMap.CommonDelete}" class="btn btn-primary"><input id="ConfirmCancel" type="button" value="${uiLabelMap.CommonCancel}" class="btn btn-primary icon-cancel"/></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	//Create Window
	
	var originFacilityData = new Array();
	var destFacilityToData = new Array();
	var originContactMechData = new Array();
	var destContactMechData = new Array();
	
	$("#transferTypeId").jqxDropDownList({source: transferTypeData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "transferTypeId"});
	$("#originFacilityId").jqxDropDownList({source: faciData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "facilityId"});
	$("#destFacilityId").jqxDropDownList({source: faciData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "facilityId"});
	$("#originContactMechId").jqxDropDownList({source: originContactMechData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "contactMechId"});
	$("#destContactMechId").jqxDropDownList({source: destContactMechData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "contactMechId"});
	$("#shipBeforeDate").jqxDateTimeInput({height: '25px', formatString: 'd'});
	$("#shipAfterDate").jqxDateTimeInput({height: '25px', formatString: 'd'});
	
	$("#alterpopupWindow").jqxWindow({
		maxWidth: 1500, minWidth: 950, minHeight: 515, maxHeight: 1200, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});
	$('#alterpopupWindow').on('open', function (event) {
		updateFacilityByTransferType ({
	        	transferTypeId: $("#transferTypeId").val(),
			}, 'getFacilityByTransferType' , 'listOriginFacilities', 'listDestFacilities', 'listOriginContactMechs', 'listDestContactMechs', 'facilityId', 'facilityName', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'originFacilityId', 'destFacilityId', 'originContactMechId', 'destContactMechId');
	});
	$("#alterSave").jqxButton({width: 100, theme: theme});
	$("#alterCancel").jqxButton({width: 100, theme: theme});
	
	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		var row;
		var selectedIndexs = $('#jqxgridProduct').jqxGrid('getselectedrowindexes');
		
		var listProducts = new Array();
		for(var i = 0; i < selectedIndexs.length; i++){
			var data = $('#jqxgridProduct').jqxGrid('getrowdata', selectedIndexs[i]);
			var map = {};
			map['productId'] = data.productId;
			if (data.productTypeId == 'FINISHED_GOOD'){
				map['transferItemTypeId'] = "PRODUCT_TRANS_ITEM";
			} else if (data.productTypeId == 'MARKETING_POSM') {
				map['transferItemTypeId'] = "POSM_TRANS_ITEM";
			}
			map['quantity'] = data.quantity;
			if (data.quantityUomIdToTransfer != null){
				map['quantityUomId'] = data.quantityUomIdToTransfer;
			} else {
				map['quantityUomId'] = data.quantityUomId;
			}
			if (data.expireDate != null){
				map['expireDate'] = data.expireDate.getTime();
			} else {
				map['expireDate'] = "";
			}
			listProducts[i] = map;
		}
		
		listProducts = JSON.stringify(listProducts);
		row = { 
				transferTypeId:$('#transferTypeId').val(),
				originFacilityId:$('#originFacilityId').val(),
				destFacilityId:$('#destFacilityId').val(),
				originContactMechId:$('#originContactMechId').val(),
				shipmentMethodTypeId: $('#shipmentMethodTypeId').val(),
				carrierPartyId: $('#carrierPartyId').val(),
				destContactMechId:$('#destContactMechId').val(),
				shipBeforeDate:$('#shipBeforeDate').val(),
				shipAfterDate:$('#shipAfterDate').val(),
				description:$('#description').val(),
				listProducts:listProducts
    	  };
		$("#jqxgrid").jqxGrid('addRow', null, row, "first");
    	$("#alterpopupWindow").jqxWindow('close');
	}); 
	
	var contextMenu = $("#Menu").jqxMenu({ width: 150, height: 58, autoOpenPopup: false, mode: 'popup'});
    $("#jqxgrid").on('contextmenu', function () {
        return false;
    });
    // handle context menu clicks.
    $("#Menu").on('itemclick', function (event) {
        var args = event.args;
        var rowindex = $("#jqxgrid").jqxGrid('getselectedrowindex');
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.Approve)}") {
            var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', rowindex);
            var transferId = dataRecord.transferId;
            approveTransfer({
            	transferId: transferId,
			}, 'approveTransfer', 'jqxgrid');
        }
    });
    
    $("#confirmDeletePopupWindow").jqxWindow({ width: 250, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#ConfirmCancel"), modalOpacity: 0.01 });
    $("#ConfirmCancel").jqxButton({ theme: theme });
    $("#ConfirmDelete").jqxButton({ theme: theme });
    $("#ConfirmDelete").click(function () {
    	removeTransfer({
        	transferId: $("#transferId").val(),
		}, 'deleteTransfer', 'jqxgrid');
        $("#confirmDeletePopupWindow").jqxWindow('hide');
    });
    $("#ConfirmCancel").click(function () {
    	$("#confirmDeletePopupWindow").jqxWindow('hide');
    });
//    $("#jqxgrid").on('rowClick', function (event) {
//        if (event.args.rightclick) {
//        	var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', event.args.rowindex);
//    		if ("TRANSFER_CREATED" == dataRecord.statusId){
//        		$("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
//        		$("#menuAppoveTransfer").show();
//        		$("#menuDeleteTransfer").show();
//        		$("#menuCreateDelivery").hide();
//                var scrollTop = $(window).scrollTop();
//                var scrollLeft = $(window).scrollLeft();
//                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
//                return false;
//        	} 
//        	if ("TRANSFER_APPROVED" == dataRecord.statusId){
//        		$("#menuAppoveTransfer").hide();
//        		$("#menuDeleteTransfer").hide();
//        		$("#menuCreateDelivery").show();
//        		$("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
//                var scrollTop = $(window).scrollTop();
//                var scrollLeft = $(window).scrollLeft();
//                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
//                return false;
//        	} 
//        }
//    });
    var tmpFlag = true;
	var tmpFlag2 = true;
	
	$("#transferTypeId").change(function(){
		updateFacilityByTransferType ({
        	transferTypeId: $("#transferTypeId").val(),
		}, 'getFacilityByTransferType' , 'listOriginFacilities', 'listDestFacilities', 'listOriginContactMechs', 'listDestContactMechs', 'facilityId', 'facilityName', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'originFacilityId', 'destFacilityId', 'originContactMechId', 'destContactMechId');
	});
    $("#originFacilityId").on('change', function(event){
		isNull = false;
		if ($("#originFacilityId").val() == $("#destFacilityId").val()){
			var currentIndex = $("#destFacilityId").jqxDropDownList('getSelectedIndex');
			var item = $("#destFacilityId").jqxDropDownList('getItem', currentIndex + 1);
			if (item){
				$("#destFacilityId").jqxDropDownList({selectedIndex: currentIndex + 1});
			} else {
				item = $("#destFacilityId").jqxDropDownList('getItem', currentIndex - 1);
				if (item){
					$("#destFacilityId").jqxDropDownList({selectedIndex: currentIndex - 1});
				} else {
					$("#destFacilityId").jqxDropDownList('clear');
				}
			}
			update({
				facilityId: $("#originFacilityId").val(),
				contactMechPurposeTypeId: "SHIP_ORIG_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'originContactMechId');
		} else {
			update({
				facilityId: $("#originFacilityId").val(),
				contactMechPurposeTypeId: "SHIP_ORIG_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'originContactMechId');
		}
		var tmpS = $("#jqxgridProduct").jqxGrid('source');
	 	var curFacilityId = $("#originFacilityId").val();
	 	tmpS._source.url = "jqxGeneralServicer?sname=getListProducts&facilityId="+curFacilityId;
	 	$("#jqxgridProduct").jqxGrid('source', tmpS);
	});
	$("#destFacilityId").on('change', function(event){
		isNull = false;
		
		if ($("#originFacilityId").val() == $("#destFacilityId").val()){
			var currentIndex = $("#originFacilityId").jqxDropDownList('getSelectedIndex');
			var item = $("#originFacilityId").jqxDropDownList('getItem', currentIndex + 1);
			if (item){
				$("#originFacilityId").jqxDropDownList({selectedIndex: currentIndex + 1});
			} else {
				item = $("#originFacilityId").jqxDropDownList('getItem', currentIndex - 1);
				if (item){
					$("#originFacilityId").jqxDropDownList({selectedIndex: currentIndex - 1});
				} else {
					$("#originFacilityId").jqxDropDownList('clear');
				}
			}
			update({
				facilityId: $("#destFacilityId").val(),
				contactMechPurposeTypeId: "SHIPPING_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'destContactMechId');
		} else {
			update({
				facilityId: $("#destFacilityId").val(),
				contactMechPurposeTypeId: "SHIPPING_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'destContactMechId');
		}
	});
    function updateFacilityByTransferType(jsonObject, url, data1, data2, data3, data4, key1, value1, key2, value2, key3, value3, key4, value4, id1, id2, id3, id4) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	var json1 = res[data1];
	            renderHtml(json1, key1, value1, id1);
	            var json2 = res[data2];
	            renderHtml(json2, key2, value2, id2);
	            var json3 = res[data3];
	            renderHtml(json3, key3, value3, id3);
	            var json4 = res[data4];
	            renderHtml(json4, key4, value4, id4);
	            var tmpS = $("#jqxgridProduct").jqxGrid('source');
			 	var curFacilityId = $("#originFacilityId").val();
			 	tmpS._source.url = "jqxGeneralServicer?sname=getListProducts&facilityId="+curFacilityId;
			 	$("#jqxgridProduct").jqxGrid('source', tmpS);
	        }
	    });
	}
    function renderHtml(data, key, value, id){
		var y = "";
		var source = new Array();
		var index = 0;
		for (var x in data){
			index = source.length;
			var row = {};
			row[key] = data[x][key];
			row['description'] = data[x][value];
			source[index] = row;
		}
		if($("#"+id).length){
			$("#"+id).jqxDropDownList('clear');
			$("#"+id).jqxDropDownList({source: source, selectedIndex: 0});
		}
	}
    function update(jsonObject, url, data, key, value, id) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	var json = res[data];
	            renderHtml(json, key, value, id);
	        }
	    });
	}
    function approveTransfer(jsonObject, url, jqxgrid) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	$("#"+jqxgrid).jqxGrid('updatebounddata');
	        }
	    });
	}
</script>
<@jqGrid selectionmode="checkbox" idExisted="true" filtersimplemode="true" width="890" viewSize="5" pagesizeoptions="['5', '10', '15', '20', '25', '30', '50', '100']" id="jqxgridProduct" dataField=dataField columnlist=columnlist 
clearfilteringbutton="true" showtoolbar="true" addrow="false" filterable="true" editable="true" customTitleProperties="ListProductTransfer"
	 url="jqxGeneralServicer?sname=getListProducts&facilityId=" editmode="click" bindresize="false" jqGridMinimumLibEnable="false" otherParams="qtyUomIds:S-getProductPackingUoms(productId)<listPackingUoms>" offmode="true"/>