<style type="text/css">
	#horizontalScrollBarjqxContactMechGrid {
	  	visibility: inherit !important;
	}
	.jqx-window-olbius .jqx-window-content table tr td button.jqx-button, 
	.jqx-window-olbius .jqx-window-content table tr td input.jqx-button[type="button"], 
	.jqx-window-olbius .jqx-window-content table tr td input.jqx-button[type="submit"]{
		padding: 7px 13px;
	}
</style>
<script type="text/javascript">
	<#assign statusList = delegator.findByAnd("StatusItem", {"statusTypeId" : "RETURNCOM_REQ_STATUS"}, null, false) />
	var statusData = new Array();
	<#list statusList as statusItem>
		<#assign description = StringUtil.wrapString(statusItem.get("description", locale)) />
		var row = {};
		row['statusId'] = '${statusItem.statusId}';
		row['description'] = "${description}";
		statusData[${statusItem_index}] = row;
	</#list>
	
	<#assign reasonList = delegator.findByAnd("ReturnReason", null, null, false) />
	var reasonData = new Array();
	<#list reasonList as reasonItem>
		<#assign description = StringUtil.wrapString(reasonItem.get("description", locale)) />
		var row = {};
		row['reasonId'] = '${reasonItem.returnReasonId}';
		row['description'] = "${description}";
		reasonData[${reasonItem_index}] = row;
	</#list>
</script>
<#assign uomList = delegator.findByAnd("Uom", {"uomTypeId" : "PRODUCT_PACKING"}, null, false)/>
<script type="text/javascript">
	var uomData = new Array();
	<#list uomList as uomItem>
		<#assign description = StringUtil.wrapString(uomItem.get("description", locale)) />
		var row = {};
		row['uomId'] = '${uomItem.uomId}';
		row['description'] = "${description?default('')}";
		uomData[${uomItem_index}] = row;
	</#list>
</script>
<#assign columnlist="{text: '${uiLabelMap.requirementId}', dataField: 'requirementId', width: 150,
						cellsrenderer: function(row, colum, value) {
                        	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                        	return \"<span><a href='/delys/control/viewReturnProductReq?requirementId=\" + data.requirementId + \"'>\" + data.requirementId + \"</a></span>\";
                        }
					},
				 	{text: '${uiLabelMap.Status}', dataField: 'statusId', width: 150, filtertype: 'checkedlist', 
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						}, 
					 	createfilterwidget: function (column, columnElement, widget) {
							var filterDataAdapter = new $.jqx.dataAdapter(statusData, {
								autoBind: true
							});
							var records = filterDataAdapter.records;
							records.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
							widget.jqxDropDownList({source: records, displayMember: 'statusId', valueMember: 'statusId',
								renderer: function(index, label, value){
									for(var i = 0; i < statusData.length; i++){
										if(statusData[i].statusId == value){
											return '<span>' + statusData[i].description + '</span>';
										}
									}
									return value;
								}
							});
							widget.jqxDropDownList('checkAll');
			   			}
				 	},
				 	{text: '${uiLabelMap.DACreatedDate}', dataField: 'createdDate', width: 150, cellsformat: 'd', filtertype: 'range'},
				 	{text: '${uiLabelMap.Requestor}', dataField: 'createdByUserLogin', width: 150},
				 	{text: '${uiLabelMap.DAContactMechId}', dataField: 'contactMechId', width: 150},
				 	{text: '${uiLabelMap.DADescription}', dataField: 'description', width: 150},
				 	{text: '${uiLabelMap.DARequirementStartDateOrigin}', dataField: 'requirementStartDate', width: 150, cellsformat: 'd', filtertype: 'range'},
				 	{text: '${uiLabelMap.DARequiredByDateOrigin}', dataField: 'requiredByDate', width: 150, cellsformat: 'd', filtertype: 'range'},
				 	{text: '${uiLabelMap.DAReason}', dataField: 'reason', width: 150, filtertype: 'checkedlist', 
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < reasonData.length; i++){
								if(reasonData[i].reasonId == value){
									return '<span title=' + value + '>' + reasonData[i].description + '</span>'
								}
							}
						}, 
					 	createfilterwidget: function (column, columnElement, widget) {
							var filterDataAdapter = new $.jqx.dataAdapter(reasonData, {
								autoBind: true
							});
							var records = filterDataAdapter.records;
							records.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
							widget.jqxDropDownList({source: records, displayMember: 'reasonId', valueMember: 'reasonId',
								renderer: function(index, label, value){
									for(var i = 0; i < reasonData.length; i++){
										if(reasonData[i].reasonId == value){
											return '<span>' + reasonData[i].description + '</span>';
										}
									}
									return value;
								}
							});
							widget.jqxDropDownList('checkAll');
			   			}
		   			},
				 "/>
<#--
{text: '${uiLabelMap.DAFacilityId}', dataField: 'facilityId', width: 150},
-->
<#assign dataField="[{ name: 'requirementId', type: 'string'},
					{name: 'facilityId', type: 'string'},
	             	{name: 'productStoreId', type: 'string'},
	             	{name: 'contactMechId', type: 'string'},
	             	{name: 'deliverableId', type: 'string'},
					{name: 'fixedAssetId', type: 'string'},
	             	{name: 'productId', type: 'string'},
	             	{name: 'statusId', type: 'string'},
	             	{name: 'description', type: 'string'},
	             	{name: 'createdDate', type: 'date', other: 'Timestamp'},
	             	{name: 'requirementStartDate', type: 'date', other: 'Timestamp'},
	             	{name: 'requiredByDate', type: 'date', other: 'Timestamp'},
					{name: 'estimatedBudget', type: 'string'},
					{name: 'currencyUomId', type: 'string'},
					{name: 'quantity', type: 'string'},
					{name: 'useCase', type: 'string'},
					{name: 'reason', type: 'string'},
					{name: 'createdByUserLogin', type: 'string'},
	 		 	]"/>
<#--
<@jqGrid contextMenuId="Menu" filtersimplemode="true" id="jqxgrid" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" 
		showtoolbar="true" addrow="true" filterable="true" alternativeAddPopup="alterpopupWindow" editable="false" 
		 url="jqxGeneralServicer?sname=JQGetListRequirement&requirementTypeId=RETURN_PRODCOM_REQ" 
		 createUrl="jqxGeneralServicer?sname=createTransferRequirement&jqaction=C" updateUrl="jqxGeneralServicer?sname=updateTransferRequirement&jqaction=U"
		 addColumns="productStoreIdFrom;currencyUomId;reason;description;productStoreIdTo;facilityIdFrom;facilityIdTo;requirementStartDate(java.sql.Timestamp);requiredByDate(java.sql.Timestamp);originContactMechId;destContactMechId;listProducts(java.util.List);requirementTypeId[TRANSFER_REQ];estimatedBudget" 
		 />
-->
<#assign tmpCreateUrl = ""/>
<#if security.hasPermission("REREQCOM_ROLE_UPDATE", session)>
	<#assign tmpCreateUrl = "fa fa-bolt@${uiLabelMap.DAApprove}@updateReturnProductReqCom"/>
</#if>
<#assign tmpProposeUrl = ""/>
<#if isSalesAdmin && security.hasPermission("REREQCOM_ROLE_UPDATE", session)>
	<#assign tmpProposeUrl = "fa fa-truck@${uiLabelMap.DATransferRequirement}@proposeReturnProductReqCom"/>
</#if>
<#assign hasPermissionCreate = false/>
<#--<#assign company = Static['org.ofbiz.entity.util.EntityUtilProperties'].getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator)/>
<#assign userLoginRel = delegator.findByAnd("PartyRelationship", {"partyIdFrom" : company, "partyIdTo" : userLogin.partyId, "roleTypeIdFrom" : "INTERNAL_ORGANIZATIO", "roleTypeIdTo" : "DELYS_DISTRIBUTOR"})/>
userLoginRel?exists && (userLoginRel?length &gt; 0)
-->

<#if security.hasPermission("RETURNREQ_ROLE_CREATE", session)>
	<#assign isSupRel = Static['com.olbius.delys.util.SecurityUtil'].hasRole("MANAGER", userLogin.getString("partyId"), delegator)>
	<#assign isSupRole = delegator.findOne("PartyRole", {"partyId" : userLogin.get("partyId"), "roleTypeId" : "DELYS_SALESSUP_GT"}, true)!/>
	<#if isSupRel && isSupRole?has_content>
		<#assign hasPermissionCreate = true/>
	</#if>
</#if>
<@jqGrid url="jqxGeneralServicer?sname=JQGetListRequirementSentToCompany&requirementTypeId=RETURN_PRODCOM_REQ" dataField=dataField columnlist=columnlist filterable="true" clearfilteringbutton="true"
		 showtoolbar="true" alternativeAddPopup="alterpopupWindow" filtersimplemode="true" addType="popup" deleterow="false"
		 createUrl="jqxGeneralServicer?sname=createReturnRequirementToCompany&jqaction=C" addrow="${hasPermissionCreate?string}" 
		 addColumns="contactMechId;companyId;description;distributorId;listProducts(java.util.List);reason;requirementStartDate(java.sql.Timestamp);requiredByDate(java.sql.Timestamp);requirementTypeId[RETURN_PRODCOM_REQ];" 
		 mouseRightMenu="true" contextMenuId="contextMenu" customcontrol1=tmpCreateUrl customcontrol2=tmpProposeUrl 
		 />
<div id='contextMenu' style="display:none">
	<ul>
	    <li><i class="icon-refresh open-sans"></i>${StringUtil.wrapString(uiLabelMap.DARefresh)}</li>
	    <li><i class="fa fa-search"></i>${StringUtil.wrapString(uiLabelMap.DAViewDetail)}</li>
	</ul>
</div>

<#if hasPermissionCreate>
<#assign companyId = Static['org.ofbiz.entity.util.EntityUtilProperties'].getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator)>
<div id="alterpopupWindow" style="display:none">
	<div>${uiLabelMap.accCreateNew}</div>
		<div style="overflow: hidden;">
		<table>
			<input type="hidden" name="requirementTypeId" value="RETURN_PRODCOM_REQ"></input>
			<tr>
				<td align="right" class="required">${uiLabelMap.DACompanyId}</td>
				<td align="left">
			       	<span><input type="text" id="companyIdAdd" value="${companyId?if_exists}" readonly="true" style="height: 25px;padding: 0px 5px;width: 205px;margin-bottom: 0px;"/></span>
			    </td>
			   
			   	<td align="right">${uiLabelMap.DARequirementStartDateOrigin}</td>
				<td align="left">
			       <div id="requirementStartDateAdd"></div>
			    </td>
			</tr>
			<tr>
				<td align="right" class="required">${uiLabelMap.DADistributor}</td>
				<td align="left">
			       	<div id="distributorIdAdd">
			       		<div id="jqxDistributorGrid"/>
			       	</div>
			    </td>
			   
			   	<td align="right">${uiLabelMap.DARequiredByDateOrigin}</td>
				<td align="left">
			       	<div id="requiredByDateAdd"></div>
			    </td>
			</tr>
			<tr>
				<td align="right" class="required">${uiLabelMap.DAAddress}</td>
				<td align="left">
			       	<div id="contactMechIdAdd">
			       		<div id="jqxContactMechGrid"/>
			       	</div>
			    </td>
			   
			   	<td align="right">${uiLabelMap.DAReason}</td>
				<td align="left">
			       <div id="reasonValueAdd"></div>
			    </td>
			</tr>
			<tr>
				<td align="right">${uiLabelMap.DADescription}</td>
				<td align="left">
					<textarea id="descriptionValueAdd" rows="2"></textarea>
				</td>
				
				<td align="right"></td>
				<td align="left"></td>
			</tr>
		    <tr>
			    <td colspan="4">
		    		<div style="overflow:hidden;overflow-y:visible; max-height:300px !important; width:930px">
		    			<div id="jqxgridProduct"></div>
		    		</div>
				</td>
		    </tr>
		    <tr>
		        <td align="right" colspan="3" style="min-width:540px; max-width:540px">
		        	<input type="button" id="jqxButtonAddNewRow" value="${uiLabelMap.DAAddNewRow}" style="display:inline-block; margin-right: 15px"/>
		        	<input type="button" id="alterSave" value="${uiLabelMap.CommonSave}" style="display:inline-block"/>
		        </td>
		        <td align="left"><input style="margin-right: 5px;" id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
	    </tr>
		</table>
	</div>
</div>
<div id="alterpopupWindowAddNewRow" style="display:none">
	<div>${uiLabelMap.DAAddNewRow}</div>
	<div style="overflow: hidden;">
		<table>
			<input type="hidden" id="productNameAdd2" value=""/>
			<tr>
				<td align="right" class="required">${uiLabelMap.DAProduct}</td>
				<td align="left">
			       	<div id="productIdAdd2">
			       	 	<div id="jqxgridProductGrid2"></div>
			       	</div>
			    </td>
			   
			   	<td align="right" class="required">${uiLabelMap.DAExpireDate}</td>
				<td align="left">
			       	<div id="expireDateAdd2"></div>
			    </td>
			</tr>
			<tr>
				<td align="right" class="required">${uiLabelMap.DAUom}</td>
				<td align="left">
			       	<div id="quantityUomIdAdd2">
			       	</div>
			    </td>
			   
			   	<td align="right" class="required">${uiLabelMap.DAQuantity}</td>
				<td align="left">
			       <input type="text" id="quantityAdd2" value="" style="height: 25px;padding: 0px 5px;width: 198px;margin-bottom: 0px;"/>
			    </td>
			</tr>
			<tr>
				<td align="right"></td>
				<td align="left"></td>
			   	<td align="right"><input type="button" id="alterSave2" value="${uiLabelMap.CommonSave}" style="display:inline-block"/></td>
				<td align="left"><input id="alterCancel2" type="button" value="${uiLabelMap.CommonCancel}"/></td>
			</tr>
		</table>
	</div>
</div>
</#if>
<#--<div id="dialog-message" title="${StringUtil.wrapString(uiLabelMap.DAYouNotYetChooseProduct)}!" style="display:none">-->
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script type="text/javascript" src="/aceadmin/assets/js/bootbox.min.js"></script>
<script type="text/javascript">
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	$("#contextMenu").jqxMenu({ width: 200, autoOpenPopup: false, mode: 'popup', theme: theme});
	$("#contextMenu").on('itemclick', function (event) {
		var args = event.args;
        var rowindex = $("#jqxgrid").jqxGrid('getselectedrowindex');
        var tmpKey = $.trim($(args).text());
        if (tmpKey == "${StringUtil.wrapString(uiLabelMap.DARefresh)}") {
        	$("#jqxgrid").jqxGrid('updatebounddata');
        } else if (tmpKey == "${StringUtil.wrapString(uiLabelMap.DAViewDetail)}") {
        	var data = $("#jqxgrid").jqxGrid("getrowdata", rowindex);
			if (data != undefined && data != null) {
				var requirementId = data.requirementId;
				var url = 'viewReturnProductReq?requirementId=' + requirementId;
				var win = window.open(url, '_blank');
				win.focus();
			}
        }
	});
</script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/globalization/globalize.culture.vi-VN.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcombobox.js"></script>
<script type="text/javascript">
	<#if hasPermissionCreate>
	// Create Window
	$("#alterpopupWindow").jqxWindow({
		maxWidth: 1500, minWidth: 950, minHeight: 580, maxHeight: 1200, resizable: true, isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
	});
	$("#alterpopupWindowAddNewRow").jqxWindow({
		minWidth: 820, maxWidth: 1200, minHeight: 400, maxHeight: 600, resizable: true, isModal: true, autoOpen: false, cancelButton: $("#alterCancel2"), modalOpacity: 0.7, theme:theme           
	});
	
	$("#requirementStartDateAdd").jqxDateTimeInput({height: '25px',width: 200, formatString: 'dd-MM-yyyy HH:mm:ss', culture: 'vi-VN'});
	$("#requiredByDateAdd").jqxDateTimeInput({height: '25px',width: 200, formatString: 'dd-MM-yyyy HH:mm:ss', allowNullDate: true, value: null, culture: 'vi-VN'});
	
	<#assign returnReasons = delegator.findByAnd("ReturnReason", null, ["sequenceId"], false)/>
	var dataReason = new Array();
	var reasonSelectedIndex = 0;
	<#if returnReasons?exists>
		<#list returnReasons as returnReason>
			var mapItem = {};
			<#if returnReason.returnReasonId == "RTN_NORMAL_RETURN">reasonSelectedIndex = ${returnReason_index}</#if>
			<#assign description = StringUtil.wrapString(returnReason.get("description", locale))/>
			mapItem.returnReasonId = "${returnReason.returnReasonId}";
			mapItem.description = "${description}";
			dataReason[${returnReason_index}] = mapItem;
		</#list>
	</#if>
	// var sourceReason = ["${StringUtil.wrapString(uiLabelMap.DACollectionProductIsAboutToExpire)}", "${StringUtil.wrapString(uiLabelMap.DAConsumptionDifficultProduct)}", "${StringUtil.wrapString(uiLabelMap.DAOther)}"];
    // Create a jqxDropDownList
	// $("#reasonValueAdd").jqxDropDownList({source: sourceReason, width: '200', placeHolder: "${uiLabelMap.DASelectAReason}:"});
	var sourceReason = {
        localdata: dataReason,
        datatype: "array"
    };
    var dataReasonAdapter = new $.jqx.dataAdapter(sourceReason);
    $('#reasonValueAdd').jqxDropDownList({selectedIndex: reasonSelectedIndex, source: dataReasonAdapter, displayMember: "description", valueMember: "returnReasonId", width: 200});
		
	$("#alterSave").jqxButton({width: 100, theme: theme});
	$("#alterCancel").jqxButton({width: 100, theme: theme});
	$("#jqxButtonAddNewRow").jqxButton({ width: '150', theme: theme});
	$("#alterCancel2").jqxButton({width: 100, theme: theme});
	$("#alterSave2").jqxButton({width: 100, theme: theme});
	
	$("#jqxButtonAddNewRow").on('click', function () {
		$('#alterpopupWindowAddNewRow').jqxWindow('open');
    });
	
	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		if(!$('#alterpopupWindow').jqxValidator('validate')) return false;
		var row;
		var selectedIndexs = $('#jqxgridProduct').jqxGrid('getselectedrowindexes');
		var listProducts = new Array();
		for(var i = 0; i < selectedIndexs.length; i++){
			var data = $('#jqxgridProduct').jqxGrid('getrowdata', selectedIndexs[i]);
			var map = {};
			map['productId'] = data.productId;
			map['quantity'] = data.quantity;
			map['quantityUomId'] = data.quantityUomId;
			map['expireDate'] = (new Date(data.expireDate)).getTime();
			listProducts[i] = map;
		}
		if (listProducts == null || listProducts.length <= 0) {
			<#--
			$("#dialog-message").text("${StringUtil.wrapString(uiLabelMap.DAYouNotYetChooseProduct)}!" );
			$("#dialog-message").dialog({
		      	resizable: false,
		      	height:180,
		      	modal: true,
		      	buttons: {
		        	"${StringUtil.wrapString(uiLabelMap.wgcancel)}": function() {
		          		$(this).dialog("close");
		        	}
		      	}
			});
			-->
			bootbox.dialog("${uiLabelMap.DAYouNotYetChooseProduct}!", [{
				"label" : "OK",
				"class" : "btn-small btn-primary",
				}]
			);
			return false;
		}
		listProducts = JSON.stringify(listProducts);
		var today = new Date();
		row = {	companyId: $('#companyIdAdd').val(),
				createdByUserLogin: '${userLogin.userLoginId}',
				statusId: 'REREQCOM_CREATED',
				createdDate: today,
				distributorId: $('#distributorIdAdd').val(),
				contactMechId:$('#contactMechIdAdd').val(),
				description:$('#descriptionValueAdd').val(),
				requirementStartDate:$('#requirementStartDateAdd').val(),
				requiredByDate:$('#requiredByDateAdd').val(),
				reason:$('#reasonValueAdd').val(),
				listProducts:listProducts
	  	};
		$("#jqxgrid").jqxGrid('addRow', null, row, "first");
		$("#jqxgrid").jqxGrid('updatebounddata');
    	$("#alterpopupWindow").jqxWindow('close');
	});
	
	$('#alterpopupWindow').jqxValidator({
		rules: [
			{input: '#companyIdAdd', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
				function (input, commit) {
					if($('#companyIdAdd').val() == null || $('#companyIdAdd').val() == ''){
						return false;
					}
					return true;
				}
			},
			{input: '#distributorIdAdd', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
				function (input, commit) {
					if($('#distributorIdAdd').val() == null || $('#distributorIdAdd').val() == ''){
						return false;
					}
					return true;
				}
			},
			{input: '#contactMechIdAdd', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
				function (input, commit) {
					if($('#contactMechIdAdd').val() == null || $('#contactMechIdAdd').val() == ''){
						return false;
					}
					return true;
				}
			},
			{input: '#reasonValueAdd', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule:
				function (input, commit) {
					if($('#reasonValueAdd').val() == null || $('#reasonValueAdd').val() == ''){
						return false;
					}
					return true;
				}
			}
		]
	});
	// ====================================== jqx window 2 =====================================================
	$("#expireDateAdd2").jqxDateTimeInput({width: '208px', height: '25px', allowNullDate: true, value: null, formatString: 'dd/MM/yyyy'});
	
	// Product 2 JQX Dropdown
    var sourceP2 = {
        datafields:[{name: 'productId', type: 'string'},
            		{name: 'internalName', type: 'string'},
            		{name: 'productName', type: 'string'},
            		{name: 'productTypeId', type: 'string'}
    			],
        cache: false,
        root: 'results',
        datatype: "json",
        updaterow: function (rowid, rowdata) {
            // synchronize with the server - send update command   
        },
        beforeprocessing: function (data) {
            sourceP2.totalrecords = data.TotalRows;
        },
        filter: function () {
            // update the grid and send a request to the server.
            $("#jqxgridProductGrid2").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridProductGrid2").jqxGrid('updatebounddata');
        },
        sortcolumn: 'productId',
		sortdirection: 'asc',
        type: 'POST',
        data: {
	        noConditionFind: 'Y',
	        conditionsFind: 'N',
	    },
	    pagesize:5,
        contentType: 'application/x-www-form-urlencoded',
        url: 'jqxGeneralServicer?sname=JQGetListProductSalesOnlyProduct',
    };
    var dataAdapterP2 = new $.jqx.dataAdapter(sourceP2,
    {
    	autoBind: true,
    	formatData: function (data) {
	    	if (data.filterscount) {
                var filterListFields = "";
                for (var i = 0; i < data.filterscount; i++) {
                    var filterValue = data["filtervalue" + i];
                    var filterCondition = data["filtercondition" + i];
                    var filterDataField = data["filterdatafield" + i];
                    var filterOperator = data["filteroperator" + i];
                    filterListFields += "|OLBIUS|" + filterDataField;
                    filterListFields += "|SUIBLO|" + filterValue;
                    filterListFields += "|SUIBLO|" + filterCondition;
                    filterListFields += "|SUIBLO|" + filterOperator;
                }
                data.filterListFields = filterListFields;
            }
            return data;
        },
        loadError: function (xhr, status, error) {
            alert(error);
        },
        downloadComplete: function (data, status, xhr) {
                if (!sourceP2.totalRecords) {
                    sourceP2.totalRecords = parseInt(data["odata.count"]);
                }
        }, 
        beforeLoadComplete: function (records) {
        	for (var i = 0; i < records.length; i++) {
        		if(typeof(records[i])=="object"){
        			for(var key in records[i]) {
        				var value = records[i][key];
        				if(value != null && typeof(value) == "object" && typeof(value) != null){
        					//var date = new Date(records[i][key]["time"]);
        					//records[i][key] = date;
        				}
        			}
        		}
        	}
        }
    });
    $("#productIdAdd2").jqxDropDownButton({ theme: theme, width: 200, height: 25});
    $("#jqxgridProductGrid2").jqxGrid({
    	width:610,
        source: dataAdapterP2,
        filterable: true,
        showfilterrow: true,
        virtualmode: true, 
        sortable:true,
        theme: theme,
        editable: false,
        autoheight:true,
        pageable: true,
        rendergridrows: function(obj){
			return obj.data;
		},
        columns: [{text: '${uiLabelMap.DAProductId}', datafield: 'productId', width:'180px'},
          			{text: '${uiLabelMap.DAInternalName}', datafield: 'internalName', width:'250px'},
          			{text: '${uiLabelMap.DAProductTypeId}', datafield: 'productTypeId', width:'180px'}
        		]
    });
    
    $("#jqxgridProductGrid2").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxgridProductGrid2").jqxGrid('getrowdata', args.rowindex);
        console.log(row);
        var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['productId'] +'</div>';
        $('#productIdAdd2').jqxDropDownButton('setContent', dropDownContent);
        $('#productNameAdd2').val(row['internalName']);
        console.log($('#productNameAdd2').val());
        var productId = $("#productIdAdd2").val();
        var tmpQuantityUom = $("#quantityUomIdAdd2").jqxComboBox('source');
	 	tmpQuantityUom._source.url = "getListQuantityUomByProduct";
	 	tmpQuantityUom._source.data = {'productId' : productId};
	 	$("#quantityUomIdAdd2").jqxComboBox('source', tmpQuantityUom);
    });
	
	var sourceQuantityUom2 = {
		datatype: "json",
        datafields: [
            { name: 'uomId' },
            { name: 'description' }
        ],
        data: {},
        type: "POST",
        root: "listQuantityUom",
        contentType: 'application/x-www-form-urlencoded',
        url: "getListQuantityUomByProduct"
    };
    <#--datatype: "json",
        datafields: [
            { name: 'partyId' },
            { name: 'groupName' }
        ],
        type: "POST",
        root: "listParties",
        contentType: 'application/x-www-form-urlencoded',
        url: "facilityOwnerableList"-->
    var dataAdapterQuantityUom2 = new $.jqx.dataAdapter(sourceQuantityUom2, {
            formatData: function (data) {
                if ($("#quantityUomIdAdd2").jqxComboBox('searchString') != undefined) {
                    data.searchKey = $("#quantityUomIdAdd2").jqxComboBox('searchString');
                    return data;
                }
            }
        }
    );
    $("#quantityUomIdAdd2").jqxComboBox({
        width: 200,
        placeHolder: " ${StringUtil.wrapString(uiLabelMap.DAChooseAQuantityUom)}",
        dropDownWidth: 200,
        height: 25,
        source: dataAdapterQuantityUom2,
        remoteAutoComplete: false,
        autoDropDownHeight: false,               
        displayMember: "uomId",
        valueMember: "uomId",
        renderer: function (index, label, value) {
            var item = dataAdapterQuantityUom2.records[index];
            if (item != null) {
                var label = item.description + " [" + item.uomId + "]";
                return label;
            }
            return "";
        },
        renderSelectedItem: function(index, item)
        {
            var item = dataAdapterQuantityUom2.records[index];
            if (item != null) {
                var label = item.uomId;
                return label;
            }
            return "";
        },
        search: function (searchString) {
            dataAdapterQuantityUom2.dataBind();
        }
    });
    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave2").click(function () {
    	if($('#alterpopupWindowAddNewRow').jqxValidator('validate')){
	    	var row;
	        row = { productId:$('#productIdAdd2').val(),
	        		internalName:$('#productNameAdd2').val(),
	        		quantityUomId:$('#quantityUomIdAdd2').val(),
	        		quantity:$('#quantityAdd2').val(),
	        		expireDate: new Date($('#expireDateAdd2').val())
	        	  };
		   	$("#jqxgridProduct").jqxGrid('addRow', null, row, "first");
	        // select the first row and clear the selection.
	        $("#jqxgridProduct").jqxGrid('clearSelection');                        
	        $("#jqxgridProduct").jqxGrid('selectRow', 0);  
	        $("#alterpopupWindowAddNewRow").jqxWindow('close');
	        
	        // reset value on window
			$('#productIdAdd2').val("");
			$('#productNameAdd2').val("");
			$('#quantityUomId').val("");
			$('#quantity').val("");
			$('#expireDate').val("");
			$("#jqxgridProductGrid2").jqxGrid('clearSelection');
        }else{
        	return;
        }
    });
    //$("#quantityUomIdAdd2").jqxComboBox('selectItem', 'VND');
    $('#alterpopupWindowAddNewRow').jqxValidator({
		rules: [
			{input: '#productIdAdd2', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
				function (input, commit) {
					if($('#productIdAdd2').val() == null || $('#productIdAdd2').val() == ''){
						return false;
					}
					return true;
				}
			},
			{input: '#quantityUomIdAdd2', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
				function (input, commit) {
					if($('#quantityUomIdAdd2').val() == null || $('#quantityUomIdAdd2').val() == ''){
						return false;
					}
					return true;
				}
			},
			{input: '#expireDateAdd2', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
				function (input, commit) {
					if($('#expireDateAdd2').val() == null || $('#expireDateAdd2').val() == ''){
						return false;
					}
					return true;
				}
			},
			{input: '#quantityAdd2', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule:
				function (input, commit) {
					if($('#quantityAdd2').val() == null || $('#quantityAdd2').val() == ''){
						return false;
					}
					return true;
				}
			}
		]
	});
	// ==========================================================================================================
    // List distributor by customer
	var sourceDIS = {datafields: [
						      {name: 'partyId', type: 'string'},
						      {name: 'partyTypeId', type: 'string'},
						      {name: 'groupName', type: 'string'},
						      {name: 'lastName', type: 'string'},
						      {name: 'firstName', type: 'string'},
						    ],
				cache: false,
				root: 'results',
				datatype: "json",
				updaterow: function (rowid, rowdata) {
					// synchronize with the server - send update command   
				},
				beforeprocessing: function (data) {
				    sourceDIS.totalrecords = data.TotalRows;
				},
				filter: function () {
				   // update the grid and send a request to the server.
				   $("#jqxDistributorGrid").jqxGrid('updatebounddata');
				},
				pager: function (pagenum, pagesize, oldpagenum) {
				  // callback called when a page or page size is changed.
				},
				sort: function () {
				  $("#jqxDistributorGrid").jqxGrid('updatebounddata');
				},
				sortcolumn: 'partyId',
               	sortdirection: 'asc',
				type: 'POST',
				data: {
					noConditionFind: 'Y',
					conditionsFind: 'N',
				},
				pagesize:5,
				contentType: 'application/x-www-form-urlencoded',
				url: 'jqxGeneralServicer?sname=JQGetListDistributorBySupervisor',
			};
			
    var dataAdapterDIS = new $.jqx.dataAdapter(sourceDIS, {
    			autoBind: true,
    			formatData: function (data) {
		    		if (data.filterscount) {
		                var filterListFields = "";
		                for (var i = 0; i < data.filterscount; i++) {
		                    var filterValue = data["filtervalue" + i];
		                    var filterCondition = data["filtercondition" + i];
		                    var filterDataField = data["filterdatafield" + i];
		                    var filterOperator = data["filteroperator" + i];
		                    filterListFields += "|OLBIUS|" + filterDataField;
		                    filterListFields += "|SUIBLO|" + filterValue;
		                    filterListFields += "|SUIBLO|" + filterCondition;
		                    filterListFields += "|SUIBLO|" + filterOperator;
		                }
		                data.filterListFields = filterListFields;
		            }
		            return data;
        		},
		        loadError: function (xhr, status, error) {
		            alert(error);
		        },
		        downloadComplete: function (data, status, xhr) {
	                if (!sourceDIS.totalRecords) {
	                    sourceDIS.totalRecords = parseInt(data['odata.count']);
	                }
		        }
    });
    
	$("#distributorIdAdd").jqxDropDownButton({width: 215, height: 25});
	$("#jqxDistributorGrid").jqxGrid({
		width:600,
		source: dataAdapterDIS,
		filterable: true,
		virtualmode: true, 
		showfilterrow: true,
		sortable:true,
		editable: false,
		autoheight:true,
		columnsresize: true,
		pageable: true,
		rendergridrows: function(obj) {	
			return obj.data;
		},
		columns: [{text: '${uiLabelMap.accPartyId}', datafield: 'partyId', width:'25%'},
				{text: '${uiLabelMap.accGroupName}', datafield: 'groupName', width:'35%'},
				{text: '${uiLabelMap.accFirstName}', datafield: 'lastName', width:'20%'},
				{text: '${uiLabelMap.accLastName}', datafield: 'firstName', width:'20%'},
		]
	});
	//{text: '${uiLabelMap.accPartyTypeId}', datafield: 'partyTypeId', width:'10%'},
	$("#jqxDistributorGrid").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxDistributorGrid").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['partyId'] + '</div>';
        $("#distributorIdAdd").jqxDropDownButton('setContent', dropDownContent);
        
        var distributorId = $("#distributorIdAdd").val();
        var tmpAddress = $("#jqxContactMechGrid").jqxGrid('source');
	 	tmpAddress._source.url = "jqxGeneralServicer?sname=JQGetPartyPostalAddresses&partyId="+distributorId;
	 	$("#jqxContactMechGrid").jqxGrid('source', tmpAddress);
    });
    
    // List address by customer
	var sourceADDR = {datafields: [
						      {name: 'contactMechId', type: 'string'},
						      {name: 'address1', type: 'string'},
						      {name: 'address2', type: 'string'},
						      {name: 'directions', type: 'string'},
						      {name: 'city', type: 'string'},
						      {name: 'postalCode', type: 'string'},
						      {name: 'stateProvinceGeoId', type: 'string'},
						      {name: 'countyGeoId', type: 'string'},
						      {name: 'countryGeoId', type: 'string'},
						      {name: 'contactMechPurposeTypeId', type: 'string'},
						    ],
				cache: false,
				root: 'results',
				datatype: "json",
				updaterow: function (rowid, rowdata) {
					// synchronize with the server - send update command   
				},
				beforeprocessing: function (data) {
				    sourceDIS.totalrecords = data.TotalRows;
				},
				filter: function () {
				   // update the grid and send a request to the server.
				   $("#jqxDistributorGrid").jqxGrid('updatebounddata');
				},
				pager: function (pagenum, pagesize, oldpagenum) {
				  // callback called when a page or page size is changed.
				},
				sort: function () {
				  $("#jqxDistributorGrid").jqxGrid('updatebounddata');
				},
				sortcolumn: 'partyId',
               	sortdirection: 'asc',
				type: 'POST',
				data: {
					noConditionFind: 'Y',
					conditionsFind: 'N',
				},
				pagesize:5,
				contentType: 'application/x-www-form-urlencoded',
				url: 'jqxGeneralServicer?sname=JQGetPartyPostalAddresses',
			};
			
    var dataAdapterADDR = new $.jqx.dataAdapter(sourceADDR, {
    			autoBind: true,
    			formatData: function (data) {
		    		if (data.filterscount) {
		                var filterListFields = "";
		                for (var i = 0; i < data.filterscount; i++) {
		                    var filterValue = data["filtervalue" + i];
		                    var filterCondition = data["filtercondition" + i];
		                    var filterDataField = data["filterdatafield" + i];
		                    var filterOperator = data["filteroperator" + i];
		                    filterListFields += "|OLBIUS|" + filterDataField;
		                    filterListFields += "|SUIBLO|" + filterValue;
		                    filterListFields += "|SUIBLO|" + filterCondition;
		                    filterListFields += "|SUIBLO|" + filterOperator;
		                }
		                data.filterListFields = filterListFields;
		            }
		            return data;
        		},
		        loadError: function (xhr, status, error) {
		            alert(error);
		        },
		        downloadComplete: function (data, status, xhr) {
	                if (!sourceDIS.totalRecords) {
	                    sourceADDR.totalRecords = parseInt(data['odata.count']);
	                }
		        }
    });
    
	$("#contactMechIdAdd").jqxDropDownButton({width: 215, height: 25});
	$("#jqxContactMechGrid").jqxGrid({
		width:700,
		source: dataAdapterADDR,
		filterable: true,
		virtualmode: true, 
		showfilterrow: true,
		sortable:true,
		editable: false,
		autoheight:true,
		columnsresize: true,
		pageable: true,
		rendergridrows: function(obj) {	
			return obj.data;
		},
		columns: [{text: '${uiLabelMap.DAContactMechId}', datafield: 'contactMechId', width:'150px'},
				{text: '${uiLabelMap.DAAddress1}', datafield: 'address1', width:'150px'},
				{text: '${uiLabelMap.DAAddress2}', datafield: 'address2', width:'150px'},
				{text: '${uiLabelMap.DADirections}', datafield: 'directions', width:'100px'},
				{text: '${uiLabelMap.DACity}', datafield: 'city', width:'100px'},
				{text: '${uiLabelMap.DAPostalCode}', datafield: 'postalCode', width:'100px'},
				{text: '${uiLabelMap.DAStateProvinceGeoId}', datafield: 'stateProvinceGeoId', width:'100px'},
				{text: '${uiLabelMap.DACountyGeoId}', datafield: 'countyGeoId', width:'100px'},
				{text: '${uiLabelMap.DACountryGeoId}', datafield: 'countryGeoId', width:'100px'},
				{text: '${uiLabelMap.DAContactMechPurposeTypeId}', datafield: 'contactMechPurposeTypeId', width:'200px'},
		]
	});
	$("#jqxContactMechGrid").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#jqxContactMechGrid").jqxGrid('getrowdata', args.rowindex);
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['contactMechId'] + '</div>';
        $("#contactMechIdAdd").jqxDropDownButton('setContent', dropDownContent);
    });
    </#if>
</script>
<#--
, 
				 		validation: function (cell, value) {
                          	if (value == '') return true;
                          	var year = value.getFullYear();
                          	if (year >= 2015) {
                              	return {result: false, message: 'Ship Date should be before 1/1/2015'};
                          	}
                          	return true;
                  		}
-->
<#if hasPermissionCreate>
<#assign dataFieldProduct="[{name: 'productId', type: 'string'},
             	{name: 'internalName', type: 'string'},
             	{name: 'quantity', type: 'string'},
             	{name: 'quantityUomId', type: 'string'},
             	{name: 'productPackingUomId', type: 'string'},
             	{name: 'packingUomId', type: 'string'}
	 		 	]"/>
<#assign columnlistProduct="{text: '${uiLabelMap.DAProductId}', dataField: 'productId', width: '150px', align: 'center', editable: false},
				 	{text: '${uiLabelMap.ProductName}', dataField: 'internalName', align: 'center', editable: false},
				 	{ text: '${uiLabelMap.DAUom}', dataField: 'quantityUomId', width: '120px', columntype: 'dropdownlist', 
					 	cellsrenderer: function(row, column, value){
    						for (var i = 0 ; i < uomData.length; i++){
    							if (value == uomData[i].uomId){
    								return '<span title = ' + uomData[i].description +'>' + uomData[i].description + '</span>';
    							}
    						}
    						return '<span title=' + value +'>' + value + '</span>';
						},
					 	initeditor: function (row, cellvalue, editor) {
					 		var packingUomData = new Array();
							var data = $('#jqxgridProduct').jqxGrid('getrowdata', row);
							
							var itemSelected = data['quantityUomId'];
							var packingUomIdArray = data['packingUomId'];
							for (var i = 0; i < packingUomIdArray.length; i++) {
								var packingUomIdItem = packingUomIdArray[i];
								var row = {};
								if (packingUomIdItem.description == undefined || packingUomIdItem.description == '') {
									row['description'] = '' + packingUomIdItem.uomId;
								} else {
									row['description'] = '' + packingUomIdItem.description;
								}
								row['uomId'] = '' + packingUomIdItem.uomId;
								packingUomData[i] = row;
							}
					 		var sourceDataPacking =
				            {
				                localdata: packingUomData,
				                datatype: \"array\"
				            };
				            var dataAdapterPacking = new $.jqx.dataAdapter(sourceDataPacking);
				            editor.jqxDropDownList({ source: dataAdapterPacking, displayMember: 'description', valueMember: 'uomId'
				            	//renderer: function (index, label, value) {
				            	//	console.log(index, label, value);
						        //	return '[' + value + '] ' + label;
						        //}
				            });
				            
                          	//editor.jqxDropDownList({source: dataAdapterPacking, displayMember:'description', valueMember: 'uomId'});
				            editor.jqxDropDownList('selectItem', itemSelected);
                      	}
                 	},
				 	{text: '${uiLabelMap.DAExpireDate}', dataField: 'expireDate', width: '150px', editable: true, columntype: 'datetimeinput', cellsformat: 'dd/MM/yyyy', filterable: false, sortable:false},
				 	{text: '${uiLabelMap.QuantityRequest}', dataField: 'quantity', width: '200px', align: 'center', cellsalign: 'right', filterable: false, sortable:false, columntype: 'numberinput', editable: true,
                     	validation: function (cell, value) {
                         	if (value < 0) {
                             	return { result: false, message: '${uiLabelMap.QuantityMustBeGreateThanZero}'};
                         	}
                         	return true;
                     	},
                     	createeditor: function (row, cellvalue, editor) {
                         	editor.jqxNumberInput({ decimalDigits: 0, digits: 10 });
                     	}
				 	}
				 "/>
<#--
<@jqGrid selectionmode="checkbox" idExisted="true" filtersimplemode="true" width="930" viewSize="5" pagesizeoptions="['5', '10', '15', '20', '25', '30', '50', '100']" 
		id="jqxgridProduct" dataField=dataFieldProduct columnlist=columnlistProduct clearfilteringbutton="true" showtoolbar="false" addrow="false" filterable="true" editable="true" 
	 	url="jqxGeneralServicer?sname=JQGetListProductSales" editmode="click" bindresize="false" jqGridMinimumLibEnable="false" offmode="true"/>
JQGetListRequirement&requirementTypeId=RETURN_PRODCOM_REQ
-->
<@jqGrid id="jqxgridProduct" idExisted="true" filtersimplemode="true" viewSize="5" pagesizeoptions="['5', '10', '15', '20', '25', '30', '50', '100']" 
		dataField=dataFieldProduct columnlist=columnlistProduct clearfilteringbutton="true" showtoolbar="false" addrow="false" editable="true" 
		url="jqxGeneralServicer?sname=JQGetListProductSales" filterable="true" width="930" bindresize="false" alternativeAddPopup="alterpopupWindow" addType="popup" 
		deleterow="false" offmode="true" editmode="click" selectionmode="checkbox"/>
</#if>		
