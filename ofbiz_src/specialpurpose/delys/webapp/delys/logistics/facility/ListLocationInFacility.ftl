<@jqGridMinimumLib/>
<script type="text/javascript" src="/aceadmin/jqw/scripts/demos.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/demos/sampledata/generatedata.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdata2.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdatatable.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtreegrid2.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/delys/images/js/import/miscUtil.js"></script>
<script>
	var facilityId = '${parameters.facilityId}';
	
	<#assign locationFacilityTypeList = delegator.findList("LocationFacilityType", null, null, null, null, false) />
	var locationFacilityTypeData = new Array();
	<#list locationFacilityTypeList as locationFacilityType>
		var row = {};
		row['locationFacilityTypeId'] = "${locationFacilityType.locationFacilityTypeId}";
		row['description'] = "${locationFacilityType.description}";
		locationFacilityTypeData[${locationFacilityType_index}] = row;
	</#list>
	
	function getlocationFacilityType(locationFacilityTypeIdInput) {
		for ( var x in locationFacilityTypeData) {
			if (locationFacilityTypeIdInput == locationFacilityTypeData[x].locationFacilityTypeId) {
				return locationFacilityTypeData[x].description;
			}
		}
	}
	
	<#assign locationFacilityList = delegator.findList("LocationFacility", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(Static["org.ofbiz.base.util.UtilMisc"].toMap("facilityId", facilityId)), null, null, null, false) />
	var locationFacilityData = new Array();
	<#list locationFacilityList as locationFacility>
		var row = {};
		row['locationId'] = "${locationFacility.locationId}";
		row['description'] = "${locationFacility.description}";
		locationFacilityData[${locationFacility_index}] = row;
	</#list>
	
	function getlocationFacility(locationIdInput) {
		for ( var x in locationFacilityData) {
			if (locationIdInput == locationFacilityData[x].locationId) {
				return locationFacilityData[x].description;
			}
		}
	}
	
	<#assign list = listUom.size()/>
    <#if listUom?size gt 0>
		<#assign uomId="var uomId = ['" + StringUtil.wrapString(listUom.get(0).uomId?if_exists) + "'"/>
		<#assign description="var description = ['" + StringUtil.wrapString(listUom.get(0).description?if_exists) + "'"/>
		<#if listUom?size gt 1>
			<#list 1..(list - 1) as i>
				<#assign uomId=uomId + ",'" + StringUtil.wrapString(listUom.get(i).uomId?if_exists) + "'"/>
				<#assign description=description + ",'" + StringUtil.wrapString(listUom.get(i).description?if_exists) + "'"/>
			</#list>
		</#if>
		<#assign uomId=uomId + "];"/>
		<#assign description=description + "];"/>
	<#else>
		<#assign uomId="var uomId = [];"/>
    	<#assign description="var description = [];"/>
    </#if>
	${uomId}
	${description}
	
	var adapter = new Array();
	for(var i = 0; i < ${list}; i++){
		var row = {};
		row['uomId'] = uomId[i];
		row['description'] = description[i];
		adapter[i] = row;
	}
	function getUom(uomId) {
		for ( var x in adapter) {
			if (uomId == adapter[x].uomId) {
				return adapter[x].description;
			}
		}
	}
	
	<#assign productList = delegator.findList("ListProductByInventoryItemId", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(Static["org.ofbiz.base.util.UtilMisc"].toMap("facilityId", facilityId)), null, null, null, false) />
	var productData = new Array();
	<#list productList as product>
		<#assign productId = StringUtil.wrapString(product.productId) />
		var row = {};
		row['productId'] = "${product.productId}";
		productData[${product_index}] = row;
	</#list>
	
	
</script>

<div>
	<div id="contentMessageNotificationSelectMyTree">
	</div>
	<div id="contentNotificationSelectMyTreeFullSelect" style="width:100%">
	</div>
	<div>
		<input type="button" value='${uiLabelMap.CreateNewLocationFacility}' id="showWindowButton" />	
		<input type="button" value='${uiLabelMap.AddProductInLocationFacility}' id="jqxButtonAddProduct" />	
		<input type="button" value='${uiLabelMap.StockProductIdForLocationInFacilityForLocation}' id="jqxButtonStockLocation" />	
		<input type="button" value='${uiLabelMap.FacilitylocationSeqIdCurrent}' id="jqxButtonStockLocationContrary" />
		<input type="button" value='${uiLabelMap.DSDeleteLocationFacilityType}' id="jqxButtonDeleteLocationFacility" />
	</div>
<div>

<div id="CreateNewLocation" class="hide">
	<div>${uiLabelMap.ProductNewLocationType}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.SelectTypeLocationFacility}: </div>
						<div class="controls">
							<div id="listLocationFacilityType"></div>
						</div>
					</div>
				</div>
			</div>
		</div>	
	</div>
</div>

<div id="CreateNewLocationFacility" class="hide">
	<div>${uiLabelMap.ProductNewLocationType}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div id="contentNotifiCheckCreateLocationFacility"></div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.ParentLocationId}: </div>
						<div class="controls">
							<div id="listParentLocationId"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.DescriptionLocationTypeId}: </div>
						<div class="controls">
							<input id="locationTypeId"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.LocationTypeIdDescription}: </div>
						<div class="controls">
							<input id="description"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
					<div class="controls">
						<input style="margin-right: 5px;" type="button" id="alterCreate" value="${uiLabelMap.CommonSave}" />
				       	<input id="alterExit" type="button" value="${uiLabelMap.CommonCancel}" />  
					</div>      	
			    </div>
				</div>
			</div>
		</div>	
	</div>
</div> 

<div>
	<div id="contentNotificationContentCreateLocationFacility"></div>
	<div id="contentNotificationCheckDescription" style="width:100%">
	</div>
	<div id="contentNotificationLocationFacilityUpdateSuccess" style="width:100%">
	</div>
	<div id="contentNotificationLocationFacilityUpdateError" style="width:100%">
	</div>
	<div id="contentNotificationLocationFacilityUpdateErrorParent" style="width:100%">
	</div>
	<div id="contentNotificationLocationFacilityDeleteSuccess" style="width:100%">
	</div>
	<div id="contentNotificationCreateInventoryItemSuccess" style="width:100%">
	</div>
	<div id="myTree">
	</div>
</div>



<div id="AddProductInLocationFacility" class="hide">
	<div>${uiLabelMap.AddProductInLocationFacility}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div id="contentNotificationCreateInventoryItemLocaitonError">
				</div>
				<div class="control-group no-left-margin">
					<div style="overflow:hidden;overflow-y:visible; max-height:300px !important;">
						<div id="jqxTreeGridAddProduct">
						</div>
					</div>
			    </div>
			    <div class="control-group no-left-margin">
					<div class="controls">
						<input style="margin-right: 5px;" type="button" id="alterAddProduct" value="${uiLabelMap.CommonSave}" />
				       	<input id="alterExitProduct" type="button" value="${uiLabelMap.CommonCancel}" />  
					</div>      	
			    </div>
			</div>
		</div>	
	</div>
</div>

<div id="StockProductFromLocationToLocationInFacility" class="hide">
	<div>${uiLabelMap.StockLocationInFacility}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div id="contentNotificationSuccessMoveProduct2"  style="width:100%">
				</div>
				<div class="control-group no-left-margin">
					<div class="span6">
						<div style="overflow:hidden;overflow-y:visible; max-height:300px !important;">
							<div id="jqxgridStock">
							</div>
						</div>
					</div>
					<div class="span6">
						<div style="overflow:hidden;overflow-y:visible; max-height:300px !important;">
							<div id="jqxgridStockTranfer">
							</div>
						</div>
					</div>
			    </div>
			    <div class="control-group no-left-margin">
					<div class="span12">
				       	<input id="alterExitStockProduct" type="button" value="${uiLabelMap.CommonCancel}" />  
					</div>      	
			    </div>
			</div>
		</div>	
	</div>
</div>


<div id="StockProductFromLocationToLocationInFacilityContrary" class="hide">
	<div>${uiLabelMap.StockLocationInFacility}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div id="contentNotificationSuccessMoveProduct"  style="width:100%">
				</div>
				<div class="control-group no-left-margin">
					<div class="span6">
						<div style="overflow:hidden;overflow-y:visible; max-height:300px !important;">
							<div id="jqxgridStockTranferContrary">
							</div>
						</div>
					</div>
					<div class="span6">
						<div style="overflow:hidden;overflow-y:visible; max-height:300px !important;">
							<div id="jqxgridStockContrary">
							</div>
						</div>
					</div>
			    </div>
			    <div class="control-group no-left-margin">
			    </div>
			    <div class="control-group no-left-margin">
					<div class="span12">
				       	<input id="cancelStockProductContrary" type="button" value="${uiLabelMap.CommonCancel}" />  
					</div>      	 
			    </div>
			</div>
		</div>	
	</div>
</div>

<div id="dialogTranferProductToLocation" class="hide">
	<div>${uiLabelMap.ProductNewLocationType}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div id="contentNotificationCheckSelectDropDownToTranfer"  style="width:100%">
					</div>
					<div id="contentNotificationCheckInventoryItemIdExists"  style="width:100%">
					</div>
					<div id="contentNotificationContentNested"  style="width:100%">
					</div>
					<div id="contentNotificationCheckQuantityTranfer"  style="width:100%">
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input id="locationCodeCurrent" type="hidden"></input>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.StockProductIdForLocationInFacilityForLocation}:</div>
						<div class="controls">
							<div id="locationIdTranfer"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div style="overflow:hidden;overflow-y:visible; max-height:200px !important;">
							<div id="jqxgridProductByLocationInFacility">
							</div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input id="locationIdCurrent" type="hidden"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="save" value="${uiLabelMap.CommonSave}" />
					       	<input id="cancel" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="dialogTranferProductToLocationContrary" class="hide">
	<div>${uiLabelMap.ProductNewLocationType}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div id="contentNotificationCheckInventoryItemIdExistsContrary">
					</div>
					<div id="contentNotificationContentNestedContrary" style="width:100%">
					</div>
					<div id="contentNotificationCheckQuantityTranferContrary"  style="width:100%">
					</div>
					<div id="contentNotificationCheckSelectDropDownToTranferContrary"  style="width:100%">
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input id="locationCodeCurrentContrary" type="hidden"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.StockProductIdForLocationInFacilityForLocation}:</div>
						<div class="controls">
							<div id="locationIdTranferContrary"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div style="overflow:hidden;overflow-y:visible; max-height:200px !important;">
							<div id="jqxgridProductByLocationInFacilityContrary">
							</div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input id="locationIdCurrentContrary" type="hidden"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
					</div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="saveContrary" value="${uiLabelMap.CommonSave}" />
					       	<input id="cancelContrary" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="jqxMessageNotificationSuccessMoveProduct">
	<div id="notificationContentSuccessMoveProduct">
	</div>
</div>

<div id="jqxMessageNotificationSuccessMoveProduct2">
	<div id="notificationContentSuccessMoveProduct2">
	</div>
</div>

<div id="jqxMessageNotificationSelectMyTree">
	<div id="notificationContentSelectMyTree">
	</div>
</div>

<div id="jqxMessageNotificationSelectMyTreeFullSelect">
	<div id="notificationContentSelectMyTreeFullSelect">
	</div>
</div>

<div id="jqxNotificationNested">
	<div id="notificationContentNested">
	</div>
</div>

<div id="jqxNotificationNestedContrary" >
	<div id="notificationContentNestedContrary">
	</div>
</div>

<div id="jqxNotificationCheckCreateLocationFacility" >
	<div id="notificationCheckCreateLocationFacility">
	</div>
</div>

<div id="jqxNotificationCreateLocationFacilitySuccess" >
	<div id="notificationContentCreateLocationFacilitySuccess">
	</div>
</div>

<div id="jqxNotificationInventoryItemLocationSuccess" >
	<div id="notificationContentInventoryItemLocationSuccess">
	</div>
</div>

<div id="jqxNotificationInventoryItemLocationError" >
	<div id="notificationContentInventoryItemLocationError">
	</div>
</div>

<div id="jqxNotificationCheckCreateLocationFacility" >
	<div id="notificationCheckContentCreateLocationFacility">
	</div>
</div>

<div id="jqxMessageNotificationCheckDescription">
	<div id="notificationContentCheckDescription">
	</div>
</div>

<div id="jqxNotificationUpdateSuccess" >
	<div id="notificationContentUpdateSuccess">
	</div>
</div>

<div id="jqxNotificationUpdateError" >
	<div id="notificationContentUpdateError">
	</div>
</div>

<div id="jqxNotificationUpdateErrorParent" >
	<div id="notificationContentUpdateErrorParent">
	</div>
</div>
<div id="jqxNotificationDeleteSuccess" >
	<div id="notificationContentDeleteSuccess">
	</div>
</div>

<div id="jqxNotificationCheckInventoryItemIdExists" >
	<div id="notificationCheckInventoryItemIdExists">
	</div>
</div>

<div id="jqxNotificationCheckInventoryItemIdExistsContrary" >
	<div id="notificationCheckInventoryItemIdExistsContrary">
	</div>
</div>

<div id="jqxNotificationQuantityTranfer" >
	<div id="notificationQuantityTranfer">
	</div>
</div>

<div id="jqxNotificationQuantityTranferContrary" >
	<div id="notificationQuantityTranferContrary">
	</div>
</div>

<div id="jqxNotificationSelectDropDownToTranfer" >
	<div id="notificationCheckSelectDropDownToTranfer">
	</div>
</div>

<div id="jqxNotificationSelectDropDownToTranferContrary" >
	<div id="notificationCheckSelectDropDownToTranferContrary">
	</div>
</div>





<script>
//Create theme
	$.jqx.theme = 'olbius';  
theme = $.jqx.theme;

$("#CreateNewLocation").jqxWindow({
    width: 600 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExit"), modalOpacity: 0.7           
});

$("#AddProductInLocationFacility").jqxWindow({
    width: '80%', maxWidth: '80%', height:400 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitProduct"), modalOpacity: 0.7           
});

$("#StockProductFromLocationToLocationInFacility").jqxWindow({
    width: '80%', maxWidth: '80%', height:400 ,resizable: false, isModal: true, autoOpen: false, cancelButton: $("#alterExitStockProduct"), modalOpacity: 0.7           
});

$("#StockProductFromLocationToLocationInFacilityContrary").jqxWindow({
    width:'80%', maxWidth: '80%' , height:400 ,resizable: false, isModal: true, autoOpen: false, cancelButton: $("#cancelStockProductContrary"), modalOpacity: 0.7, theme: 'olbius'         
});

$("#jqxMessageNotificationSelectMyTree").jqxNotification({ width: "100%", appendContainer: "#contentMessageNotificationSelectMyTree", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxMessageNotificationSuccessMoveProduct").jqxNotification({ width: "100%", appendContainer: "#contentNotificationSuccessMoveProduct", opacity: 0.9, autoClose: true, template: "success" });
$("#jqxMessageNotificationSuccessMoveProduct2").jqxNotification({ width: "100%", appendContainer: "#contentNotificationSuccessMoveProduct2", opacity: 0.9, autoClose: true, template: "success" });
$("#jqxNotificationNested").jqxNotification({ width: "100%", appendContainer: "#contentNotificationContentNested", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationCreateLocationFacilitySuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationContentCreateLocationFacility", opacity: 0.9, autoClose: true, template: "success" });
$("#jqxNotificationCheckCreateLocationFacility").jqxNotification({ width: "100%", appendContainer: "#contentNotifiCheckCreateLocationFacility", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxMessageNotificationCheckDescription").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckDescription", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationUpdateSuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationLocationFacilityUpdateSuccess", opacity: 0.9, autoClose: true, template: "success" });
$("#jqxNotificationUpdateError").jqxNotification({ width: "100%", appendContainer: "#contentNotificationLocationFacilityUpdateError", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationUpdateErrorParent").jqxNotification({ width: "100%", appendContainer: "#contentNotificationLocationFacilityUpdateErrorParent", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationDeleteSuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationLocationFacilityDeleteSuccess", opacity: 0.9, autoClose: true, template: "success" });
$("#jqxNotificationInventoryItemLocationSuccess").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateInventoryItemSuccess", opacity: 0.9, autoClose: true, template: "success" });
$("#jqxNotificationInventoryItemLocationError").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCreateInventoryItemLocaitonError", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxMessageNotificationSelectMyTreeFullSelect").jqxNotification({ width: "100%", appendContainer: "#contentNotificationSelectMyTreeFullSelect", opacity: 0.9, autoClose: true, template: "info" });
$("#jqxNotificationCheckInventoryItemIdExists").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckInventoryItemIdExists", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationCheckInventoryItemIdExistsContrary").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckInventoryItemIdExistsContrary", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationQuantityTranfer").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckQuantityTranfer", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationQuantityTranferContrary").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckQuantityTranferContrary", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationSelectDropDownToTranfer").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckSelectDropDownToTranfer", opacity: 0.9, autoClose: true, template: "error" });
$("#jqxNotificationSelectDropDownToTranferContrary").jqxNotification({ width: "100%", appendContainer: "#contentNotificationCheckSelectDropDownToTranferContrary", opacity: 0.9, autoClose: true, template: "error" });

$("#jqxButtonAddProduct").jqxButton({ height: 30});
$("#jqxButtonStockLocation").jqxButton({ height: 30});
$("#jqxButtonStockLocationContrary").jqxButton({ height: 30});
$("#showWindowButton").jqxButton({ height: 30});
$("#jqxButtonDeleteLocationFacility").jqxButton({ height: 30});

$("#alterAddProduct").jqxButton({ height: 30, width: 80 });
$("#alterExitProduct").jqxButton({ height: 30, width: 80 });

$("#alterExitStockProduct").jqxButton({ height: 30, width: 80 });

$("#cancelStockProductContrary").jqxButton({ height: 30, width: 80 });


$("#alterCreate").jqxButton({ height: 30, width: 80 });
$("#alterExit").jqxButton({ height: 30, width: 80 });
$("#locationTypeId").jqxInput();
$("#description").jqxInput();
$("#CreateNewLocationFacility").jqxWindow({
    width: 600 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExit"), modalOpacity: 0.7           
});

var facilityId = '${facilityId}';
function loadParentLocationFacilityTypeIdInFacility(){
	var request = $.ajax({
		  url: "loadParentLocationFacilityTypeIdInFacility",
		  type: "POST",
		  data: null,
		  dataType: "json",
		  success: function(data) {
			  var listParentLocationFacilityTypeMap = data["listParentLocationFacilityTypeMap"];
			  bindingDataToJqxDropDownListLocationFacilityType(listParentLocationFacilityTypeMap);
		  }
	});
	request.done(function(data) {
	});
}

$("#showWindowButton").click(function (){
	$('#CreateNewLocation').jqxWindow('open');
});

function bindingDataToJqxDropDownListLocationFacilityType(dataBinding){
	$("#listLocationFacilityType").jqxDropDownList({source: dataBinding, placeHolder: "Please select...." ,displayMember: 'description', valueMember: 'locationFacilityTypeId', width:'211px'});
}

$("#listLocationFacilityType").on('select', function (event) {
    if (event.args) {
        var item = event.args.item;
    }
    var locationFacilityTypeId = item.value;
    loadLocationFacilityByFacility(locationFacilityTypeId);
});

function loadLocationFacilityByFacility(locationFacilityTypeId){
	var request = $.ajax({
		url: "loadLocationFacilityTypeId",
		type: "POST",
		data: {facilityId: facilityId, locationFacilityTypeId: locationFacilityTypeId},
		dataType: "json",
		success: function(data) {
			var listLocationFacilityTypeId = data["listlocationFacilityMap"];
			if(listLocationFacilityTypeId.length == 0){
				$("#listParentLocationId").jqxDropDownList('setContent', '${uiLabelMap.DSCommonNoParentLocationIdExits}'); 
				$("#listParentLocationId").jqxDropDownList({ disabled: true }); 
			}else{
				$("#listParentLocationId").jqxDropDownList({ disabled: false, selectedIndex: 0, placeHolder: 'Please select....' ,source: listLocationFacilityTypeId, displayMember: 'description', valueMember: 'locationId', width:'211px'});
			}
		}
	});
	request.done(function(data) {
		locationFacilityTypeId = "";
	});
    
	if(locationFacilityTypeId != ""){
		$('#CreateNewLocationFacility').jqxWindow('open');
	}
}

$("#alterCreate").click(function (){
	var locationCode = $('#locationTypeId').val();
	var locationFacilityTypeId = $('#listLocationFacilityType').val();
	var parentLocationId = $('#listParentLocationId').val();
	var description = $('#description').val();
	if(locationCode == "" || description == ""){
		$("#notificationCheckCreateLocationFacility").text('${StringUtil.wrapString(uiLabelMap.DSCheckIsEmptyCreateLocationFacility)}');
		$("#jqxNotificationCheckCreateLocationFacility").jqxNotification('open');
	}else{
		$.ajax({
			  url: "createNewLocationFacilityType",
			  type: "POST",
			  data: {facilityId: facilityId, locationCode: locationCode, parentLocationId: parentLocationId, locationFacilityTypeId: locationFacilityTypeId, description: description},
			  dataType: "html",
			  success: function(data) {
			  }
		}).done(function(data) {
			loadData();
			$('#locationTypeId').val("");
			$('#listLocationFacilityType').val("");
			$('#description').val("");
			
			$("#notificationContentCreateLocationFacilitySuccess").text('${StringUtil.wrapString(uiLabelMap.NotifiCreateSucess)}');
			$("#jqxNotificationCreateLocationFacilitySuccess").jqxNotification('open');
			$("#CreateNewLocationFacility").jqxWindow('close');
		    $("#CreateNewLocation").jqxWindow('close');
		});
	}
});

$("#alterExit").click(function (){
	$("#listLocationFacilityType").jqxDropDownList('setContent', 'Please select...');
	$("#listParentLocationId").jqxDropDownList('setContent', 'Please select...'); 
	$('#locationTypeId').val("");
	$('#description').val("");
});

function createNewLocationFacilityInFacility(locationCode, facilityId, locationFacilityTypeId, parentLocationId, description){
	var request = $.ajax({
		  url: "createNewLocationFacilityTypeAISLE",
		  type: "POST",
		  data: {locationCode: locationCode, facilityId: facilityId, locationFacilityTypeId: locationFacilityTypeId, parentLocationId: parentLocationId ,description: description},
		  dataType: "json",
		  success: function(data) {
			  
		  }
	}).done(function(data) {
		loadData();
		$("#CreateNewLocation").jqxWindow('close');
		$("#notificationContentCreateLocationFacilitySuccess").text('${StringUtil.wrapString(uiLabelMap.NotifiCreateSucess)}');
		$("#jqxNotificationCreateLocationFacilitySuccess").jqxNotification('open');
	});
}

var dataRow = new Array();
var kerArray = new Array();

$('#myTree').on('rowCheck', function (event) {
	var args = event.args;
    var row = args.row;
    var key = args.key;
    kerArray.push(key);
    dataRow.push(row);
});

$('#myTree').on('rowUncheck', function (event) {
	var row = args.row;
	var ii = dataRow.indexOf(row);
	dataRow.splice(ii, 1);
});


$("#save").jqxButton({ height: 30, width: 80 });
$("#cancel").jqxButton({ height: 30, width: 80 });
$("#cancel").mousedown(function () {
    $("#dialogTranferProductToLocation").jqxWindow('close');
});

$("#saveContrary").jqxButton({ height: 30, width: 80 });
$("#cancelContrary").jqxButton({ height: 30, width: 80 });
$("#cancelContrary").mousedown(function () {
    $("#dialogTranferProductToLocationContrary").jqxWindow('close');
});

$('#myTree').on('rowEndEdit', function (event) {
	var args = event.args;
    var row = args.row;
    var locationId = row.locationId;
    var locationCode = row.locationCode;
    var parentLocationId = row.parentLocationId;
    var locationFacilityTypeId = row.locationFacilityTypeId;
    var description = row.description;
    updateLocationFacility(locationId, facilityId, locationCode, parentLocationId, locationFacilityTypeId, description);
});

function updateLocationFacility(locationId, facilityId, locationCode, parentLocationId, locationFacilityTypeId, description){
	if(description == "" || locationCode == ""){
		$("#notificationContentCheckDescription").text('${StringUtil.wrapString(uiLabelMap.DSCheckDescription)}');
		$("#jqxMessageNotificationCheckDescription").jqxNotification('open');
    }else{
		$.ajax({
			url: "updateLocationFacility",
			type: "POST",
			data: {locationId: locationId, locationCode: locationCode, parentLocationId: parentLocationId, locationFacilityTypeId: locationFacilityTypeId, description: description},
			dataType: "json",
			success: function(data) {
				var value = data["value"];
				if(value == "success"){
					$("#notificationContentUpdateSuccess").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateSucess)}');
					$("#jqxNotificationUpdateSuccess").jqxNotification('open');
  			  	}
				if(value == "parentError"){
					$("#notificationContentUpdateError").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateError)}');
					$("#jqxNotificationUpdateError").jqxNotification('open');
  			  	}	
				if(value == "errorParent"){
					$("#notificationContentUpdateErrorParent").text('${StringUtil.wrapString(uiLabelMap.DSNotifiUpdateErrorParent)}');
					$("#jqxNotificationUpdateErrorParent").jqxNotification('open');
  			  	}
			}
	  	}).done(function(data) {
	  		loadData();
	  	});
    }
}	

$("#jqxButtonDeleteLocationFacility").click(function (){
	if(dataRow.length == 0){
		$("#notificationContentSelectMyTree").text('${StringUtil.wrapString(uiLabelMap.SelectJqxTreeGirdToDelete)}');
     	$("#jqxMessageNotificationSelectMyTree").jqxNotification('open');
	}
	else{
		var locationIdData = [];
		for(var i= 0; i < dataRow.length; i++){
			locationIdData.push(dataRow[i].locationId);
		}
		deleteLocationFacility(locationIdData);
	}
});

function deleteLocationFacility(locationIdData){
	$.ajax({
		  url: "deleteLocationFacility",
		  type: "POST",
		  data: {locationId: locationIdData},
		  dataType: "json",
		  success: function(data) {
			  var value = data["value"];
			  if(value == "success"){
				  $("#notificationContentDeleteSuccess").text('${StringUtil.wrapString(uiLabelMap.DSNotifiDeleteSucess)}');
				  $("#jqxNotificationDeleteSuccess").jqxNotification('open');
			  }
		  }    
	}).done(function(data) {
		dataRow = [];
		loadData();
	});
}

$("#dialogTranferProductToLocation").jqxWindow({
    resizable: false,
    width: '80%',
    height: 350,
    autoOpen: false,
    resizable: false, 
    isModal: true, 
    autoOpen: false, 
    cancelButton: $("#cancel"), 
    modalOpacity: 0.7
});

$("#dialogTranferProductToLocationContrary").jqxWindow({
    width: '80%',
    height: 350,
    autoOpen: false,
    resizable: false, 
    isModal: true, 
    autoOpen: false, 
    cancelButton: $("#cancelContrary"), 
    modalOpacity: 0.7
});



$('#jqxButtonAddProduct').click(function () {
	if(dataRow.length == 0){
    	$("#notificationContentSelectMyTree").text('${StringUtil.wrapString(uiLabelMap.SelectJqxTreeGird)}');
     	$("#jqxMessageNotificationSelectMyTree").jqxNotification('open');
    }else{
    	checkParentLocationIdInDataRow(dataRow);
    }
	loadData();
	dataRow = []; 
});

function checkParentLocationIdInDataRow(data){
	var parentLocationIdInDataRow = [];
	lbl:for(var i = 0; i < data.length; i++){
			for(var j = 0; j < data.length; j++){
				if(data[i].locationId == data[j].parentLocationId){
					continue lbl;
				}
			}
			parentLocationIdInDataRow.push(data[i].locationId);
	}
	uniquesLocationId = [];
	for(var i=0;i<parentLocationIdInDataRow.length;i++){
		var str=parentLocationIdInDataRow[i];
    	if(uniquesLocationId.indexOf(str)==-1){
    		uniquesLocationId.push(str);
        }
    }
	
	loadDataRowToJqxGirdTree(uniquesLocationId);
}

function loadDataRowToJqxGirdTree(dataLocationId){
	$.ajax({
		  url: "loadDataRowToJqxGirdTreeAddProduct",
		  type: "POST",
		  data: {locationId: dataLocationId},
		  dataType: "json",
		  success: function(data) {
		  }    
	}).done(function(data) {
		var listLocationFacility = data["listLocationFacility"];
		addProductInLocationByFacility(listLocationFacility);
	});
}

function addProductInLocationByFacility(sourceData){
	var source =
    {
        localdata: sourceData,
        dataType: "json",
        datafields:
        [
            { name: 'locationId', type: 'string' },
            { name: 'locationCode', type: 'string' },
            { name: 'locationFacilityTypeId', type: 'string' },
            { name: 'parentLocationId', type: 'string' },
            { name: 'description', type: 'string' },
            { name: 'productId', type: 'string' },
            { name: 'facilityId', type: 'string' },
            { name: 'inventoryItemId', type: 'string'},
            { name: 'quantity', type: 'number' },
            { name: 'uomId', type: 'string' }
        ],
        hierarchy:
        {
        	keyDataField: { name: 'locationId' },
            parentDataField: { name: 'parentLocationId' }
        },
        id: 'locationId',
    };
	
	var facilityId = '${facilityId}';
	var rowDetail;
	$.ajax({
		  url: "loadListLocationFacility",
		  type: "POST",
		  data: {facilityId: facilityId},
		  dataType: "json",
		  success: function(data) {
			  rowDetail = data["listInventoryItemLocationDetailMap"]
		  }    
	}).done(function(data) {
		bindDataJqxTreeGirdAddProductToLocationInFacility(source, rowDetail);
	});
	
}


function bindDataJqxTreeGirdAddProductToLocationInFacility(source, rowDetail){
	var dataAdapter = new $.jqx.dataAdapter(source,{
    	beforeLoadComplete: function (records) {
	    	for (var x = 0; x < records.length; x++) {
	    		for(var key in rowDetail){
	    			if(records[x].locationId == key){
	    				records[x].rowDetailData = rowDetail[key];
	    			}
	    		}
	    	}
	    	return records;
    	}
    });
	var listExpireDate;
    var listConfigPacking;
    $("#jqxTreeGridAddProduct").jqxTreeGrid(
    {
    	width: '100%',
        source: dataAdapter,
        pageable: true,
        columnsResize: true,
        altRows: true,
        selectionMode: 'multipleRows',
        sortable: true,
        rowDetails: true,
        editable: true,
        editSettings: {
            saveOnPageChange: true,
            saveOnBlur: true,
            saveOnSelectionChange: true,
            cancelOnEsc: true,
            saveOnEnter: true,
            editSingleCell: true,
            editOnDoubleClick: true,
            editOnF2: true
        },
        rowDetailsRenderer: function (rowKey, row) {
        	var indent = (1+row.level) * 20;
        	var rowDetailDataInLocation = row.rowDetailData;
        	var detailsData = [];
        	var details = "<table class='table table-striped table-bordered table-hover dataTable' style='margin: 10px; min-height: 95px; height: 95px; width:100%" + indent + "px;'>" +
    						"<thead>" +
            					"<tr>" +
    			    				"<th>" + '${uiLabelMap.ProductProductId}' + "</th>" +
    			    			  	"<th>" + '${uiLabelMap.Quantity}' + "</th>" +
    			    			  	"<th>" + '${uiLabelMap.QuantityUomId}' + "</th>" +
    			    		    "</tr>" +
    		    		    "</thead>";
        	for(var i in rowDetailDataInLocation){
        		var productIdData = rowDetailDataInLocation[i].productId;
        		var quantityData = rowDetailDataInLocation[i].quantity;
        		var uomIdData = rowDetailDataInLocation[i].uomId;
        		details += "<tbody>" +
            					"<tr>" +
    		        				"<td>" + productIdData + "</td>" +
    		        			  	"<td>" + quantityData + "</td>" +
    		        			  	"<td>" + getUom(uomIdData) + "</td>" +
    		        			"</tr>" +
    		        		"</tbody>";
        	}
        	details += "</table>";
        	detailsData.push(details);
            return detailsData;
        },
        ready: function()
        {
       	 $("#jqxTreeGridAddProduct").jqxTreeGrid('selectRow', '2');
        },
        
        columns: [
	        /*{ text: '${uiLabelMap.FacilityLocationPosition}', datafield: 'locationCode', width: 100 },*/
	        { text: '${uiLabelMap.FacilityLocationPosition}', datafield: 'description', minwidth: 200, editable: false },
	        { text: '${uiLabelMap.ProductProductId}', datafield: 'productId', minwidth: 150, columnType: 'template',
	        	createEditor: function (row, cellvalue, editor, cellText, width, height) {
	        		editor.jqxDropDownList({autoDropDownHeight: true, placeHolder: "Please select....", source: productData, width: '100%', height: '100%' ,displayMember: 'productId', valueMember: 'productId'});
	        	},
	        },
	        { text: '${uiLabelMap.ProductExpireDate}', datafield: 'inventoryItemId', minwidth: 150 ,columnType: 'template' ,editable:true,
	        	initEditor: function (row, cellvalue, editor) {
	        		editor.jqxDropDownList({autoDropDownHeight: true, source: arrayExpireDate, placeHolder: "Please select....", width: '100%', height: '100%', displayMember: 'expireDate', valueMember: 'inventoryItemId'});
	        	},
	        },
	        { text: '${uiLabelMap.DSQuantity}', datafield: 'quantity', minwidth: 100, editable:true},
	        { text: '${uiLabelMap.QuantityUomId}', datafield: 'uomId', minwidth: 150, columnType: 'template',
	        	initEditor: function (row, cellvalue, editor) {
		        	editor.jqxDropDownList({autoDropDownHeight: true, source: uniquesUomId, placeHolder: "Please select...." ,width: '100%', height: '100%'});
		        }
	        }
        ]
    });
    
	$("#myTree").jqxTreeGrid('refresh');
    $("#AddProductInLocationFacility").jqxWindow('open');
}


$('#jqxTreeGridAddProduct').on('cellEndEdit', function (event){
    var args = event.args;
    // row key
    var rowKey = args.key;
    // row's data.
    var row = args.row;
    // column's data field.
    var columnDataField = args.dataField;
    // column's display field.
    var columnDisplayField = args.displayField;
    // cell's value.
    var value = args.value;
    var facilityId22 = '${facilityId}';
    if(columnDataField == "productId"){
    	$.ajax({
    		url: "loadExpireDateByProductIdInInventoryItem",
    		type: "POST",
    		data: {facilityId: facilityId22, productId: value},
    		dataType: "json",
    		success: function(data) {
    		}	  
    	}).done(function(data) {
    		var listInventoryItem = data["listExpireDate"];
			var listConfigPacking = data["listConfigPacking"];
    		loadExpireDateAndUomIdByProductId(listInventoryItem, listConfigPacking);
    	});
    }
});


var arrayExpireDate = [];
function loadExpireDateAndUomIdByProductId(listInventoryItem, listConfigPacking){
	for(var i in listInventoryItem){
		if(listInventoryItem[i].expireDate == null){
		}else{
			var arrayExpireDateMap = {};
			arrayExpireDateMap['inventoryItemId'] = (listInventoryItem[i].inventoryItemId);
			arrayExpireDateMap['expireDate'] = (new Date(listInventoryItem[i].expireDate.time)).toTimeOlbius();
			arrayExpireDate.push(arrayExpireDateMap);
		}
	}
	
	//arrayExpireDate = listInventoryItem;
	var arrayUomId = [];
	if(listConfigPacking != undefined){
		for(var j = 0; j < listConfigPacking.length; j++){
			arrayUomId.push(listConfigPacking[j]);
		}
	}
	loadUomIdByProductIdFromConfigPacking(arrayUomId);
}

function loadUomIdByProductIdFromConfigPacking(arrayUomId){
	var uomFromId = [];
	var uomToId = [];
	for(var i in arrayUomId){
		uomFromId.push(arrayUomId[i].uomFromId);
		uomToId.push(arrayUomId[i].uomToId);
	}
	
	var uniquesUomFromId = [];
	var uniquesUomToId = [];
	
	for(var i=0;i<uomFromId.length;i++){
		var str=uomFromId[i];
    	if(uniquesUomFromId.indexOf(str)==-1){
    		uniquesUomFromId.push(str);
        }
    }
	
	for(var j=0; j<uomToId.length;j++){
		var str=uomToId[j];
    	if(uniquesUomToId.indexOf(str) == -1){
    		uniquesUomToId.push(str);
        }
    }
	
	bindingDataToUomId(uniquesUomFromId, uniquesUomToId);
}


function bindingDataToUomId(uomFromId, uomToId){
	var uomIdDataBinding = [];
	for(var i in uomFromId){
		uomIdDataBinding.push(uomFromId[i]);
	}
	for(var i in uomToId){
		uomIdDataBinding.push(uomToId[i]);
	}
	bindingDataToUomId2(uomIdDataBinding);
}

var uniquesUomId = [];
function bindingDataToUomId2(uomIdDataBinding){
	uniquesUomId = [];
	for(var i=0;i<uomIdDataBinding.length;i++){
		var str=uomIdDataBinding[i];
    	if(uniquesUomId.indexOf(str)==-1){
    		uniquesUomId.push(str);
        }
    }
}

function updateBoundDataTreeGird(source){
	var facilityId = '${facilityId}';
	var rowDetail;
	$.ajax({
		  url: "loadListLocationFacility",
		  type: "POST",
		  data: {facilityId: facilityId},
		  dataType: "json",
		  success: function(data) {
			  rowDetail = data["listInventoryItemLocationDetailMap"]
		  }    
	}).done(function(data) {
		loadDataOfRowDetailByMyTreeGird(source, rowDetail);
	});
}

function updateBoundDataTreeGirdRemain(source){
	var facilityId = '${facilityId}';
	var rowDetail;
	$.ajax({
		  url: "loadListLocationFacility",
		  type: "POST",
		  data: {facilityId: facilityId},
		  dataType: "json",
		  success: function(data) {
			  rowDetail = data["listInventoryItemLocationDetailMap"]
		  }    
	}).done(function(data) {
		loadDataOfRowDetailByMyTreeGirdRemain(source, rowDetail);
	});
}

function loadDataOfRowDetailByMyTreeGird(source, rowDetail){
	loadDataAndDetailJqxgridStock(source, rowDetail);
}

function loadDataOfRowDetailByMyTreeGirdRemain(source, rowDetail){
	loadDataAndDetailJqxgridStockTranfer(source, rowDetail);
}

function loadFunctionAddProductInLocation(sourceData){
	var source =
	{
		dataType: "json",
	    dataFields: [
	        { name: 'locationId', type: 'string' },         
	    	{ name: 'facilityId', type: 'string' }, 
	    	{ name: 'locationCode', type: 'string' },
	    	{ name: 'parentLocationId', type: 'string' },
	    	{ name: 'locationFacilityTypeId', type: 'string' },
	    	{ name: 'description', type: 'string' },
	    ],
	    hierarchy:
	    {
	    	keyDataField: { name: 'locationId' },
	        parentDataField: { name: 'parentLocationId' }
	    },
	    id: 'locationId',
	    localData: sourceData
    };
	updateBoundDataTreeGird(source);
}

function loadDataAndDetailJqxgridStock(source, rowDetail){
	var dataAdapter = new $.jqx.dataAdapter(source,{
    	beforeLoadComplete: function (records) {
	    	for (var x = 0; x < records.length; x++) {
	    		for(var key in rowDetail){
	    			if(records[x].locationId == key){
	    				records[x].rowDetailData = rowDetail[key];
	    			}
	    		}
	    	}
	    	return records;
    	}
    });
	
	$("#jqxgridStock").jqxTreeGrid(
	{
	    	width: '100%',
	        source: dataAdapter,
	        pageable: true,
	        columnsResize: true,
	        altRows: true,
            selectionMode: 'multipleRows',
            sortable: true,
            rowDetails: true,
            rowDetailsRenderer: function (rowKey, row) {
            	var indent = (1+row.level) * 20;
            	
            	var rowDetailDataInLocation = row.rowDetailData;
            	var detailsData = [];
            	var details = "<table class='table table-striped table-bordered table-hover dataTable' style='margin: 10px; min-height: 95px; height: 95px; width:100%" + indent + "px;'>" +
    							"<thead>" +
    	        					"<tr>" +
    				    				"<th>" + '${uiLabelMap.ProductProductId}' + "</th>" +
    				    			  	"<th>" + '${uiLabelMap.Quantity}' + "</th>" +
    				    			  	"<th>" + '${uiLabelMap.QuantityUomId}' + "</th>" +
    				    		    "</tr>" +
    			    		    "</thead>";
            	for(var i in rowDetailDataInLocation){
            		var productIdData = rowDetailDataInLocation[i].productId;
            		var quantityData = rowDetailDataInLocation[i].quantity;
            		var uomIdData = rowDetailDataInLocation[i].uomId;
            		details += "<tbody>" +
    	        					"<tr>" +
    			        				"<td>" + productIdData + "</td>" +
    			        			  	"<td>" + quantityData + "</td>" +
    			        			  	"<td>" + getUom(uomIdData) + "</td>" +
    			        			"</tr>" +
    			        		"</tbody>";
            	}
            	details += "</table>";
            	detailsData.push(details);
                return detailsData;
            },
            ready: function()
            {
           	 $("#jqxgridStock").jqxTreeGrid('selectRow', '2');
            },
	        columns: [
	        	{ text: '${uiLabelMap.StockProductIdForLocationInFacilityForLocation}', dataField: 'locationCode', minwidth: 200},
	            { text: '${uiLabelMap.Description}', dataField: 'description', minwidth: 120 },
            ]
	 });
}

function loadFunctionStockProductInLocation(dataSoureInput){
	var source =
	{
		dataType: "json",
	    dataFields: [
	        { name: 'locationId', type: 'string' },         
	    	{ name: 'locationCode', type: 'string' },
	    	{ name: 'parentLocationId', type: 'string' },
	    	{ name: 'description', type: 'string' },
	    	{ name: 'locationIdTranfer', type: 'string' },
	    	{ name: 'productTranfer', type: 'string' },
	    	{ name: 'quantityTranfer', type: 'string' },
	    ],
	    hierarchy:
	    {
	    	keyDataField: { name: 'locationId' },
	        parentDataField: { name: 'parentLocationId' }
	    },
	    id: 'locationId',
	    localData: dataSoureInput
    };
	updateBoundDataTreeGirdRemain(source);
}


function loadDataAndDetailJqxgridStockTranfer(source, rowDetail){
	var dataAdapter = new $.jqx.dataAdapter(source,{
    	beforeLoadComplete: function (records) {
	    	for (var x = 0; x < records.length; x++) {
	    		for(var key in rowDetail){
	    			if(records[x].locationId == key){
	    				records[x].rowDetailData = rowDetail[key];
	    			}
	    		}
	    	}
	    	return records;
    	}
    });
	$("#jqxgridStockTranfer").jqxTreeGrid
	({
	    	width: '100%',
	        source: dataAdapter,
	        columnsResize: true,
	        altRows: true,
	        pageable: true,
            selectionMode: 'multipleRows',
            sortable: true,
            editable:true,
            rowDetails: true,
            rowDetailsRenderer: function (rowKey, row) {
            	var indent = (1+row.level) * 20;
            	
            	var rowDetailDataInLocation = row.rowDetailData;
            	/*if(rowDetailDataInLocation == 'undefined' || quantityData == 'undefined' || uomIdData == 'undefined'){
            	}*/
            	var detailsData = [];
            	var details = "<table class='table table-striped table-bordered table-hover dataTable' style='margin: 10px; min-height: 95px; height: 95px; width:100%" + indent + "px;'>" +
    							"<thead>" +
    	        					"<tr>" +
    				    				"<th>" + '${uiLabelMap.ProductProductId}' + "</th>" +
    				    			  	"<th>" + '${uiLabelMap.Quantity}' + "</th>" +
    				    			  	"<th>" + '${uiLabelMap.QuantityUomId}' + "</th>" +
    				    		    "</tr>" +
    			    		    "</thead>";
            	for(var i in rowDetailDataInLocation){
            		var productIdData = rowDetailDataInLocation[i].productId;
            		var quantityData = rowDetailDataInLocation[i].quantity;
            		var uomIdData = rowDetailDataInLocation[i].uomId;
            		details += "<tbody>" +
    	        					"<tr>" +
    			        				"<td>" + productIdData + "</td>" +
    			        			  	"<td>" + quantityData + "</td>" +
    			        			  	"<td>" + getUom(uomIdData) + "</td>" +
    			        			"</tr>" +
    			        		"</tbody>";
            	}
            	details += "</table>";
            	detailsData.push(details);
                return detailsData;
            },
            ready: function()
            {
            	$("#jqxgridStockTranfer").jqxTreeGrid('selectRow', '2');
                $("#dialogTranferProductToLocation").on('close', function () {
                    // enable jqxTreeGrid.
                    $("#jqxgridStockTranfer").jqxTreeGrid({ disabled: false });
                });
                
            },
	        columns: [
	        	{ text: '${uiLabelMap.FacilitylocationSeqIdCurrent}', dataField: 'locationCode', minwidth: 100, editable:false},
            ]
	 });
	
	$("#jqxgridStockTranfer").on('rowDoubleClick', function (event) {
		$("#dialogTranferProductToLocation").jqxWindow('open');
		
        var args = event.args;
        var key = args.key;
        var row = args.row;
        // update the widgets inside jqxWindow.
        $("#dialogTranferProductToLocation").jqxWindow('setTitle', "${uiLabelMap.FacilitylocationSeqIdCurrent}: " + row.locationCode);
        $("#locationIdCurrent").val(row.locationId);
        $("#locationCodeCurrent").val(row.locationCode);
        // disable jqxTreeGrid.
        loadDetailsJqxGird([], []);
        $("#locationIdTranfer").jqxDropDownList('uncheckAll');
        $("#jqxgridStockTranfer").jqxTreeGrid({ disabled: true });
    });
}

function loadDataJqxDropDownListByLocationIdTranfer(sourceData){
	$("#locationIdTranfer").jqxDropDownList({source: sourceData, placeHolder: "Please select" , checkboxes: true, displayMember: 'locationCode', valueMember: 'locationId'});
}

function loadDataRowDeatailByjqxTreeGirdClickJqxButtonStockLocation(){
    if(dataRow.length == 0){
    	$("#notificationContentSelectMyTree").text('${StringUtil.wrapString(uiLabelMap.SelectStockProductJqxTreeGird)}');
     	$("#jqxMessageNotificationSelectMyTree").jqxNotification('open');
    }
    else{
    	checkParentLocationIdInDataRowMoveProduct(dataRow);
    }
    loadData();
	dataRow = [];
}

function checkParentLocationIdInDataRowMoveProduct(data){
	
	var rowAll = $("#myTree").jqxTreeGrid('getRows');
    var rowsData = new Array();
    var traverseTree = function(rowAll)
    {
        for(var i = 0; i < rowAll.length; i++)
        {
        	var objectRowData = {
    			locationId: rowAll[i].locationId,
    			parentLocationId: rowAll[i].parentLocationId,
    			locationCode: rowAll[i].locationCode,
    			description: rowAll[i].description,
        	};
            rowsData.push(objectRowData);
            if (rowAll[i].records)
            {
                traverseTree(rowAll[i].records);
            }
        }
    };
    traverseTree(rowAll);
    var iIndex = 0;
    var tmpList = [];
    lbl1: for(i = 0; i < rowsData.length;i++){
    	var tmp1 = rowsData[i];
    	for(j = 0; j < data.length; j++){
    		if(data[j].locationId == tmp1.locationId){
    			continue lbl1;
    		}
    	}
    	tmpList[iIndex++] = tmp1;
    }
	
	var uniquesLocationIdTmpList = [];
	var parentLocationIdInDataRow = [];
	lbl:for(var i = 0; i < data.length; i++){
			for(var j = 0; j < data.length; j++){
				if(data[i].locationId == data[j].parentLocationId){
					continue lbl;
				}
			}
			parentLocationIdInDataRow.push(data[i].locationId);
	}
	var parentLocationIdIntmpList = [];
	lbl2:for(var i = 0; i < tmpList.length; i++){
			for(var j = 0; j < tmpList.length; j++){
				if(tmpList[i].locationId == tmpList[j].parentLocationId){
					continue lbl2;
				}
			}
			parentLocationIdIntmpList.push(tmpList[i].locationId);
	}
	
	uniquesLocationIdTmpList = [];
	for(var i=0;i<parentLocationIdIntmpList.length;i++){
		var str=parentLocationIdIntmpList[i];
    	if(uniquesLocationIdTmpList.indexOf(str)==-1){
    		uniquesLocationIdTmpList.push(str);
        }
    }
	
	uniquesLocationId = [];
	for(var i=0;i<parentLocationIdInDataRow.length;i++){
		var str=parentLocationIdInDataRow[i];
    	if(uniquesLocationId.indexOf(str)==-1){
    		uniquesLocationId.push(str);
        }
    }
	
	loadDataRowToJqxGirdTreeMoveProduct(uniquesLocationId, uniquesLocationIdTmpList);
}

function loadDataRowToJqxGirdTreeMoveProduct(dataLocationId, dataLocationIdRemain){
	if(dataLocationIdRemain.length != 0){
		$.ajax({
			  url: "loadDataRowToJqxGirdTree",
			  type: "POST",
			  data: {locationId: dataLocationId, locationIdRemain: dataLocationIdRemain},
			  dataType: "json",
			  success: function(data) {
			  }    
		}).done(function(data) {
			var listLocationFacility = data["listLocationFacility"];
			var listLocationFacilityRemain = data["listLocationFacilityRemain"];
			loadFunctionAddProductInLocation(listLocationFacility);
			loadFunctionStockProductInLocation(listLocationFacilityRemain);
			loadDataJqxDropDownListByLocationIdTranfer(listLocationFacility);
			$("#locationCodeCurrent").jqxInput({ disabled: true});
	        $("#locationIdCurrent").jqxInput();
	    	$("#myTree").jqxTreeGrid('clearSelection');
	        $("#StockProductFromLocationToLocationInFacility").jqxWindow('open');
		});
	}
	else{
		$("#notificationContentSelectMyTreeFullSelect").text('${StringUtil.wrapString(uiLabelMap.DSCheckSelectTreeFullSelect)}');
     	$("#jqxMessageNotificationSelectMyTreeFullSelect").jqxNotification('open');
	}
}

$('#jqxButtonStockLocation').click(function () {
	loadDataRowDeatailByjqxTreeGirdClickJqxButtonStockLocation();
});

function loadDataDetailByTreeGirdContraryWhenClickSaveContrary(){
    if(dataRow.length == 0){
    	$("#notificationContentSelectMyTree").text('${StringUtil.wrapString(uiLabelMap.SelectStockProductJqxTreeGird)}');
     	$("#jqxMessageNotificationSelectMyTree").jqxNotification('open');
    }else{
    	checkParentLocationIdInDataRowMoveProductContrary(dataRow);
    }
    loadData();
	dataRow = [];
}

function loadDataJqxDropDownListByLocationIdTranferContrary(dataSource){
	$("#locationIdTranferContrary").jqxDropDownList({source: dataSource, placeHolder: "Please select" , checkboxes: true,displayMember: 'locationCode', valueMember: 'locationId'});
}

function checkParentLocationIdInDataRowMoveProductContrary(data){
	var rowAll = $("#myTree").jqxTreeGrid('getRows');
    var rowsData = new Array();
    var traverseTree = function(rowAll)
    {
        for(var i = 0; i < rowAll.length; i++)
        {
        	var objectRowData = {
    			locationId: rowAll[i].locationId,
    			parentLocationId: rowAll[i].parentLocationId,
    			locationCode: rowAll[i].locationCode,
    			description: rowAll[i].description,
        	};
            rowsData.push(objectRowData);
            if (rowAll[i].records)
            {
                traverseTree(rowAll[i].records);
            }
        }
    };
    traverseTree(rowAll);
    var iIndex = 0;
    var tmpList = [];
    lbl1: for(i = 0; i < rowsData.length;i++){
    	var tmp1 = rowsData[i];
    	for(j = 0; j < data.length; j++){
    		if(data[j].locationId == tmp1.locationId){
    			continue lbl1;
    		}
    	}
    	tmpList[iIndex++] = tmp1;
    }
	
	
	var parentLocationIdInDataRow = [];
	lbl:for(var i = 0; i < data.length; i++){
			for(var j = 0; j < data.length; j++){
				if(data[i].locationId == data[j].parentLocationId){
					continue lbl;
				}
			}
			parentLocationIdInDataRow.push(data[i].locationId);
	}
	
	var parentLocationIdIntmpList = [];
	lbl2:for(var i = 0; i < tmpList.length; i++){
			for(var j = 0; j < tmpList.length; j++){
				if(tmpList[i].locationId == tmpList[j].parentLocationId){
					continue lbl2;
				}
			}
			parentLocationIdIntmpList.push(tmpList[i].locationId);
	}
	
	uniquesLocationId = [];
	for(var i=0;i<parentLocationIdInDataRow.length;i++){
		var str=parentLocationIdInDataRow[i];
    	if(uniquesLocationId.indexOf(str)==-1){
    		uniquesLocationId.push(str);
        }
    }
	
	uniquesLocationIdTmpList = [];
	for(var i=0;i<parentLocationIdIntmpList.length;i++){
		var str=parentLocationIdIntmpList[i];
    	if(uniquesLocationIdTmpList.indexOf(str)==-1){
    		uniquesLocationIdTmpList.push(str);
        }
    }
	
	loadDataRowToJqxGirdTreeMoveProductContrary(uniquesLocationId, uniquesLocationIdTmpList);
}

function loadDataRowToJqxGirdTreeMoveProductContrary(dataLocationId, dataLocationIdRemain){
	if(dataLocationIdRemain.length != 0){
		$.ajax({
			  url: "loadDataRowToJqxGirdTree",
			  type: "POST",
			  data: {locationId: dataLocationId, locationIdRemain: dataLocationIdRemain},
			  dataType: "json",
			  success: function(data) {
			  }    
		}).done(function(data) {
			var listLocationFacility = data["listLocationFacility"];
			var listLocationFacilityRemain = data["listLocationFacilityRemain"];
			loadFunctionAddProductInLocationContrary(listLocationFacility);
			loadFunctionStockProductInLocationContrary(listLocationFacility, listLocationFacilityRemain);
			loadDataJqxDropDownListByLocationIdTranferContrary(listLocationFacilityRemain);
			$("#locationCodeCurrentContrary").jqxInput({ disabled: true});
	        $("#locationIdCurrentContrary").jqxInput();
	    	$("#StockProductFromLocationToLocationInFacilityContrary").jqxWindow('open');
	    	$("#myTree").jqxTreeGrid('clearSelection');
		});
	}else{
		$("#notificationContentSelectMyTreeFullSelect").text('${StringUtil.wrapString(uiLabelMap.DSCheckSelectTreeFullSelect)}');
     	$("#jqxMessageNotificationSelectMyTreeFullSelect").jqxNotification('open');
	}
}

$('#jqxButtonStockLocationContrary').click(function () {
	loadDataDetailByTreeGirdContraryWhenClickSaveContrary();
});


function loadFunctionAddProductInLocationContrary(dataRow){
	var source =
	{
		dataType: "json",
	    dataFields: [
	        { name: 'locationId', type: 'string' },         
	    	{ name: 'facilityId', type: 'string' }, 
	    	{ name: 'locationCode', type: 'string' },
	    	{ name: 'parentLocationId', type: 'string' },
	    	{ name: 'locationFacilityTypeId', type: 'string' },
	    	{ name: 'description', type: 'string' },
	    ],
	    hierarchy:
	    {
	    	keyDataField: { name: 'locationId' },
	        parentDataField: { name: 'parentLocationId' }
	    },
	    id: 'locationId',
	    localData: dataRow
    };
	updateBounDataJqxTreeGirdContrary(source);
}

function updateBounDataJqxTreeGirdContrary(source){
	var facilityId = '${facilityId}';
	
	var listlocationFacilityMapOfJqxgridStockContrary;
	var rowDetailJqxgridStockContrary;
	$.ajax({
		  url: "loadListLocationFacility",
		  type: "POST",
		  data: {facilityId: facilityId},
		  dataType: "json",
		  success: function(data) {
			  listlocationFacilityMapOfJqxgridStockContrary = data["listlocationFacilityMap"];
			  rowDetailJqxgridStockContrary = data["listInventoryItemLocationDetailMap"]
		  }    
	}).done(function(data) {
		loadDataAndDetailJqxgridStockContrary(source, rowDetailJqxgridStockContrary);
	});
}

function loadDataAndDetailJqxgridStockContrary(source, rowDetailJqxgridStockContrary){
	var dataAdapter = new $.jqx.dataAdapter(source,{
    	beforeLoadComplete: function (records) {
	    	for (var x = 0; x < records.length; x++) {
	    		for(var key in rowDetailJqxgridStockContrary){
	    			if(records[x].locationId == key){
	    				records[x].rowDetailData = rowDetailJqxgridStockContrary[key];
	    			}
	    		}
	    	}
	    	return records;
    	}
    });
	
	$("#jqxgridStockContrary").jqxTreeGrid({
    	width: '100%',
        source: dataAdapter,
        pageable: true,
        columnsResize: true,
        altRows: true,
        selectionMode: 'multipleRows',
        sortable: true,
        rowDetails: true,
        rowDetailsRenderer: function (rowKey, row) {
        	var indent = (1+row.level) * 20;
        	
        	var rowDetailDataInLocation = row.rowDetailData;
        	/*if(rowDetailDataInLocation == 'undefined' || quantityData == 'undefined' || uomIdData == 'undefined'){
        	}*/
        	var detailsData = [];
        	var details = "<table class='table table-striped table-bordered table-hover dataTable' style='margin: 10px; min-height: 95px; height: 95px; width:100%" + indent + "px;'>" +
							"<thead>" +
	        					"<tr>" +
				    				"<th>" + '${uiLabelMap.ProductProductId}' + "</th>" +
				    			  	"<th>" + '${uiLabelMap.Quantity}' + "</th>" +
				    			  	"<th>" + '${uiLabelMap.QuantityUomId}' + "</th>" +
				    		    "</tr>" +
			    		    "</thead>";
        	for(var i in rowDetailDataInLocation){
        		var productIdData = rowDetailDataInLocation[i].productId;
        		var quantityData = rowDetailDataInLocation[i].quantity;
        		var uomIdData = rowDetailDataInLocation[i].uomId;
        		details += "<tbody>" +
	        					"<tr>" +
			        				"<td>" + productIdData + "</td>" +
			        			  	"<td>" + quantityData + "</td>" +
			        			  	"<td>" + getUom(uomIdData) + "</td>" +
			        			"</tr>" +
			        		"</tbody>";
        	}
        	details += "</table>";
        	detailsData.push(details);
            return detailsData;
        },
        ready: function()
        {
        	$("#jqxgridStockContrary").jqxTreeGrid('selectRow', '2');
        	$("#dialogTranferProductToLocationContrary").on('close', function () {
        		$("#jqxgridStockContrary").jqxTreeGrid({ disabled: false });
            });
        },
        columns: [
        	{ text: '${uiLabelMap.FacilitylocationSeqIdCurrent}', dataField: 'locationCode', minwidth: 200},
            { text: '${uiLabelMap.Description}', dataField: 'description', minwidth: 120 },
        ]
	});
		
	$("#jqxgridStockContrary").on('rowDoubleClick', function (event) {
		$("#dialogTranferProductToLocationContrary").jqxWindow('open');
		
	    var args = event.args;
	    var key = args.key;
	    var row = args.row;
	    // update the widgets inside jqxWindow.
	    $("#dialogTranferProductToLocationContrary").jqxWindow('setTitle', "${uiLabelMap.FacilitylocationSeqIdCurrent}: " + row.locationCode);
	    $("#locationIdCurrentContrary").val(row.locationId);
	    $("#locationCodeCurrentContrary").val(row.locationCode);
	    // disable jqxTreeGrid.
	    loadDetailsJqxGirdContrary([], []);
        $("#locationIdTranferContrary").jqxDropDownList('uncheckAll');
	    $("#jqxgridStockContrary").jqxTreeGrid({ disabled: true });
	});
}

function loadFunctionStockProductInLocationContrary(dataRow, dataSoureInput){
	var source =
	{
		dataType: "json",
	    dataFields: [
	        { name: 'locationId', type: 'string' },         
	    	{ name: 'locationCode', type: 'string' },
	    	{ name: 'parentLocationId', type: 'string' },
	    	{ name: 'description', type: 'string' },
	    	{ name: 'locationIdTranfer', type: 'string' },
	    	{ name: 'productTranfer', type: 'string' },
	    	{ name: 'quantityTranfer', type: 'string' },
	    ],
	    hierarchy:
	    {
	    	keyDataField: { name: 'locationId' },
	        parentDataField: { name: 'parentLocationId' }
	    },
	    id: 'locationId',
	    localData: dataSoureInput
    };
	updateBounDataJqxTreeGirdContraryRemain(source);
}

function updateBounDataJqxTreeGirdContraryRemain(source){
	var facilityId = '${facilityId}';
	var listlocationFacilityMapOfJqxgridStockContrary;
	var rowDetailJqxgridStockContrary;
	$.ajax({
		  url: "loadListLocationFacility",
		  type: "POST",
		  data: {facilityId: facilityId},
		  dataType: "json",
		  success: function(data) {
			  rowDetailJqxgridStockContrary = data["listInventoryItemLocationDetailMap"]
		  }    
	}).done(function(data) {
		loadDataAndDetailJqxgridStockTranferContrary(source, rowDetailJqxgridStockContrary);
	});
}

function loadDataAndDetailJqxgridStockTranferContrary(source, rowDetailJqxgridStockContrary){
	var dataAdapter = new $.jqx.dataAdapter(source,{
    	beforeLoadComplete: function (records) {
	    	for (var x = 0; x < records.length; x++) {
	    		for(var key in rowDetailJqxgridStockContrary){
	    			if(records[x].locationId == key){
	    				records[x].rowDetailData = rowDetailJqxgridStockContrary[key];
	    			}
	    		}
	    	}
	    	return records;
    	}
    });
	$("#jqxgridStockTranferContrary").jqxTreeGrid
	({
	    	width: '100%',
	        source: dataAdapter,
	        pageable: true,
	        columnsResize: true,
	        altRows: true,
            selectionMode: 'multipleRows',
            sortable: true,
            editable:true,
            rowDetails: true,
            rowDetailsRenderer: function (rowKey, row) {
            	var indent = (1+row.level) * 20;
            	
            	var rowDetailDataInLocation = row.rowDetailData;
            	/*if(rowDetailDataInLocation == 'undefined' || quantityData == 'undefined' || uomIdData == 'undefined'){
            	}*/
            	var detailsData = [];
            	var details = "<table class='table table-striped table-bordered table-hover dataTable' style='margin: 10px; min-height: 95px; height: 95px; width:100%" + indent + "px;'>" +
    							"<thead>" +
    	        					"<tr>" +
    				    				"<th>" + '${uiLabelMap.ProductProductId}' + "</th>" +
    				    			  	"<th>" + '${uiLabelMap.Quantity}' + "</th>" +
    				    			  	"<th>" + '${uiLabelMap.QuantityUomId}' + "</th>" +
    				    		    "</tr>" +
    			    		    "</thead>";
            	for(var i in rowDetailDataInLocation){
            		var productIdData = rowDetailDataInLocation[i].productId;
            		var quantityData = rowDetailDataInLocation[i].quantity;
            		var uomIdData = rowDetailDataInLocation[i].uomId;
            		details += "<tbody>" +
    	        					"<tr>" +
    			        				"<td>" + productIdData + "</td>" +
    			        			  	"<td>" + quantityData + "</td>" +
    			        			  	"<td>" + getUom(uomIdData) + "</td>" +
    			        			"</tr>" +
    			        		"</tbody>";
            	}
            	details += "</table>";
            	detailsData.push(details);
                return detailsData;
            },
            ready: function()
            {
            	$("#jqxgridStockTranferContrary").jqxTreeGrid('selectRow', '1');
                
            },
	        columns: [
	        	{ text: '${uiLabelMap.StockProductIdForLocationInFacilityForLocation}', dataField: 'locationCode', minwidth: 200, editable:false},
	        	{ text: '${uiLabelMap.Description}', dataField: 'description', minwidth: 120 },
            ]
	 });
}



$('#locationIdTranferContrary').on('close', function (event) {
	var dataSoureValues = [];
	var dataSoureLable = [];
	var items = $("#locationIdTranferContrary").jqxDropDownList('getCheckedItems');
	for(var values in items){
		dataSoureValues.push(items[values].value);
		dataSoureLable.push(items[values].label);
	}
	loadProductByLocationIdInFacilityContrary(dataSoureValues, dataSoureLable);
});



$('#locationIdTranfer').on('close', function (event) {
	var dataSoureValues = [];
	var dataSoureLable = [];
	var items = $("#locationIdTranfer").jqxDropDownList('getCheckedItems');
	if(items.length == 0){
	}
	else{
		for(var values in items){
			dataSoureValues.push(items[values].value);
			dataSoureLable.push(items[values].label);
		}
		loadProductByLocationIdInFacility(dataSoureValues, dataSoureLable);
	}
});



function loadProductByLocationIdInFacility(locationIdTranferValue, locationIdTranferLable) {
	var listMapProductLocationInFacility;
	$.ajax({
		  url: "loadProductByLocationIdInFacility",
		  type: "POST",
		  data: {locationIdTranfer: locationIdTranferValue},
		  dataType: "json",
		  success: function(data) {
			  listMapProductLocationInFacility = data["listMapProductLocationInFacility"];
		  }    
	}).done(function(data) {
		resultLoadProductByLocationIdInFacility(listMapProductLocationInFacility, locationIdTranferValue, locationIdTranferLable);
	});
}

function loadProductByLocationIdInFacilityContrary(locationIdTranferValue, locationIdTranferLable) {
	var listMapProductLocationInFacility;
	$.ajax({
		  url: "loadProductByLocationIdInFacility",
		  type: "POST",
		  data: {locationIdTranfer: locationIdTranferValue},
		  dataType: "json",
		  success: function(data) {
			  listMapProductLocationInFacility = data["listMapProductLocationInFacility"];
		  }    
	}).done(function(data) {
		resultLoadProductByLocationIdInFacility(listMapProductLocationInFacility, locationIdTranferValue, locationIdTranferLable);
	});
}



function resultLoadProductByLocationIdInFacility(result, locationIdTranfer, locationIdTranferLable){
	var locationCode = locationIdTranferLable;
	var locationId = locationIdTranfer;
	var data = [];
	for(var i in locationCode){
		var locationFacility = {};
		locationFacility["locationId"] = locationId[i];
		locationFacility["locationCode"] = locationCode[i];
		data.push(locationFacility);
	}
	var source =
    {
        localdata: data,
        datatype: "local",
        datafields:
        [
         	{ name: 'locationId', type: 'string' },
            { name: 'locationCode', type: 'string' },
        ]
    };
    var dataAdapter = new $.jqx.dataAdapter(source);
    loadRowsDeatilsOfjqxgridProductByLocationInFacility(dataAdapter, result, locationId);
}

function loadRowsDeatilsOfjqxgridProductByLocationInFacility(dataAdapter, result, resultLocationId){
	var arrayValue;
	var arrayRowDetails = new Array();
	
	var values = [];
	for(var i = 0; i < resultLocationId.length;  i++){
		var locationId = resultLocationId[i];
		for (var k in result) {
		  if(locationId == k){
			  if (result.hasOwnProperty(k)) {
    	    	    values.push(result[k]);
    	    	  }
		  }
	    	}
	    	var values = Object.getOwnPropertyNames(result).map(function(key) {
	    	    return result[key];
	    	});
		
	}
	
	var inventoryItemId = [];
	var productId = new Array();
	var quantity = new Array();
	var uomId = new Array();
	var locationIdData = new Array();
	for (var valueArray in values){
		var arrayValue = values[valueArray];
		for(var a in arrayValue){
			inventoryItemId.push(arrayValue[a].inventoryItemId);
			locationIdData.push(arrayValue[a].locationId);
			productId.push(arrayValue[a].productId);
			quantity.push(arrayValue[a].quantity);
			uomId.push(arrayValue[a].uomId);
		}
	}
	
	for(var i = 0; i < locationIdData.length; i++){
		var inventoryItemIdDetails = inventoryItemId[i];
		var locationIdDetails = locationIdData[i];
		var quantityDetails = quantity[i];
		var productIdDetails = productId[i];
		var uomIdDetails = uomId[i];
		arrayValue = {
			inventoryItemId: inventoryItemIdDetails,
			locationId: locationIdDetails,
			productId: productIdDetails,
			quantity: quantityDetails,
			uomId: uomIdDetails,
		};
		arrayRowDetails.push(arrayValue);
	}
	loadDetailsJqxGird(arrayRowDetails, dataAdapter);
	loadDetailsJqxGirdContrary(arrayRowDetails, dataAdapter);
}

var productDataInLocation = [];
function loadDetailsJqxGird(arrayRowDetails, dataAdapter){
	var sourceRowDetails =
    {
        localdata: arrayRowDetails,
        datatype: "local",
        datafields:
        [
         	{ name: 'inventoryItemId', type: 'string' },
            { name: 'locationId', type: 'string' },
            { name: 'productId', type: 'string' },
            { name: 'quantity', type: 'number' },
            { name: 'uomId', type: 'string' }
        ],
        addrow: function (rowid, rowdata, position, commit) {
            commit(true);
        },
    };
    var ordersDataAdapter = new $.jqx.dataAdapter(sourceRowDetails, { autoBind: true });
    orders = ordersDataAdapter.records;
    var nestedGrids = new Array();
    
    // create nested grid.
    var initrowdetails = function (index, parentElement, gridElement, record) {
        var id = record.uid.toString();
        var grid = $($(parentElement).children()[0]);
        nestedGrids[index] = grid;
        var filtergroup = new $.jqx.filter();
        var filter_or_operator = 1;
        var filtervalue = id;
        var filtercondition = 'equal';
        var filter = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
        // fill the orders depending on the id.
        var ordersbyid = [];
        for (var m = 0; m < orders.length; m++) {
        	if (record.locationId == orders[m]["locationId"]){
        		ordersbyid.push(orders[m]);
        	}
        }
        var orderssource = { datafields: [
            { name: 'inventoryItemId', type: 'string' },                              
            { name: 'locationId', type: 'string' },
            { name: 'productId', type: 'string' },
            { name: 'quantity', type: 'string' },
            { name: 'quantityTranfer', type: 'string' },
            { name: 'uomId', type: 'string' },
        ],
            id: 'locationId',
            localdata: ordersbyid
        }
        
        var nestedGridAdapter = new $.jqx.dataAdapter(orderssource);
        if (grid != null) {
            grid.jqxGrid({
                source: nestedGridAdapter, width: '100%', height: '100%',
                selectionmode: 'checkbox',
                editable: true,
                columns: [
                  { text: '${uiLabelMap.ProductProductId}', datafield: 'productId', minwidth: 200, editable: false},
                  { text: '${uiLabelMap.QuantityCurrent}', datafield: 'quantity', width: 150, editable: false },
                  { text: '${uiLabelMap.QuantityTransferSum}', datafield: 'quantityTranfer', width: 150, editable: true },
                  { text: '${uiLabelMap.QuantityUomId}', datafield: 'uomId', width: 150 , editable: false,
                	  cellsrenderer: function(row, colum, value){
   				       var data = grid.jqxGrid('getrowdata', row);
   				       var uomId = data.uomId;
   				       var uomId = getUom(uomId);
   				       return '<span>' + uomId + '</span>';
   				   	  }
                  },
               ]
            });
            grid.on('rowselect', function (event) {
            	var rowindex1 = grid.jqxGrid('getselectedrowindex');
                var data1 = grid.jqxGrid('getrowdata', rowindex1);
                productDataInLocation.push(data1);
            });
            grid.on('rowunselect', function (event) {
            	var row = args.row;
            	var ii = productDataInLocation.indexOf(row);
            	productDataInLocation.splice(ii, 1);
            });
        }
        
    }    
    loadJqxGirdByJqxgridProductByLocationInFacility(dataAdapter, initrowdetails);
}

function loadJqxGirdByJqxgridProductByLocationInFacility(dataAdapter, initrowdetails){
	$("#jqxgridProductByLocationInFacility").jqxGrid(
	{
	    width: '100%',
	    source: dataAdapter,
	    columnsresize: true,
	    pageable: true,
        rowdetails: true,
        initrowdetails: initrowdetails,
        rowdetailstemplate: { rowdetails: "<div id='grid' style='margin: 10px;'></div>", rowdetailsheight: 220, rowdetailshidden: true },
        ready: function () {
            $("#jqxgridProductByLocationInFacility").jqxGrid('showrowdetails', 1);
        },
	    columns: [
	      { text: '${uiLabelMap.StockProductIdForLocationInFacilityForLocation}', datafield: 'locationCode', minwidth: 120 },
	    ]
	});
}

function tranfersProductFromLocationToLocationInFacility(){
	var locationIdCurrent = $('#locationIdCurrent').val();
	var inventoryItemIdTranfers = [];
	var locationIdTranfers = [];
	var productIdTranfers = [];
	var quantityCurrentTranfers = [];
	var quantityTranferTranfer = [];
	var uomIdTranfer = [];
	
	if(productDataInLocation.length == 0){
		$("#notificationCheckSelectDropDownToTranfer").text('${StringUtil.wrapString(uiLabelMap.DSCheckSelectDropDownToTranfer)}');
     	$("#jqxNotificationSelectDropDownToTranfer").jqxNotification('open');
	}else{
		for(var i in productDataInLocation){
			if((typeof productDataInLocation[i] !== "undefined")){
				for(var i in productDataInLocation){
					inventoryItemIdTranfers.push(productDataInLocation[i].inventoryItemId);
					locationIdTranfers.push(productDataInLocation[i].locationId);
					productIdTranfers.push(productDataInLocation[i].productId);
					quantityCurrentTranfers.push(productDataInLocation[i].quantity);
					quantityTranferTranfer.push(productDataInLocation[i].quantityTranfer);
					uomIdTranfer.push(productDataInLocation[i].uomId);
				}
				
				if(productDataInLocation.length == 0){
					$("#notificationContentNested").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityTransferSum)}');
					$("#jqxNotificationNested").jqxNotification('open');
				}else{
					for(var i in quantityTranferTranfer){
						if((typeof quantityTranferTranfer[i] !== "undefined")){
							if((quantityTranferTranfer[i].length) != 0){
								$.ajax({
								  url: "tranfersProductFromLocationToLocationInFacility",
								  type: "POST",
								  data: {inventoryItemIdTranfers: inventoryItemIdTranfers, locationIdCurrent: locationIdCurrent, locationIdTranfers: locationIdTranfers, productIdTranfers: productIdTranfers, quantityCurrentTranfers: quantityCurrentTranfers, quantityTranferTranfer: quantityTranferTranfer, uomIdTranfer: uomIdTranfer},
								  dataType: "json",
								  success: function(data) {
								  }    
								}).done(function(data) {
									var value = data["value"];
									if(value == "errorQuantityTranfer"){
										$("#notificationQuantityTranfer").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityCurrent)}');
								     	$("#jqxNotificationQuantityTranfer").jqxNotification('open');
									}
									else{
										loadData();
										$('#dialogTranferProductToLocation').jqxWindow('close');
										$("#notificationContentSuccessMoveProduct2").text('${StringUtil.wrapString(uiLabelMap.StockLocationInventoryItemSuccess)}');
										$("#jqxMessageNotificationSuccessMoveProduct2").jqxNotification('open');
									}
								});
							}
							else{
								$("#notificationContentNested").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityTransferSum)}');
						     	$("#jqxNotificationNested").jqxNotification('open');
							}
						}
						else{
							$("#notificationContentNested").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityTransferSum)}');
					     	$("#jqxNotificationNested").jqxNotification('open');
						}
					}
				}
			}else{
				$("#notificationCheckInventoryItemIdExists").text('${StringUtil.wrapString(uiLabelMap.DSCheckInventoryItemIdExists)}');
		     	$("#jqxNotificationCheckInventoryItemIdExists").jqxNotification('open');
			}
		}
	}
}

$("#save").click(function (){
	tranfersProductFromLocationToLocationInFacility();
});



var productDataInLocationContrary = [];
function loadDetailsJqxGirdContrary(arrayRowDetails, dataAdapter){
	var sourceRowDetails =
    {
        localdata: arrayRowDetails,
        datatype: "local",
        datafields:
        [
         	{ name: 'inventoryItemId', type: 'string' },
            { name: 'locationId', type: 'string' },
            { name: 'productId', type: 'string' },
            { name: 'quantity', type: 'number' },
            { name: 'uomId', type: 'string' }
        ],
        addrow: function (rowid, rowdata, position, commit) {
            commit(true);
        },
    };
    var ordersDataAdapter = new $.jqx.dataAdapter(sourceRowDetails, { autoBind: true });
    orders = ordersDataAdapter.records;
    var nestedGrids = new Array();
    
    // create nested grid.
    var initrowdetails = function (index, parentElement, gridElement, record) {
        var id = record.uid.toString();
        var grid = $($(parentElement).children()[0]);
        nestedGrids[index] = grid;
        var filtergroup = new $.jqx.filter();
        var filter_or_operator = 1;
        var filtervalue = id;
        var filtercondition = 'equal';
        var filter = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
        // fill the orders depending on the id.
        var ordersbyid = [];
        for (var m = 0; m < orders.length; m++) {
        	if (record.locationId == orders[m]["locationId"]){
        		ordersbyid.push(orders[m]);
        	}
        }
        var orderssource = { datafields: [
            { name: 'inventoryItemId', type: 'string' },                              
            { name: 'locationId', type: 'string' },
            { name: 'productId', type: 'string' },
            { name: 'quantity', type: 'string' },
            { name: 'quantityTranfer', type: 'string' },
            { name: 'uomId', type: 'string' },
        ],
            id: 'locationId',
            localdata: ordersbyid
        }
        
        var nestedGridAdapter = new $.jqx.dataAdapter(orderssource);
        if (grid != null) {
            grid.jqxGrid({
                source: nestedGridAdapter, width: '100%', height: '100%',
                selectionmode: 'checkbox',
                editable: true,
                columns: [
                  { text: '${uiLabelMap.ProductProductId}', datafield: 'productId', minwidth: 200, editable: false},
                  { text: '${uiLabelMap.QuantityCurrent}', datafield: 'quantity', width: 150, editable: false },
                  { text: '${uiLabelMap.QuantityTransferSum}', datafield: 'quantityTranfer', width: 150, editable: true },
                  { text: '${uiLabelMap.QuantityUomId}', datafield: 'uomId', width: 150 , editable: false,
                	  cellsrenderer: function(row, colum, value){
   				       var data = grid.jqxGrid('getrowdata', row);
   				       var uomId = data.uomId;
   				       var uomId = getUom(uomId);
   				       return '<span>' + uomId + '</span>';
   				   	  }
                  },
               ]
            });
            grid.on('rowselect', function (event) {
            	var rowindex1 = grid.jqxGrid('getselectedrowindex');
                var data1 = grid.jqxGrid('getrowdata', rowindex1);
                productDataInLocationContrary.push(data1);
            });
            grid.on('rowunselect', function (event) {
            	var row = args.row;
            	var ii = productDataInLocation.indexOf(row);
            	productDataInLocationContrary.splice(ii, 1);
            });
            grid.jqxTooltip({ content: '${uiLabelMap.EnterQuantityTransferSum}', position: 'mouse', name: 'movieTooltip'});
        }
        
    }    
    
    $("#jqxgridProductByLocationInFacilityContrary").jqxGrid(
	{
	    width: '100%',
	    source: dataAdapter,
	    columnsresize: true,
	    pageable: true,
        rowdetails: true,
        initrowdetails: initrowdetails,
        rowdetailstemplate: { rowdetails: "<div id='grid' style='margin: 10px;'></div>", rowdetailsheight: 220, rowdetailshidden: true },
        ready: function () {
            $("#jqxgridProductByLocationInFacilityContrary").jqxGrid('showrowdetails', 1);
        },
	    columns: [
	      { text: '${uiLabelMap.StockProductIdForLocationInFacilityForLocation}', datafield: 'locationCode', minwidth: 120 },
	    ]
	});
}

$("#jqxNotificationNestedContrary").jqxNotification({ width: "100%", appendContainer: "#contentNotificationContentNestedContrary", opacity: 0.9, autoClose: true, template: "error" });
function tranfersProductFromLocationToLocationInFacilityContrary(){
	var locationIdCurrent = $('#locationIdCurrentContrary').val();
	var inventoryItemIdTranfers = [];
	var locationIdTranfers = [];
	var productIdTranfers = [];
	var quantityCurrentTranfers = [];
	var quantityTranferTranfer = [];
	var uomIdTranfer = [];
	
	if(productDataInLocationContrary.length == 0){
		$("#notificationCheckSelectDropDownToTranferContrary").text('${StringUtil.wrapString(uiLabelMap.DSCheckSelectDropDownToTranfer)}');
     	$("#jqxNotificationSelectDropDownToTranferContrary").jqxNotification('open');
	}else{
		for(var i in productDataInLocationContrary){
			if((typeof productDataInLocationContrary[i] !== "undefined")){
				for(var i in productDataInLocationContrary){
					inventoryItemIdTranfers.push(productDataInLocationContrary[i].inventoryItemId);
					locationIdTranfers.push(productDataInLocationContrary[i].locationId);
					productIdTranfers.push(productDataInLocationContrary[i].productId);
					quantityCurrentTranfers.push(productDataInLocationContrary[i].quantity);
					quantityTranferTranfer.push(productDataInLocationContrary[i].quantityTranfer);
					uomIdTranfer.push(productDataInLocationContrary[i].uomId);
				}
				if(productDataInLocationContrary.length == 0){
					$("#notificationContentNestedContrary").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityTransferSum)}');
					$("#jqxNotificationNestedContrary").jqxNotification('open');
				}else{
					for(var i in quantityTranferTranfer){
						if((typeof quantityTranferTranfer[i] !== "undefined")){
							if((quantityTranferTranfer[i].length) != 0){
								$.ajax({
								  url: "tranfersProductFromLocationToLocationInFacility",
								  type: "POST",
								  data: {inventoryItemIdTranfers: inventoryItemIdTranfers, locationIdCurrent: locationIdCurrent, locationIdTranfers: locationIdTranfers, productIdTranfers: productIdTranfers, quantityCurrentTranfers: quantityCurrentTranfers, quantityTranferTranfer: quantityTranferTranfer, uomIdTranfer: uomIdTranfer},
								  dataType: "json",
								  success: function(data) {
								  }    
								}).done(function(data) {
									var value = data["value"];
									if(value == "errorQuantityTranfer"){
										$("#notificationQuantityTranferContrary").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityCurrent)}');
								     	$("#jqxNotificationQuantityTranferContrary").jqxNotification('open');
										
									}else{
										loadData();
										loadDataDetailByTreeGirdContraryWhenClickSaveContrary();
										$('#dialogTranferProductToLocationContrary').jqxWindow('close');
										$("#jqxgridStockContrary").jqxTreeGrid('updateBoundData');
										$("#jqxgridStockTranferContrary").jqxTreeGrid('updateBoundData');
										$("#notificationContentSuccessMoveProduct").text('${StringUtil.wrapString(uiLabelMap.StockLocationInventoryItemSuccess)}');
										$("#jqxMessageNotificationSuccessMoveProduct").jqxNotification('open');
									}
								});
							}
							else{
								$("#notificationContentNestedContrary").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityTransferSum)}');
						     	$("#jqxNotificationNestedContrary").jqxNotification('open');
							}
						}
						else{
							$("#notificationContentNestedContrary").text('${StringUtil.wrapString(uiLabelMap.CheckQuantityTransferSum)}');
					     	$("#jqxNotificationNestedContrary").jqxNotification('open');
						}
					}
				}
			}else{
				$("#notificationCheckInventoryItemIdExistsContrary").text('${StringUtil.wrapString(uiLabelMap.DSCheckInventoryItemIdExists)}');
		     	$("#jqxNotificationCheckInventoryItemIdExistsContrary").jqxNotification('open');
			}
		}
	}
}

$("#saveContrary").click(function (){
	tranfersProductFromLocationToLocationInFacilityContrary();
});


$("#alterAddProduct").click(function (){
	var data = $('#jqxTreeGridAddProduct').jqxTreeGrid('getRows');
	var locationId = new Array();
	var productId = new Array();
	var inventoryItemId = new Array();
	var quantity = new Array();
	var uomId = new Array();
	var value = [];
	for(var rows in data){
		value = data[rows];
	}
	locationId.push(value.locationId);
	productId.push(value.productId);
	inventoryItemId.push(value.inventoryItemId);
	quantity.push(value.quantity);
	uomId.push(value.uomId);
	if(value.productId == undefined || value.inventoryItemId == undefined || value.quantity == undefined || value.uomId == undefined){
		$("#notificationContentInventoryItemLocationError").text('${StringUtil.wrapString(uiLabelMap.DSCheckIsEmptyCreateLocationFacility)}');
		$("#jqxNotificationInventoryItemLocationError").jqxNotification('open');
	}
	else{
		$.ajax({
			url: "addProductInLocationFacility",
			type: "POST",
			data: {locationId : locationId, facilityId: facilityId, productId: productId, inventoryItemId: inventoryItemId, quantity: quantity, uomId: uomId},
			dataType: "json",
			success: function(data) {
			}    
		}).done(function(data) {
			loadData();
			$('#AddProductInLocationFacility').jqxWindow('close');
			$("#notificationContentInventoryItemLocationSuccess").text('${StringUtil.wrapString(uiLabelMap.NotifiCreateSucess)}');
			$("#jqxNotificationInventoryItemLocationSuccess").jqxNotification('open');
		});
	}	
});



</script>




<script>    
    $(document).ready(function () {
    	loadData();
    	loadParentLocationFacilityTypeIdInFacility();
    });

    
    function loadData() {
    	var facilityId = '${facilityId}';
    	var listlocationFacilityMap;
    	var listInventoryItemLocationDetailMap;
    	$.ajax({
    		  url: "loadListLocationFacility",
    		  type: "POST",
    		  data: {facilityId: facilityId},
    		  dataType: "json",
    		  success: function(data) {
    			  listlocationFacilityMap = data["listlocationFacilityMap"];
    			  listInventoryItemLocationDetailMap = data["listInventoryItemLocationDetailMap"]
    		  }    
    	}).done(function(data) {
    		renderTree(listlocationFacilityMap, listInventoryItemLocationDetailMap);
    	});
    }
    

    
    
    function renderTree(dataList, rowDetails) {
    	var source =
    	{
			dataType: "json",
		    dataFields: [
		        { name: 'locationId', type: 'string' },         
		    	{ name: 'facilityId', type: 'string' }, 
		    	{ name: 'locationCode', type: 'string' },
		    	{ name: 'parentLocationId', type: 'string' },
		    	{ name: 'locationFacilityTypeId', type: 'string' },
		    	{ name: 'description', type: 'string' },
		    ],
		    hierarchy:
		    {
		    	keyDataField: { name: 'locationId' },
		        parentDataField: { name: 'parentLocationId' }
		    },
		    id: 'locationId',
		    localData: dataList
	    };
    	
	    var dataAdapter = new $.jqx.dataAdapter(source,{
	    	beforeLoadComplete: function (records) {
    	    	for (var i = 0; i < records.length; i++) {
    	    		for(var k in rowDetails){
    	    			if(records[i].locationId == k){
    	    				records[i].rowDetailData = rowDetails[k];
    	    			}
    	    		}
    	    	}
    	    	return records;
	    	}
	     });
         // create Tree Grid
	     $("#myTree").jqxTreeGrid(
	     {
	     	width: '100%',
	        source: dataAdapter,
	        rowDetails: true,
	        rowDetailsRenderer: function (rowKey, row) {
	        	var indent = (1+row.level) * 20;
	        	
	        	var rowDetailDataInLocation = row.rowDetailData;
	        	
	        	if(rowDetailDataInLocation == 'undefined' || quantityData == 'undefined' || uomIdData == 'undefined'){
	        	}
	        	var detailsData = [];
	        	var details = "<table class='table table-striped table-bordered table-hover dataTable' style='margin: 10px; min-height: 95px; height: 95px; width:100%" + indent + "px;'>" +
								"<thead>" +
		        					"<tr>" +
					    				"<th>" + '${uiLabelMap.ProductProductId}' + "</th>" +
					    			  	"<th>" + '${uiLabelMap.Quantity}' + "</th>" +
					    			  	"<th>" + '${uiLabelMap.QuantityUomId}' + "</th>" +
					    		    "</tr>" +
				    		    "</thead>";
	        	for(var i in rowDetailDataInLocation){
	        		var productIdData = rowDetailDataInLocation[i].productId;
	        		var quantityData = rowDetailDataInLocation[i].quantity;
	        		var uomIdData = rowDetailDataInLocation[i].uomId;
	        		details += "<tbody>" +
		        					"<tr>" +
				        				"<td>" + productIdData + "</td>" +
				        			  	"<td>" + quantityData + "</td>" +
				        			  	"<td>" + getUom(uomIdData) + "</td>" +
				        			"</tr>" +
				        		"</tbody>";
	        	}
	        	details += "</table>";
	        	detailsData.push(details);
                return detailsData;
             },
             hierarchicalCheckboxes: true,
             checkboxes: true,
             altRows: true,
             selectionMode: 'multipleRows',
             sortable: true,
             editable:true,
             ready: function()
             {
            	 $("#myTree").jqxTreeGrid('selectRow', '2');
             },
             columns: [
                       { text: '${uiLabelMap.FacilityLocationPosition}', dataField: 'locationCode', editable:true
                       },
                       { text: '${uiLabelMap.SelectTypeLocationFacility}',  dataField: 'locationFacilityTypeId', columnType: "template", editable:true,
                    	   createEditor: function (row, cellvalue, editor, cellText, width, height) {
                    		   editor.jqxDropDownList({autoDropDownHeight: true, placeHolder: "Please select....", source: locationFacilityTypeData, width: '100%', height: '100%' ,displayMember: 'description', valueMember: 'locationFacilityTypeId'});
                    	   }
                       },
                       { text: '${uiLabelMap.ParentLocationId}',  dataField: 'parentLocationId', columnType: "template", editable:true,
                    	   createEditor: function (row, cellvalue, editor, cellText, width, height) {
                    		   editor.jqxDropDownList({autoDropDownHeight: true, placeHolder: "Please select....", source: locationFacilityData, width: '100%', height: '100%' ,displayMember: 'description', valueMember: 'locationId'
                    		   });
                    	   },
                    	   cellsRenderer: function (row, column, value, rowData) {
                    		   var locationId = rowData.locationId;
           					   var value = getlocationFacility(locationId);
           					   return '<span>' + value + '</span>';
                    	   }
                       },
                       { text: '${uiLabelMap.Description}', dataField: 'description', editable:true,
                       },
                    ],
            });
    }    
    
</script>
