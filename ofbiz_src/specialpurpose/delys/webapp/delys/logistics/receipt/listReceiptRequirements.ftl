<script type="text/javascript">
	var contactMechDataColumn = new Array();
	<#assign facilities = delegator.findList("Facility", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("ownerPartyId", "company"), null, null, null, false)>
	var facilityData = new Array();
	<#list facilities as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.facilityName?if_exists)/>
		row['facilityId'] = '${item.facilityId?if_exists}';
		row['description'] = '${description?if_exists}';
		facilityData[${item_index}] = row;
	</#list>
	
	<#assign statusItems = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "REQUIREMENT_STATUS"), null, null, null, false)>
	var statusData = new Array();
	<#list statusItems as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)/>
		row['statusId'] = '${item.statusId?if_exists}';
		row['description'] = '${description?if_exists}';
		statusData[${item_index}] = row;
	</#list>
	
	<#assign postalAddress = delegator.findList("FacilityContactMechDetail", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("contactMechPurposeTypeId", "SHIPPING_LOCATION"), null, null, null, false) />
	var postalAddressData = new Array();
	<#list postalAddress as item>
		var row = {};
		row['contactMechId'] = '${item.contactMechId}';
		row['description'] = '${item.address1}';
		postalAddressData[${item_index}] = row;
	</#list>
</script>

<#assign dataField="[{ name: 'requirementId', type: 'string'},
			   { name: 'agreementId', type: 'string'},
			   { name: 'orderId', type: 'string'},
			   { name: 'containerId', type: 'string'},
			   { name: 'containerNumber', type: 'string'},
			   { name: 'productStoreId', type: 'string'},
			   { name: 'requiredByDate', type: 'string'},
			   { name: 'statusId', type: 'string'},
			   { name: 'requirementDate', type: 'string'},
			   { name: 'partyIdTo', type: 'string'},
			   { name: 'sendMessage', type: 'string'},
			   { name: 'action', type: 'string'},
			   { name: 'facilityId', type: 'string'},
			   { name: 'contactMechId', type: 'string'},
			   { name: 'facilityContactMechs', type: 'string'},
			   ]"/>

<#assign columnlist="{ text: '${StringUtil.wrapString(uiLabelMap.requirementId)}', datafield: 'requirementId', width: 200, align: 'center', cellsrenderer:
			       		function(row, colum, value){
							return '<span><a onclick=\"showDetailPopup(' + value + ')\"' + value + '> ' + value  + '</a></span>'
			        	}
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.AgreementId)}', datafield: 'agreementId', minwidth: 150, align: 'center'},
					{ text: '${StringUtil.wrapString(uiLabelMap.ContNumber)}', datafield: 'containerNumber', minwidth: 150, align: 'center'},
					{ text: '${StringUtil.wrapString(uiLabelMap.RequiredByDate)}', datafield: 'requiredByDate', minwidth: 150, align: 'center', columntype: 'datetimeinput', editable: false, cellsformat: 'dd/MM/yyyy',},
					{ text: '${StringUtil.wrapString(uiLabelMap.Status)}', datafield: 'statusId', minwidth: 150, align: 'center',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < statusData.length; i++){
								if(statusData[i].statusId == value){
									return '<span title=' + value + '>' + statusData[i].description + '</span>'
								}
							}
						}
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.ReceiveDate)}', datafield: 'requirementDate', minwidth: 150, align: 'center', columntype: 'datetimeinput', editable: false, cellsformat: 'dd/MM/yyyy',},
					{ text: '${StringUtil.wrapString(uiLabelMap.facility)}', datafield: 'facilityId', minwidth: 150, align: 'center', columntype: 'dropdownlist',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < facilityData.length; i++){
								if(facilityData[i].facilityId == value){
									return '<span title=' + value + '>' + facilityData[i].description + '</span>'
								}
							}
						},
						initeditor: function (row, cellvalue, editor) {
							var curFacility;
							var index;
							for(var i = 0; i < facilityData.length; i++){
								if(facilityData[i].facilityId == cellvalue){
									curFacility = facilityData[i];
									index = facilityData.indexOf(facilityData[i]);
								}
							}
							if (index > -1) {
								facilityData.splice(index, 1);
							}
							facilityData.unshift(curFacility);
							var sourceDataFacility =
							{
			                   localdata: facilityData,
			                   datatype: 'array'
							};
							var dataAdapterFacility = new $.jqx.dataAdapter(sourceDataFacility);
							editor.jqxDropDownList({ selectedIndex: 0, source: dataAdapterFacility, displayMember: 'description', valueMember: 'facilityId'
							});
							editor.on('change', function (event){
								var args = event.args;
					     	    if (args) {
					     		    var index = args.index;
					     		    var item = args.item;
					     		    if(item){
					     		       update({
						     			   facilityId: item.value,
						     			   contactMechPurposeTypeId: 'SHIPPING_LOCATION',
					   					}, 'getFacilityContactMechs' , 'listFacilityContactMechs', 'contactMechId', 'address1');
					     		    }
					     	    }
					        	
					        });
						 },
					},
					{ text: '${StringUtil.wrapString(uiLabelMap.FacilityAddress)}', datafield: 'contactMechId', minwidth: 150, align: 'center', columntype: 'dropdownlist',
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < postalAddressData.length; i++){
								if(postalAddressData[i].contactMechId == value){
									return '<span title=' + value + '>' + postalAddressData[i].description + '</span>'
								}
							}
						},
						 initeditor: function (row, cellvalue, editor) {
			                   var contactMechData = new Array();
	                   			if(contactMechDataColumn && contactMechDataColumn.length){
	                   				contactMechData = contactMechDataColumn;
	                   			}else {
	                   				var data = $('#jqxgridReceiptRequirement').jqxGrid('getrowdata', row);
	 			                   var contactMechArray = data['facilityContactMechs'];
	 			                   for (var i = 0; i < contactMechArray.length; i++) {
	 				                    var contactMechItem = contactMechArray[i];
	 				                    var row = {};
	 				                    row['contactMechId'] = '' + contactMechItem.contactMechId;
	 				                    row['description'] = '' + contactMechItem.address1;
	 				                    contactMechData[i] = row;
	 			                   }
	                   			}
			                   var sourceDataContactMech =
			                   {
				                   localdata: contactMechData,
				                   datatype: 'array'
			                   };
			                   var dataAdapterContactMech = new $.jqx.dataAdapter(sourceDataContactMech);
			                   editor.jqxDropDownList({ selectedIndex: 0, source: dataAdapterContactMech, displayMember: 'description', valueMember: 'contactMechId'
			                   });
						 }
					},
					"/>
			   
<@jqGrid selectionmode="checkbox" filtersimplemode="true" id="jqxgridReceiptRequirement" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
	showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true" editmode="click" 
	url="jqxGeneralServicer?sname=JQGetListReceiptRequirements&requirementTypeId=RECEIVE_ORDER_REQ&statusId=REQ_PROPOSED"
	otherParams="facilityContactMechs:S-getFacilityContactMechs(facilityId,contactMechPurposeTypeId*SHIPPING_LOCATION)<listFacilityContactMechs>" 
/>
<div>
	<div style="margin:0px auto">
		<div style="margin-left: 0px; margin-top: -20px; width:250px;">
			<button id="alterSave" class="icon-ok">${uiLabelMap.CommonOk}</button>
		</div>
	</div>
</div>					
<script type="text/javascript">
	$.jqx.theme = 'olbius';
	theme = $.jqx.theme;
	
	$("#alterSave").jqxButton({width: 100, theme: theme});
	
	$("#alterSave").click(function () {
		var row;
		var selectedIndexs = $('#jqxgridReceiptRequirement').jqxGrid('getselectedrowindexes');
		
		var listReceiptRequirements = new Array();
		for(var i = 0; i < selectedIndexs.length; i++){
			var data = $('#jqxgridReceiptRequirement').jqxGrid('getrowdata', selectedIndexs[i]);
			var map = {};
			map['requirementId'] = data.requirementId;
			map['orderId'] = data.orderId;
			map['facilityId'] = data.facilityId;
			map['agreementId'] = data.agreementId;
			map['contactMechId'] = data.contactMechId;
			
			listReceiptRequirements[i] = map;
		}
		
		listReceiptRequirements = JSON.stringify(listReceiptRequirements);
		row = { 
				listReceiptRequirements:listReceiptRequirements
    	  };
		acceptReceiptRequirement({
			listReceiptRequirements: listReceiptRequirements,
		}, 'acceptReceiptRequirements');
		
	}); 
	function acceptReceiptRequirement(jsonObject, url) {
	    jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	$("#jqxgridReceiptRequirement").jqxGrid('updatebounddata');
	        }
	    });
	}
	function update(jsonObject, url, data, key, value){
		jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	var json = res[data];
	        	contactMechDataColumn = new Array();
	        	for (var x in json){
	        		var row = {};
                    row[key] = '' + json[x][key];
                    row['description'] = '' + json[x][value];
                    contactMechDataColumn.push(row);
	        	}
	        }
		});
	}
</script>		  