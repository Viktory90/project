<script>
	var facilityId = '${parameters.facilityId}';
	
	
	<#assign contactMechList = delegator.findList("ContactMechType", null, null, null, null, false) />
	var contactMechTypeData = new Array();
	<#list contactMechList as contactMechType>
		<#assign contactMechTypeId = StringUtil.wrapString(contactMechType.contactMechTypeId) />
		<#if contactMechType.get('description')?has_content>
			<#assign description = StringUtil.wrapString(contactMechType.get('description' ,locale)) />
		</#if>
		var row = {};
		row['contactMechTypeId'] = "${contactMechType.contactMechTypeId}";
		row['description'] = "${contactMechType.get('description', locale)?if_exists}";
		contactMechTypeData[${contactMechType_index}] = row;
	</#list>
	
	<#assign geoList = delegator.findList("Geo", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("geoTypeId", "COUNTRY"), null, null, null, false) />
	var geoData = new Array();
	<#list geoList as geo>
		<#assign geoId = StringUtil.wrapString(geo.geoId) />
		<#assign geoName = StringUtil.wrapString(geo.geoName) />
		var row = {};
		row['geoId'] = "${geo.geoId}";
		row['geoName'] = "${geo.geoName}";
		geoData[${geo_index}] = row;
	</#list>
	
	
	
	<#assign contactMechList = delegator.findList("ContactMechType", null, null, null, null, false) />
	var contactMechTypeData = new Array();
	<#list contactMechList as contactMechType>
		<#assign contactMechTypeId = StringUtil.wrapString(contactMechType.contactMechTypeId) />
		<#assign description = StringUtil.wrapString(contactMechType.description?if_exists) />
		var row = {};
		row['contactMechTypeId'] = "${contactMechType.contactMechTypeId}";
		row['description'] = "${contactMechType.get('description', locale)?if_exists}";
		contactMechTypeData[${contactMechType_index}] = row;
	</#list>
	
	
	function getContactMechTypeId(contactMechTypeId) {
		for ( var x in contactMechTypeData) {
			if (contactMechTypeId == contactMechTypeData[x].contactMechTypeId) {
				return contactMechTypeData[x].description;
			}
		}
	}
	
	
	
</script>	



<div>
			

<#assign initrowdetailsDetail = "function (index, parentElement, gridElement, datarecord) {
	if(datarecord.rowDetail == null || datarecord.rowDetail.length < 1){
		return 'Not Data';
	}
	var ordersDataAdapter = new $.jqx.dataAdapter(datarecord.rowDetail, { autoBind: true });
    var orders = ordersDataAdapter.records;
    
		var nestedGrids = new Array();
        var id = datarecord.uid.toString();
        
         var grid = $($(parentElement).children()[0]);
         $(grid).attr(\"id\",\"jqxgridDetail\");
         nestedGrids[index] = grid;
       
         var ordersbyid = [];
        
         for (var ii = 0; ii < orders.length; ii++) {
                 ordersbyid.push(orders[ii]);
         }
         var orderssource = { datafields: [	
         	 { name: \'contactMechId\', type:\'string\' },
         	 { name: \'descriptionContactMechPurpuseType\', type:\'string\' },
         	 { name: \'infoString\', type:\'string\' },
         	 { name: \'address1\', type:\'string\' },
         	 { name: \'toName\', type:\'string\' }
         	],
             localdata: ordersbyid
         }
         var nestedGridAdapter = new $.jqx.dataAdapter(orderssource);
        
         if (grid != null) {
             grid.jqxGrid({
                 source: nestedGridAdapter, width: 1100, height: 150,
                 showtoolbar:false,
		 		 editable:true,
		 		 editmode:\"click\",
		 		 showheader: true,
		 		 selectionmode:\"singlecell\",
		 		 theme: 'olbius',
		 		 pageable: true,
                 columns: [
                   { text: \'${uiLabelMap.PartyContactPurpose}\', datafield: \'descriptionContactMechPurpuseType\',editable: true},
                   { text: \'${uiLabelMap.ElectronicAddress}:\', datafield: \'infoString\',editable: true},
                   { text: \'${uiLabelMap.PartyAddressLine1}\', datafield: \'address1\',editable: true},
                   { text: \'${uiLabelMap.FormFieldTitle_toName}\', datafield: \'toName\',editable: true}
                 ]
             });
         }
 }"/>


		<#assign dataField="[
			{ name: 'contactMechTypeId', type: 'string'},
			{ name: 'rowDetail', type: 'string' }
		]"/>
		<#assign columnlist="
		{ text: '${uiLabelMap.MarketingContactListContactMechTypeId}', datafield: 'contactMechTypeId', filtertype: 'checkedlist',
				cellsrenderer: function(row, colum, value){
					var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					var contactMechTypeId = data.contactMechTypeId;
					var contactMechTypeId = getContactMechTypeId(contactMechTypeId);
					return '<span>' + contactMechTypeId + '</span>';
				}, 
				createfilterwidget: function (column, columnElement, widget) {
	        		widget.jqxDropDownList({ selectedIndex: 0,  source: contactMechTypeData, displayMember: 'contactMechTypeId', valueMember: 'contactMechTypeId',
	                	renderer: function (index, label, value) {
		                    var datarecord = contactMechTypeData[index];
		                    return datarecord.description;
		                }
	                });
	        	},
		}
		
		"/>
		
		<@jqGrid filtersimplemode="true" id="jqxgrid" filterable="true" addType="popup" dataField=dataField columnlist=columnlist addrow="true"  editable="true" alternativeAddPopup="alterpopupWindow"   showtoolbar="true" editmode="click" selectionmode="singlecell"
			url="jqxGeneralServicer?sname=JQXgetContactMechInFacility&facilityId=${parameters.facilityId}"
			customcontrol1="icon-tasks@${uiLabelMap.CommonList}@listFacilities"	usecurrencyfunction="true"
			initrowdetailsDetail=initrowdetailsDetail initrowdetails="true"
		/>
</div>

<div id="alterpopupWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span8">
				<div class="span4">
					${uiLabelMap.PartySelectContactType}:
				</div>
				<div class="span4"> 
					<div id="contactMechTypeId"></div>
				</div>
			</div>
		</div>	
	</div>
</div>

<div id="ElectronicAddressWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<#--
			<div class="span8">
				<div class="span4">
					${uiLabelMap.PartyContactPurpose}:
				</div>
				<div class="span4"> 
					<div id="contactMechPurposeTypeId"></div>
				</div>
			</div>
			-->
			<div class="span8">
				<div class="span4">
					${uiLabelMap.ElectronicAddress}:
				</div>
				<div class="span4"> 
					<input id="infoString"></input>
				</div>
			</div>
			<div class="span8">
				<input style="margin-right: 5px;" type="button" id="alterCreateElectronicAddress" value="${uiLabelMap.CommonSave}" />
		       	<input id="alterExitElectronicAddress" type="button" value="${uiLabelMap.CommonCancel}" />               	
		    </div>
		</div>	
	</div>
</div>

<div id="PostalAddressWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdPostalAddress"></div>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.FormFieldTitle_toName}: </div>
						<div class="controls">
							<input id="toName"></input>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyAttentionName}: </div>
						<div class="controls">
							<input id="attnName"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyAddressLine1}: </div>
						<div class="controls">
							<input id="address1"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyAddressLine2}: </div>
						<div class="controls">
							<input id="address2"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyCity}: </div>
						<div class="controls">
							<input id="city"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.LogCommonNational}: </div>
						<div class="controls">
							<div id="countryGeoId"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyState}: </div>
						<div class="controls">
							<div id="stateProvinceGeoId"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyZipCode}: </div>
						<div class="controls">
							<input id="postalCode"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreate" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExit1" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		
		</div>	
	</div>
</div>



<div id="PhoneNumbersWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdPhoneNumbers"></div>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.CommonCountryCode}: </div>
						<div class="controls">
							<input id="countryCode"></input>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.CommonAreaCode}: </div>
						<div class="controls">
							<input id="areaCode"></input>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactNumber}: </div>
						<div class="controls">
							<input id="contactNumber"></input>
						</div>
					</div>
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.CommonExpand}: </div>
						<div class="controls">
							<input id="extension"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreatePhoneNumbers" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitPhoneNumbers" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>





<div id="EmailAddressWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdEmailAddress"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyEmailAddress}: </div>
						<div class="controls">
							<input id="emailAddress"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreateEmailAddress" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitEmailAddress" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>
 
<div id="InternetIPAddressWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<#--
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdEmailAddress"></div>
						</div>
					</div>
					-->
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.InternetIPAddress}: </div>
						<div class="controls">
							<input id="internetIPAddress"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreateInternetIPAddress" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitInternetIPAddress" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>

<div id="InternetDomainNameWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<#--
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdInternetDomainName"></div>
						</div>
					</div>
					-->
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.InternetDomainName}: </div>
						<div class="controls">
							<input id="internetDomainName"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreateInternetDomainName" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitInternetDomainName" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>

<div id="WebURLAddressWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdWebURLAddress"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.WebURLAddress}: </div>
						<div class="controls">
							<input id="webURLAddress"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreateWebURLAddress" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitWebURLAddress" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>


<div id="InternalNoteviaPartyIdWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					<#--
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdInternalNoteviaPartyIdAddress"></div>
						</div>
					</div>
					-->
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.InternalNoteviaPartyId}: </div>
						<div class="controls">
							<input id="internalNoteviaPartyIdAddress"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreateInternalNoteviaPartyIdAddress" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitInternalNoteviaPartyIdAddress" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>


<div id="LDAPAddressWindow" class="hide">
	<div>${uiLabelMap.PageTitleNewFacilityContactMech}</div>
	<div style="overflow: hidden;">
		
		<div class="row-fluid">
			<div class="span12">
				<div class="form-horizontal">
					
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.PartyContactPurpose}: </div>
						<div class="controls">
							<div id="contactMechPurposeTypeIdLDAPAddress"></div>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<div class="control-label">${uiLabelMap.LDAPAddress}: </div>
						<div class="controls">
							<input id="LDAPAddress"></input>
						</div>
					</div>
					<div class="control-group no-left-margin">
				    </div>
				    <div class="control-group no-left-margin">
				    </div>
					<div class="control-group no-left-margin">
						<div class="controls">
							<input style="margin-right: 5px;" type="button" id="alterCreateLDAPAddress" value="${uiLabelMap.CommonSave}" />
					       	<input id="alterExitLDAPAddress" type="button" value="${uiLabelMap.CommonCancel}" />  
						</div>      	
				    </div>
				</div>
			</div>
		</div>	
	</div>
</div>

<script>
	

	//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	$("#alterpopupWindow").jqxWindow({
        width: 600 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7           
    });
	
	
	// create button alterSave, alterCancel
	$("#alterCreateElectronicAddress").jqxButton();
	$("#alterExitElectronicAddress").jqxButton();
	
	// create button alterSave, alterCancel
	$("#alterExitEmailAddress").jqxButton();
	$("#alterCreateEmailAddress").jqxButton();
	
	//Create infoString
	$("#infoString").jqxInput();
	
	
	$("#ElectronicAddressWindow").jqxWindow({
        width: 600 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitElectronicAddress"), modalOpacity: 0.7           
    });
	//Create productId
	$("#contactMechTypeId").jqxDropDownList({source: contactMechTypeData, displayMember: "description", valueMember: "contactMechTypeId", placeHolder: "Please Choose..."});
	
	// Create PostalAddressWindow jqxWindow
	$("#PostalAddressWindow").jqxWindow({
        width: 700, height: 400 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExit1"), modalOpacity: 0.7           
    });
	
	
	
	
	// Create InternetIPAddressWindow jqxWindow
	$("#PhoneNumbersWindow").jqxWindow({
        width: 600, height: 300 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitPhoneNumbers"), modalOpacity: 0.7           
    });
	$("#countryCode").jqxInput();
	$("#areaCode").jqxInput();
	$("#contactNumber").jqxInput();
	$("#extension").jqxInput();
	
	// create button alterSave, alterCancel
	$("#alterCreatePhoneNumbers").jqxButton();
	$("#alterExitPhoneNumbers").jqxButton();
	
	
	
	// Create PostalAddressWindow jqxWindow
	$("#EmailAddressWindow").jqxWindow({
        width: 600, height: 200 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitEmailAddress"), modalOpacity: 0.7           
    });
	
	// Create InternetIPAddressWindow jqxWindow
	$("#InternetIPAddressWindow").jqxWindow({
        width: 600, height: 200 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitInternetIPAddress"), modalOpacity: 0.7           
    });
	
	//Create infoString
	$("#internetIPAddress").jqxInput();
	// create button alterSave, alterCancel
	$("#alterCreateInternetIPAddress").jqxButton();
	$("#alterExitInternetIPAddress").jqxButton();
	
	
	// Create InternetDomainNameWindow jqxWindow
	$("#InternetDomainNameWindow").jqxWindow({
        width: 600, height: 200 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitInternetDomainName"), modalOpacity: 0.7           
    });
	
	//Create infoString
	$("#internetDomainName").jqxInput();
	// create button alterSave, alterCancel
	$("#alterCreateInternetDomainName").jqxButton();
	$("#alterExitInternetDomainName").jqxButton();
	
	// Create WebURLAddressWindow jqxWindow
	$("#WebURLAddressWindow").jqxWindow({
        width: 600, height: 200 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitWebURLAddress"), modalOpacity: 0.7           
    });
	
	//Create infoString
	$("#webURLAddress").jqxInput();
	// create button alterSave, alterCancel
	$("#alterCreateWebURLAddress").jqxButton();
	$("#alterExitWebURLAddress").jqxButton();
	
	
	
	// Create InternalNoteviaPartyIdWindow jqxWindow
	$("#InternalNoteviaPartyIdWindow").jqxWindow({
        width: 600, height: 200 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitInternalNoteviaPartyIdAddress"), modalOpacity: 0.7           
    });
	
	//Create internalNoteviaPartyIdAddress
	$("#internalNoteviaPartyIdAddress").jqxInput();
	// create button alterSave, alterCancel
	$("#alterCreateInternalNoteviaPartyIdAddress").jqxButton();
	$("#alterExitInternalNoteviaPartyIdAddress").jqxButton();
	
	
	// Create LDAPAddressWindow jqxWindow
	$("#LDAPAddressWindow").jqxWindow({
        width: 600, height: 200 ,resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterExitLDAPAddress"), modalOpacity: 0.7           
    });
	
	//Create infoString
	$("#LDAPAddress").jqxInput();
	// create button alterSave, alterCancel
	$("#alterCreateLDAPAddress").jqxButton();
	$("#alterExitLDAPAddress").jqxButton();
	
	
	var contactMechTypeId;
	$("#contactMechTypeId").on('select', function (event) {
        if (event.args) {
            var item = event.args.item;
        }
    	contactMechTypeId = item.value;
    	
    	if(contactMechTypeId == "ELECTRONIC_ADDRESS"){
    		$('#ElectronicAddressWindow').jqxWindow('open');
    	}
    	
    	if(contactMechTypeId == "POSTAL_ADDRESS"){
    		$('#PostalAddressWindow').jqxWindow('open');
    	}
    	
    	if(contactMechTypeId == "TELECOM_NUMBER"){
    		$('#PhoneNumbersWindow').jqxWindow('open');
    	}
    	
    	if(contactMechTypeId == "EMAIL_ADDRESS"){
    		$('#EmailAddressWindow').jqxWindow('open');
    	}
    	
    	
    	if(contactMechTypeId == "IP_ADDRESS"){
    		$('#InternetIPAddressWindow').jqxWindow('open');
    	}
    	
    	if(contactMechTypeId == "DOMAIN_NAME"){
    		$('#InternetDomainNameWindow').jqxWindow('open');
    	}
    	if(contactMechTypeId == "WEB_ADDRESS"){
    		$('#WebURLAddressWindow').jqxWindow('open');
    	}
    	if(contactMechTypeId == "INTERNAL_PARTYID"){
    		$('#InternalNoteviaPartyIdWindow').jqxWindow('open');
    	}
    	if(contactMechTypeId == "LDAP_ADDRESS"){
    		$('#LDAPAddressWindow').jqxWindow('open');
    	}
    	
    	var request = $.ajax({
			  url: "loadContactMechTypePurposeList",
			  type: "POST",
			  data: {contactMechTypeId : contactMechTypeId},
			  dataType: "json",
			  success: function(data) {
				  var listcontactMechPurposeTypeMap = data["listcontactMechPurposeTypeMap"];
				  var contactMechPurposeTypeId = new Array();
				  var description = new Array();
				  var array_keys = new Array();
				  var array_values = new Array();
				  for(var i = 0; i < listcontactMechPurposeTypeMap.length; i++){
					  for (var key in listcontactMechPurposeTypeMap[i]) {
					      array_keys.push(key);
					      array_values.push(listcontactMechPurposeTypeMap[i][key]);
					  }
				  }
				  var dataTest = new Array();
				  for (var j =0; j < array_keys.length; j++){
							var row = {};
							row['id'] = array_keys[j];
							row['value'] = array_values[j];
							dataTest[j] = row;
				  }
				  if(contactMechTypeId == "POSTAL_ADDRESS"){
					  // create jqxDropDownList contactMechPurposeTypeIdPostalAddress
					  $("#contactMechPurposeTypeIdPostalAddress").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
				  }
				  
				  if(contactMechTypeId == "TELECOM_NUMBER"){
					  // create jqxDropDownList contactMechPurposeTypeIdPostalAddress
					  $("#contactMechPurposeTypeIdPhoneNumbers").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
				  }
				  
				  if(contactMechTypeId == "EMAIL_ADDRESS"){
					  // create jqxDropDownList contactMechPurposeTypeIdPostalAddress
					  $("#contactMechPurposeTypeIdEmailAddress").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
				  }
				  if(contactMechTypeId == "IP_ADDRESS"){
					  <#--
					  // create jqxDropDownList contactMechPurposeTypeIdPostalAddress
					  $("#contactMechPurposeTypeIdEmailAddress").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
					  -->
				  }
				  if(contactMechTypeId == "WEB_ADDRESS"){
					  
					  // create jqxDropDownList contactMechPurposeTypeIdWebURLAddress
					  $("#contactMechPurposeTypeIdWebURLAddress").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
					 
				  }
				  if(contactMechTypeId == "LDAP_ADDRESS"){
					  
					  // create jqxDropDownList contactMechPurposeTypeIdWebURLAddress
					  $("#contactMechPurposeTypeIdLDAPAddress").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
				  }
			  }
		});
		request.done(function(data) {
			
			
			<#--
			if(data.responseMessage == "error"){
	        	$('#jqxNotification').jqxNotification({ template: 'error'});
	        	$("#jqxNotification").text(data.errorMessage);
	        	$("#jqxNotification").jqxNotification("open");
			}else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	    	} 
				-->
		});
	});
	
	
	
	
	//Create emailAddress
	$("#emailAddress").jqxInput();
	
	//Create infoString
	$("#toName").jqxInput();
	//Create attnName
	$("#attnName").jqxInput();
	//Create address1
	$("#address1").jqxInput();
	//Create address2
	$("#address2").jqxInput();
	//Create city
	$("#city").jqxInput();
	
	//Create postalCode
	$("#postalCode").jqxInput();
	// create countryGeoId
	$("#countryGeoId").jqxDropDownList({ selectedIndex: 0,  source: geoData, displayMember: "geoName", valueMember: "geoId"});
	
	
	$("#countryGeoId").on('select', function (event) {
        if (event.args) {
            var item = event.args.item;
        }
        var geoId = item.value;
        
        var request = $.ajax({
			  url: "loadGeoAssocListByGeoId",
			  type: "POST",
			  data: {geoId : geoId},
			  dataType: "json",
			  success: function(data) {
				  var listcontactMechPurposeTypeMap = data["listGeoAssocMap"];
				  var contactMechPurposeTypeId = new Array();
				  var description = new Array();
				  var array_keys = new Array();
				  var array_values = new Array();
				  for(var i = 0; i < listcontactMechPurposeTypeMap.length; i++){
					  
					  for (var key in listcontactMechPurposeTypeMap[i]) {
					      array_keys.push(key);
					      array_values.push(listcontactMechPurposeTypeMap[i][key]);
					  }
					  
				  }
				  
				  var dataTest = new Array();
				  for (var j =0; j < array_keys.length; j++){
							var row = {};
							row['id'] = array_keys[j];
							row['value'] = array_values[j];
							dataTest[j] = row;
				  }
				  $("#stateProvinceGeoId").jqxDropDownList({ selectedIndex: 0,  source: dataTest, displayMember: 'value', valueMember: 'id'});
				  if (dataTest.length == 0){
					  $("#stateProvinceGeoId").jqxDropDownList('setContent', '${uiLabelMap.CommonNoStatesProvincesExists}'); 
					  $("#stateProvinceGeoId").jqxDropDownList({ disabled: true }); 
				  } else {
					  $("#stateProvinceGeoId").jqxDropDownList({ disabled: false }); 
				  }
			  }
		}); 
		
        request.done(function(data) {
        	<#--
			if(data.responseMessage == "error"){
	        	$('#jqxNotification').jqxNotification({ template: 'error'});
	        	$("#jqxNotification").text(data.errorMessage);
	        	$("#jqxNotification").jqxNotification("open");
			}else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	    	} -->
				
		});
        
        
        
    });
	// create stateProvinceGeoId
	<#-- $("#stateProvinceGeoId").jqxDropDownList({ selectedIndex: 0,  source: contactMechTypePurposeData, displayMember: "contactMechPurposeTypeId", valueMember: "contactMechTypeId"}); -->
	
	// create button alterSave, alterCancel
	$("#alterExit1").jqxButton();
	$("#alterCreate").jqxButton();
	
	$("#alterCreate").click(function (){
		var facilityId = '${facilityId}';
		var contactMechTypeId = $('#contactMechTypeId').val();
		var contactMechPurposeTypeId = $('#contactMechPurposeTypeIdPostalAddress').val();
		var toName = $('#toName').val();
		var attnName = $('#attnName').val();
		var address1 = $('#address1').val();
		var address2 = $('#address2').val();
		var city = $('#city').val();
		var countryGeoId = $('#countryGeoId').val();
		var stateProvinceGeoId = $('#stateProvinceGeoId').val();
		var postalCode = $('#postalCode').val();
		
		var request = $.ajax({
			  url: "createContactMech",
			  type: "POST",
			  data: {facilityId: facilityId, contactMechTypeId: contactMechTypeId, contactMechPurposeTypeId : contactMechPurposeTypeId, toName: toName, attnName: attnName, address1: address1, address2: address2, city: city, countryGeoId: countryGeoId, stateProvinceGeoId: stateProvinceGeoId, postalCode: postalCode},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#PostalAddressWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	
	
	
	$("#alterCreatePhoneNumbers").click(function (){
		var facilityId = '${facilityId}';
		var contactMechTypeId = $('#contactMechTypeId').val();
		var contactMechPurposeTypeId = $('#contactMechPurposeTypeIdPhoneNumbers').val();
		var countryCode = $('#countryCode').val();
		var areaCode = $('#areaCode').val();
		var contactNumber = $('#contactNumber').val();
		var extension = $('#extension').val();
		var request = $.ajax({
			  url: "createTelecomNumber",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, contactMechPurposeTypeId: contactMechPurposeTypeId, facilityId: facilityId ,countryCode: countryCode, areaCode: areaCode, contactNumber: contactNumber, extension: extension},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#PhoneNumbersWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	
	
	$("#alterCreateEmailAddress").click(function (){
		var facilityId = '${facilityId}';
		var contactMechTypeId = $('#contactMechTypeId').val();
		var contactMechPurposeTypeId = $('#contactMechPurposeTypeIdEmailAddress').val();
		var infoString = $('#emailAddress').val();
		
		var request = $.ajax({
			  url: "createEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, contactMechPurposeTypeId: contactMechPurposeTypeId, facilityId: facilityId ,infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#EmailAddressWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	$("#alterCreateInternetIPAddress").click(function (){
		var contactMechTypeId = $('#contactMechTypeId').val();
		var infoString = $('#internetIPAddress').val();
		
		var request = $.ajax({
			  url: "createFacilityContactMechByEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#InternetIPAddressWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	$("#alterCreateInternetDomainName").click(function (){
		var contactMechTypeId = $('#contactMechTypeId').val();
		var infoString = $('#internetDomainName').val();
		
		var request = $.ajax({
			  url: "createFacilityContactMechByEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#InternetDomainNameWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	$("#alterCreateWebURLAddress").click(function (){
		var facilityId = '${facilityId}';
		var contactMechTypeId = $('#contactMechTypeId').val();
		var contactMechPurposeTypeId = $('#contactMechPurposeTypeIdWebURLAddress').val();
		var infoString = $('#webURLAddress').val();
		
		var request = $.ajax({
			  url: "createFacilityContactMechByEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, contactMechPurposeTypeId: contactMechPurposeTypeId, facilityId: facilityId ,infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#WebURLAddressWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	$("#alterCreateLDAPAddress").click(function (){
		var facilityId = '${facilityId}';
		var contactMechTypeId = $('#contactMechTypeId').val();
		var contactMechPurposeTypeId = $('#contactMechPurposeTypeIdLDAPAddress').val();
		var infoString = $('#LDAPAddress').val();
		
		var request = $.ajax({
			  url: "createFacilityContactMechByEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, contactMechPurposeTypeId: contactMechPurposeTypeId, facilityId: facilityId ,infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#LDAPAddressWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	$("#alterCreateInternalNoteviaPartyIdAddress").click(function (){
		var contactMechTypeId = $('#contactMechTypeId').val();
		var infoString = $('#internalNoteviaPartyIdAddress').val();
		
		var request = $.ajax({
			  url: "createFacilityContactMechByEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#InternalNoteviaPartyIdWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
	$("#alterCreateElectronicAddress").click(function (){
		var contactMechTypeId = $('#contactMechTypeId').val();
		var infoString = $('#infoString').val();
		
		var request = $.ajax({
			  url: "createFacilityContactMechByEmailAddress",
			  type: "POST",
			  data: {contactMechTypeId: contactMechTypeId, infoString: infoString},
			  dataType: "html"
		});
		request.done(function(data) {
			$('#jqxgrid').jqxGrid('updatebounddata');
			if(data.responseMessage == "error"){
				$('#jqxNotification').jqxNotification({ template: 'error'});
	            $("#jqxNotification").text(data.errorMessage);
	            $("#jqxNotification").jqxNotification("open");
	        }else{
	        	
	        	$('#container').empty();
	        	$('#jqxNotification').jqxNotification({ template: 'info'});
	        	$("#jqxNotification").text("Thuc thi thanh cong!");
	        	$("#jqxNotification").jqxNotification("open");
	        }
		});
			
		request.fail(function(jqXHR, textStatus) {
			alert( "Request failed: " + textStatus );
		}); 
		$("#ElectronicAddressWindow").jqxWindow('close');
        $("#alterpopupWindow").jqxWindow('close');
      
	});
	
</script>