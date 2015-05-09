<script>
	<#assign statuses = delegator.findList("StatusItem", null, null, null, null, false) />
	var statusData = new Array();
	<#list statuses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description)>
		row['statusId'] = '${item.statusId}';
		row['description'] = '${item.description}';
		statusData[${item_index}] = row;
	</#list>
	
	<#assign parties = delegator.findList("PartyNameView", null, null, null, null, false) />
	var partyData = new Array();
	<#list parties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(StringUtil.wrapString(item.firstName?if_exists) + " " + StringUtil.wrapString(item.middleName?if_exists) + " " + StringUtil.wrapString(item.lastName?if_exists) + " " + StringUtil.wrapString(item.groupName?if_exists) + "[" + StringUtil.wrapString(item.partyId)) +"]" >
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description?if_exists}';
		partyData[${item_index}] = row;
	</#list>
	
	<#assign postalAddresses = delegator.findList("PostalAddress", null, null, null, null, false)>
	var pstAddrData = new Array();
	<#list postalAddresses as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.address1)/>
		row['contactMechId'] = '${item.contactMechId}';
		row['description'] = '${description}';
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
	
	<#assign products = delegator.findList("GroupProductInventory", null, null, null, null, false)>
	var productData = new Array();
	<#list products as item>
		var row = {};
		<#assign internalName = StringUtil.wrapString(item.internalName?if_exists)/>
		row['productId'] = '${item.productId?if_exists}';
		row['description'] = '${internalName?if_exists}';
		productData[${item_index}] = row;
	</#list>
	<#assign listRoles = Static["com.olbius.delys.util.SecurityUtil"].getCurrentRoles(userLogin.partyId, delegator)>
	<#assign isSpecialist = false>
	<#assign isStorekeeper = false>
	<#list listRoles as role>
		<#assign roleTypeId = StringUtil.wrapString(role)/>
		<#if roleTypeId == 'LOG_SPECIALIST'>
			<#assign isSpecialist = true>
			<#break>
		</#if>
	</#list>
	<#if !isSpecialist>
		<#list listRoles as role>
			<#assign roleTypeId = StringUtil.wrapString(role)/>
			<#if roleTypeId == 'LOG_STOREKEEPER'>
				<#assign isStorekeeper = true>
				<#break>
			</#if>
		</#list>
	</#if>
</script>
<div id="requirement-list" class="tab-pane">
	<#assign columnlist="{ text: '${uiLabelMap.requirementId}', dataField: 'requirementId', width: 150, filtertype:'input'},
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
					 { text: '${uiLabelMap.Requestor}', dataField: 'partyId', width: 150, 
						cellsrenderer: function(row, column, value){
							var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							for(var i = 0; i < partyData.length; i++){
								if(partyData[i].partyId == value){
									return '<span title=' + value + '>' + partyData[i].description + '</span>'
								}
							}
						},
						filtertype: 'input'
					 },
					 { text: '${uiLabelMap.FacilityFrom}', dataField: 'facilityIdFrom', width: 150,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.OriginContactMech}', dataField: 'originContactMechId', width: 150,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.FacilityTo}', dataField: 'facilityIdTo', width: 150,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < faciData.length; i++){
								 if(faciData[i].facilityId == value){
									 return '<span title=' + value + '>' + faciData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.DestinationContactMech}', dataField: 'destContactMechId', width: 150,
						 cellsrenderer: function(row, column, value){
							 for(var i = 0; i < pstAddrData.length; i++){
								 if(pstAddrData[i].contactMechId == value){
									 return '<span title=' + value + '>' + pstAddrData[i].description + '</span>'
								 }
							 }
						 },
						 filtertype: 'input'
					 },
					 { text: '${uiLabelMap.RequiredByDate}', dataField: 'requiredByDate', width: 150, cellsformat: 'd', filtertype: 'range'},
					 { text: '${uiLabelMap.TransferDate}', dataField: 'requirementStartDate', width: 150, cellsformat: 'd', filtertype: 'range'},
					 "/>
	<#assign dataField="[{ name: 'requirementId', type: 'string' },
                 	{ name: 'statusId', type: 'string' },
                 	{ name: 'partyId', type: 'string' },
                 	{ name: 'facilityIdFrom', type: 'string' },
					{ name: 'originContactMechId', type: 'string' },
                 	{ name: 'facilityIdTo', type: 'string' },
                 	{ name: 'destContactMechId', type: 'string' },
                 	{ name: 'requiredByDate', type: 'date', other: 'Timestamp' },
					{ name: 'requirementStartDate', type: 'date', other: 'Timestamp' },
		 		 	]"/>
	<#if isStorekeeper>
	<@jqGrid contextMenuId="Menu" filtersimplemode="true" id="jqxgrid" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" filterable="true" alternativeAddPopup="alterpopupWindow" editable="false" 
		 url="jqxGeneralServicer?sname=getListRequirements&requirementTypeId=TRANSFER_REQ" createUrl="jqxGeneralServicer?sname=createTransferRequirement&jqaction=C" updateUrl="jqxGeneralServicer?sname=updateTransferRequirement&jqaction=U"
		 addColumns="productStoreIdFrom;currencyUomId;reason;description;productStoreIdTo;facilityIdFrom;facilityIdTo;requirementStartDate(java.sql.Timestamp);requiredByDate(java.sql.Timestamp);originContactMechId;destContactMechId;listProducts(java.util.List);requirementTypeId[TRANSFER_REQ];estimatedBudget" 
		 otherParams="partyId:SL-getRequirementRoles(requirementId,roleTypeId*OWNER)<listRequirementRoles>"/>
	<#elseif isSpecialist>
	<@jqGrid contextMenuId="Menu" filtersimplemode="true" id="jqxgrid" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false" filterable="true" alternativeAddPopup="alterpopupWindow" editable="false" 
		 url="jqxGeneralServicer?sname=getListRequirements&requirementTypeId=TRANSFER_REQ" createUrl="jqxGeneralServicer?sname=createTransferRequirement&jqaction=C" updateUrl="jqxGeneralServicer?sname=updateTransferRequirement&jqaction=U"
		 addColumns="productStoreIdFrom;currencyUomId;reason;description;productStoreIdTo;facilityIdFrom;facilityIdTo;requirementStartDate(java.sql.Timestamp);requiredByDate(java.sql.Timestamp);originContactMechId;destContactMechId;listProducts(java.util.List);requirementTypeId[TRANSFER_REQ];estimatedBudget" 
		 otherParams="partyId:SL-getRequirementRoles(requirementId,roleTypeId*OWNER)<listRequirementRoles>"/>
	</#if>
</div>

<div id="requirement-new" class="tab-pane">
<#assign columnlist="{ text: '${uiLabelMap.ProductId}', dataField: 'productId', minwidth: 100, align: 'center', editable: false, filtertype:'input'},
				 { text: '${uiLabelMap.ProductName}', dataField: 'internalName', align: 'center', minwidth: 100, editable: false,
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < productData.length; i++){
							if(productData[i].productId == value){
								return '<span title=' + value + '>' + productData[i].internalName + '</span>'
							}
						}
					},
					filtertype: 'input'
				 },
				 { text: '${uiLabelMap.ATP}', dataField: 'ATP', minwidth: 100, align: 'center', editable: false,
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < productData.length; i++){
							if(productData[i].ATP == value){
								return '<span title=' + value + '>' + productData[i].ATP + '</span>'
							}
						}
					},
					filtertype: 'input'
				 },
				 { text: '${uiLabelMap.QOH}', dataField: 'QOH', minwidth: 100, align: 'center', editable: false,
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < productData.length; i++){
							if(productData[i].QOH == value){
								return '<span title=' + value + '>' + productData[i].QOH + '</span>'
							}
						}
					},
					filtertype: 'input'
				 },
				 { text: '${uiLabelMap.ExpireDate}', dataField: 'expireDate', minwidth: 100, align: 'center', cellsformat: 'd', editable: false,
					cellsrenderer: function(row, column, value){
						for(var i = 0; i < productData.length; i++){
							if(productData[i].expireDate == value){
								return '<span title=' + value + '>' + productData[i].expireDate + '</span>'
							}
						}
					},
					filtertype: 'input'
				 },
				 { text: '${uiLabelMap.QuantityRequest}', dataField: 'quantity', width: 100, align: 'center', cellsalign: 'right', columntype: 'numberinput', editable: true,
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
				 { text: '${uiLabelMap.QuantityUom}', dataField: 'quantityUomId', width: 100, align: 'center', cellsalign: 'right', columntype: 'dropdownlist', 
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
		                   editor.jqxDropDownList({ selectedIndex: 0, source: dataAdapterPacking, displayMember: 'quantityUomId', valueMember: 'quantityUomId'
		                   });
					 },
				 },
				 "/>
<#assign dataField="[{ name: 'productId', type: 'string' },
             	{ name: 'internalName', type: 'string' },
				{ name: 'ATP', type: 'string' },
             	{ name: 'QOH', type: 'string' },
             	{ name: 'expireDate',  type: 'date', other: 'Timestamp'},
             	{ name: 'quantity', type: 'string' },
             	{ name: 'quantityUomId', type: 'string' },
             	{ name: 'qtyUomIds', type: 'string' }
	 		 	]"/>
</div>

<div id="alterpopupWindow">
	<div>${uiLabelMap.accCreateNew}</div>
		<div style="overflow: hidden;">
		<table>
			<input type="hidden" name="requirementTypeId" value="TRANSFER_REQ"></input>
			<tr>
				<td style="min-width: 500px; display: block;">
					<h4 class="row header smaller lighter blue" style="width: 100%; margin-left: 50px !important">
						${uiLabelMap.TransferRequirement}
					</h4>
				</td>
			</tr>
			<tr>
				<td align="right">
					${uiLabelMap.ProductStoreFrom}:
				</td>
				<td align="left">
			       <div id="productStoreIdFrom" style="width: 200px" class="green-label">
			       </div>
			    </td>
			   
			   	<td align="right">
					${uiLabelMap.ProductStoreTo}:
				</td>
				<td align="left">
			       <div id="productStoreIdTo" style="width: 200px" class="green-label"></div>
			    </td>
			</tr>
			<tr>
				<td align="right">
					${uiLabelMap.FacilityFrom}:
				</td>
				<td align="left">
			       <div id="facilityIdFrom" style="width: 200px" class="green-label">
			       </div>
			    </td>
			   
			   	<td align="right">
					${uiLabelMap.FacilityTo}:
				</td>
				<td align="left">
			       <div id="facilityIdTo" style="width: 200px" class="green-label"></div>
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
				<td align="right" style="min-width: 200px; padding-right: 15px;">
					${uiLabelMap.RequiredByDate}:
				</td>
				<td align="left">
					<div id="requiredByDate"></div>
				</td>
				
				<td align="right">
					${uiLabelMap.estimatedBudget}:
				</td>
				<td align="left">
					<input type="text" id="estimatedBudget"/>
			    </td>
			</tr>
			<tr>
				<td align="right" style="min-width: 200px; padding-right: 15px;">
					${uiLabelMap.TransferDate}:
				</td>
				<td align="left">
					<div id="requirementStartDate"></div>
				</td>
			   
			   	<td align="right">
					${uiLabelMap.currencyUomId}:
				</td>
				<td align="left">
			       <div id="currencyUomId" style="width: 200px" class="green-label"></div>
			    </td>
			</tr>
			<tr>
				<td align="right" style="min-width: 200px; padding-right: 15px;">
					${uiLabelMap.Reason}:
				</td>
				<td align="left">
					<textarea id="reason" rows="2" cols="30" style="width: 190px; margin-top: 1px;"></textarea>
				</td>
			   
			   	<td align="right">
					${uiLabelMap.description}:
				</td>
				<td align="left">
					<textarea id="description" rows="2" cols="30" style="width: 190px; margin-top: 1px;"></textarea>
			    </td>
			</tr>
		    <tr>
			    <td colspan="4">
					<div id="jqxgridProduct"></div>
				</td>
		    </tr>
		    <tr>
	        <td align="right"></td>
	        <td align="right"></td>
	        <td style="min-width: 300px; width: 300px; max-width: 1000px;">
	        	<input type="button" id="alterSave" value="${uiLabelMap.CommonSave}" />
	        	<input style="margin-right: 5px;" id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" />
	        </td>
	    </tr>
		</table>
	</div>
</div>
<div id='Menu'>
	<ul>
		<#if isStorekeeper>
			<li id='menuSentReq'>${uiLabelMap.CommonSend}</li>
			<li id='menuDeleteReq'>${uiLabelMap.CommonDelete}</li>
		</#if>
		<#if isSpecialist>
	    	<li id='menuAppoveReq'>${uiLabelMap.Approve}</li>
	    	<li id='menuCreateTransfer'>${uiLabelMap.CreateTransfer}</li>
	    	<li id='menuCancelReq'>${uiLabelMap.CommonCancel}</li>
	    </#if>
	</ul>
</div>
<div id="confirmDeletePopupWindow">
<div>${uiLabelMap.DAAreYouSureDelete}</div>
<div style="overflow: hidden;">
	<table>
		<tr>
		    <td align="left"><input type="hidden" id="requirementId" /> </td>
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
	$("#alterpopupWindow").jqxWindow({
		maxWidth: 1500, minWidth: 950, minHeight: 700, maxHeight: 1200, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});
	$('#alterpopupWindow').on('open', function (event) {
		updateMultiElement({
			productStoreId: $("#productStoreIdFrom").val(),
			productStoreIdTo: $("#productStoreIdTo").val(),
			contactMechPurposeTypeIdFrom: "SHIP_ORIG_LOCATION",
			contactMechPurposeTypeIdTo: "SHIPPING_LOCATION"
		}, 'getFacilities' , 'listFacilities', 'listFacilitiesTo', 'listContactMechsFrom', 'listContactMechsTo', 'facilityId', 'facilityName', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'facilityIdFrom', 'facilityIdTo', 'originContactMechId', 'destContactMechId');
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
			map['quantity'] = data.quantity;
			map['quantityUomId'] = data.quantityUomId;
			map['expireDate'] = data.expireDate;
			listProducts[i] = map;
		}
		listProducts = JSON.stringify(listProducts);
		row = { 
				productStoreIdFrom:$('#productStoreIdFrom').val(),
				productStoreIdTo:$('#productStoreIdTo').val(),
				facilityIdFrom:$('#facilityIdFrom').val(),
				facilityIdTo:$('#facilityIdTo').val(),
				originContactMechId:$('#originContactMechId').val(),
				destContactMechId:$('#destContactMechId').val(),
				requirementStartDate:$('#requirementStartDate').val(),
				requiredByDate:$('#requiredByDate').val(),
				estimatedBudget:$('#estimatedBudget').val(),
				currencyUomId:$('#currencyUomId').val(),
				reason:$('#reason').val(),
				description:$('#description').val(),
				listProducts:listProducts
    	  };
		$("#jqxgrid").jqxGrid('addRow', null, row, "first");
		$("#jqxgrid").jqxGrid('updatebounddata');
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
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.CommonSend)}") {
            var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', rowindex);
            var reqId = dataRecord.requirementId;
            sendRequirement({
            	requirementId: reqId,
				partyIdTo: 'LOG_SPECIALIST',
				sendMessage: '${uiLabelMap.NewTransferRequirementMustBeApprove}',
				action: "getListTransferRequirements",
			}, 'sendTransferRequirement', 'jqxgrid');
        }
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.Approve)}") {
            var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', rowindex);
            var reqId = dataRecord.requirementId;
            approveRequirement({
            	requirementId: reqId,
			}, 'approveTransferRequirement', 'jqxgrid');
        }
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.CreateTransfer)}") {
            var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', rowindex);
            var reqId = dataRecord.requirementId;
            createTransfer({
            	requirementId: reqId,
			}, 'createTransferFromRequirement', 'jqxgrid');
        }
        if ($.trim($(args).text()) == "${StringUtil.wrapString(uiLabelMap.CommonDelete)}") {
            var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', rowindex);
            var reqId = dataRecord.requirementId;
            var offset = $("#jqxgrid").offset();
            $("#confirmDeletePopupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 350, y: parseInt(offset.top) + 150} });
            $("#confirmDeletePopupWindow").jqxWindow('show');
            $("#requirementId").val(dataRecord.requirementId);
        }
    });
    
    $("#confirmDeletePopupWindow").jqxWindow({ width: 250, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#ConfirmCancel"), modalOpacity: 0.01 });
    $("#ConfirmCancel").jqxButton({ theme: theme });
    $("#ConfirmDelete").jqxButton({ theme: theme });
    $("#ConfirmDelete").click(function () {
    	removeRequirement({
        	requirementId: $("#requirementId").val(),
		}, 'removeTransferRequirement', 'jqxgrid');
        $("#confirmDeletePopupWindow").jqxWindow('hide');
    });
    $("#ConfirmCancel").click(function () {
    	$("#confirmDeletePopupWindow").jqxWindow('hide');
    });
    $("#jqxgrid").on('rowClick', function (event) {
        if (event.args.rightclick) {
        	var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', event.args.rowindex);
        	<#if isStorekeeper >
        		if ("REQ_CREATED" == dataRecord.statusId){
            		$("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
                    var scrollTop = $(window).scrollTop();
                    var scrollLeft = $(window).scrollLeft();
                    contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
                    return false;
            	} 
        	<#elseif isSpecialist>
	        	if ("REQ_PROPOSED" == dataRecord.statusId){
	        		$("#menuCreateTransfer").hide();
	        		$("#menuAppoveReq").show();
	    	    	$("#menuCancelReq").show();
	        		$("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
	                var scrollTop = $(window).scrollTop();
	                var scrollLeft = $(window).scrollLeft();
	                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
	                return false;
	        	} 
	        	if ("REQ_APPROVED" == dataRecord.statusId){
	        		$("#menuCreateTransfer").show();
	    	    	$("#menuAppoveReq").hide();
	    	    	$("#menuCancelReq").hide();
	        		$("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
	                var scrollTop = $(window).scrollTop();
	                var scrollLeft = $(window).scrollLeft();
	                contextMenu.jqxMenu('open', parseInt(event.args.originalEvent.clientX) + 5 + scrollLeft, parseInt(event.args.originalEvent.clientY) + 5 + scrollTop);
	                return false;
	        	} 
        	</#if>
        }
    });
    
	<#assign listProductStores = delegator.findList("ProductStoreRoleDetail", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", "company", "roleTypeId", "OWNER")), null, null, null, false)>
	var productStoreData = new Array();
	<#list listProductStores as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.storeName?if_exists)/>
		row['productStoreId'] = '${item.productStoreId?if_exists}';
		row['description'] = '${description?if_exists}';
		productStoreData[${item_index}] = row;
	</#list>
	
	var tmpFlag = true;
	var tmpFlag2 = true;
	var facilityFromData = new Array();
	var facilityToData = new Array();
	var originContactMechData = new Array();
	var destContactMechData = new Array();
	var isNull = false;
	var stop = true;
	// create new 
	$("#facilityIdFrom").jqxDropDownList({source: facilityFromData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "facilityId"});
	$("#facilityIdTo").jqxDropDownList({source: facilityToData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "facilityId"});
	$("#productStoreIdFrom").jqxDropDownList({source: productStoreData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "productStoreId"});
	$("#productStoreIdTo").jqxDropDownList({source: productStoreData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "productStoreId"});
	$("#originContactMechId").jqxDropDownList({source: originContactMechData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "contactMechId"});
	$("#destContactMechId").jqxDropDownList({source: destContactMechData, autoDropDownHeight:true, displayMember:"description", selectedIndex: 0, valueMember: "contactMechId"});
	$("#requirementStartDate").jqxDateTimeInput({height: '25px', formatString: 'd'});
	$("#requiredByDate").jqxDateTimeInput({height: '25px', formatString: 'd'});
	$("#estimatedBudget").jqxInput({height: '20px', width: '195px'});
	$("#currencyUomId").jqxDropDownList({source: currencyUomData, autoDropDownHeight:true, displayMember:"description", valueMember: "currencyUomId"});
	$("#currencyUomId").jqxDropDownList('val', 'VND');
	
	$("#productStoreIdTo").change(function(){
		isNull = false;
		updateMultiElement({
        	productStoreIdTo: $(this).val(),
        	productStoreId: $("#productStoreIdFrom").val(),
        	facilityId : $("#facilityIdFrom").val(),
        	facilityIdTo : $("#facilityIdTo").val(),
        	contactMechPurposeTypeIdFrom: "SHIP_ORIG_LOCATION",
			contactMechPurposeTypeIdTo: "SHIPPING_LOCATION"
		}, 'getFacilities' , 'listFacilities', 'listFacilitiesTo', 'listContactMechsFrom', 'listContactMechsTo', 'facilityId', 'facilityName', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'facilityIdFrom', 'facilityIdTo', 'originContactMechId', 'destContactMechId');
	});
	$("#productStoreIdFrom").change(function(){
		isNull = false;
		if ($("#productStoreIdTo").val()){
			updateMultiElement({
				productStoreId: $("#productStoreIdFrom").val(),
				productStoreIdTo: $("#productStoreIdTo").val(),
				facilityId : $("#facilityIdFrom").val(),
				facilityIdTo : $("#facilityIdTo").val(),
				contactMechPurposeTypeIdFrom: "SHIP_ORIG_LOCATION",
				contactMechPurposeTypeIdTo: "SHIPPING_LOCATION"
			}, 'getFacilities' , 'listFacilities', 'listFacilitiesTo', 'listContactMechsFrom', 'listContactMechsTo', 'facilityId', 'facilityName', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'facilityIdFrom', 'facilityIdTo', 'originContactMechId', 'destContactMechId');
		} else {
			updateMultiElement({
	        	productStoreId: $(this).val(),
	        	productStoreIdTo: $("#productStoreIdTo").val(),
	        	facilityId : $("#facilityIdFrom").val(),
	        	facilityIdTo : $("#facilityIdTo").val(),
	        	contactMechPurposeTypeIdFrom: "SHIP_ORIG_LOCATION",
				contactMechPurposeTypeIdTo: "SHIPPING_LOCATION"
			}, 'getFacilities' , 'listFacilities', 'listFacilitiesTo', 'listContactMechsFrom', 'listContactMechsTo', 'facilityId', 'facilityName', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'facilityIdFrom', 'facilityIdTo', 'originContactMechId', 'destContactMechId');
			update({
				facilityId: $("#facilityIdFrom").val(),
				contactMechPurposeTypeId: "SHIP_ORIG_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'originContactMechId');
		}
	});
	$("#facilityIdFrom").on('change', function(event){
		if(tmpFlag){
			tmpFlag = false;
			return;
		}
		isNull = false;
		if ($("#productStoreIdFrom").val() == $("#productStoreIdTo").val()){
			if ($("#facilityIdFrom").val() == $("#facilityIdTo").val()){
				updateFacilityContactMech({
					productStoreId: $("#productStoreIdTo").val(),
		        	facilityIdTo : $("#facilityIdTo").val(),
		        	contactMechPurposeTypeIdFrom: "SHIP_ORIG_LOCATION",
					contactMechPurposeTypeIdTo: "SHIPPING_LOCATION"
				}, 'getDiffFacilities' , 'listFacilities', 'listContactMechsFrom', 'listContactMechsTo', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'facilityIdTo', 'originContactMechId', 'destContactMechId');
				tmpFlag = false;
			} else {
				update({
					facilityId: $("#facilityIdFrom").val(),
					contactMechPurposeTypeId: "SHIP_ORIG_LOCATION",
					}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'originContactMechId');
			}
		} else {
			update({
				facilityId: $("#facilityIdFrom").val(),
				contactMechPurposeTypeId: "SHIP_ORIG_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'originContactMechId');
		}
		var tmpS = $("#jqxgridProduct").jqxGrid('source');
	 	var curFacilityId = $("#facilityIdFrom").val();
	 	tmpS._source.url = "jqxGeneralServicer?sname=getListProducts&facilityId="+curFacilityId;
	 	$("#jqxgridProduct").jqxGrid('source', tmpS);
	});
	$("#facilityIdTo").on('select', function(event){
		isNull = false;
		if(tmpFlag2){
			tmpFlag2 = false;
			return;
		}
		if ($("#productStoreIdFrom").val() == $("#productStoreIdTo").val()){
			if ($("#facilityIdFrom").val() == $("#facilityIdTo").val()){
				updateFacilityContactMech({
					productStoreId: $("#productStoreIdFrom").val(),
		        	facilityIdTo : $("#facilityIdTo").val(),
		        	contactMechPurposeTypeIdFrom: "SHIPPING_LOCATION",
					contactMechPurposeTypeIdTo: "SHIP_ORIG_LOCATION"
				}, 'getDiffFacilities' , 'listFacilities', 'listContactMechsFrom', 'listContactMechsTo', 'facilityId', 'facilityName', 'contactMechId',  'address1', 'contactMechId',  'address1', 'facilityIdFrom', 'destContactMechId', 'originContactMechId');
				tmpFlag2 = false;
			} else {
				update({
					facilityId: $("#facilityIdTo").val(),
					contactMechPurposeTypeId: "SHIPPING_LOCATION",
					}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'destContactMechId');
			}
		} else {
			update({
				facilityId: $("#facilityIdTo").val(),
				contactMechPurposeTypeId: "SHIPPING_LOCATION",
				}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1', 'destContactMechId');
		}
	});
	
	function update(jsonObject, url, data, key, value, id) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	var json = res[data];
	            renderHtml2(json, key, value, id);
	        }
	    });
	}
	function sendRequirement(jsonObject, url, jqxgrid) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	$("#"+jqxgrid).jqxGrid('updatebounddata');
	        }
	    });
	}
	function approveRequirement(jsonObject, url, jqxgrid) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	$("#"+jqxgrid).jqxGrid('updatebounddata');
	        }
	    });
	}
	function createTransfer(jsonObject, url, jqxgrid) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	window.location.href = "<@ofbizUrl>viewTransfer?transferId="+res.transferId+"</@ofbizUrl>";
	        }
	    });
	}
	function removeRequirement(jsonObject, url, jqxgrid) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	$("#"+jqxgrid).jqxGrid('updatebounddata');
	        }
	    });
	}
	function updateFacilityContactMech(jsonObject, url, data1, data2, data3, key1, value1, key2, value2, key3, value3, id1, id2, id3) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	var json1 = res[data1];
	            renderHtml2(json1, key1, value1, id1);
	            var json2 = res[data2];
	            renderHtml2(json2, key2, value2, id2);
	            var json3 = res[data3];
	            renderHtml2(json3, key3, value3, id3);
	        }
	    });
	    tmpFlag = true;
	    tmpFlag2 = true;
	}
	function updateMultiElement(jsonObject, url, data1, data2, data3, data4, key1, value1, key2, value2, key3, value3, key4, value4, id1, id2, id3, id4) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	var json1 = res[data1];
	            renderHtml2(json1, key1, value1, id1);
	            var json2 = res[data2];
	            renderHtml2(json2, key2, value2, id2);
	            var json3 = res[data3];
	            renderHtml2(json3, key3, value3, id3);
	            var json4 = res[data4];
	            renderHtml2(json4, key4, value4, id4);
	            var tmpS = $("#jqxgridProduct").jqxGrid('source');
			 	var curFacilityId = $("#facilityIdFrom").val();
			 	tmpS._source.url = "jqxGeneralServicer?sname=getListProducts&facilityId="+curFacilityId;
			 	$("#jqxgridProduct").jqxGrid('source', tmpS);
	        }
	    });
	}
	function renderHtml2(data, key, value, id){
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
</script>
<@jqGrid selectionmode="checkbox" idExisted="true" filtersimplemode="true" width="930" viewSize="5" pagesizeoptions="['5', '10', '15', '20', '25', '30', '50', '100']" id="jqxgridProduct" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="false" addrow="false" filterable="true" editable="true" 
	 url="jqxGeneralServicer?sname=getListProducts&facilityId=" editmode="click" bindresize="false" jqGridMinimumLibEnable="false" otherParams="qtyUomIds:S-getProductPackingUoms(productId)<listPackingUoms>" offmode="true"/>