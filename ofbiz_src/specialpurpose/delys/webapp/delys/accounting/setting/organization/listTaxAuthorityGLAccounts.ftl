<script>
<#assign gaoalength = listGlAccountOrganizationAndClass.size()/>
    <#if listGlAccountOrganizationAndClass?size gt 0>
	    <#assign gaoaType="var gaoaType = ['" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).glAccountId?if_exists) + "'"/>
		<#assign gaoaDes="var gaoaDes = ['" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).accountCode?if_exists) + "-" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).accountName?if_exists) + "-" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).glAccountId?if_exists) + "'"/>
		<#if listGlAccountOrganizationAndClass?size gt 1>
			<#list 1..(gaoalength - 1) as i>
				<#assign gaoaType=gaoaType + ",'" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).glAccountId?if_exists) + "'"/>
				<#assign gaoaDes=gaoaDes + ",'" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).accountCode?if_exists) + "-" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).accountName?if_exists) + "-" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).glAccountId?if_exists) + "'"/>
			</#list>
		</#if>
		<#assign gaoaType=gaoaType + "];"/>
		<#assign gaoaDes=gaoaDes + "];"/>
	<#else>
    	<#assign gaoaType="var gaoaType = [];"/>
    	<#assign gaoaDes="var gaoaDes = [];"/>
    </#if>
	${gaoaType}
	${gaoaDes}
	var gaoaData = new Array();
	for(var i = 0; i < ${gaoalength}; i++){
		var row = {};
		row['glAccountId'] = gaoaType[i];
		row['description'] = gaoaDes[i];
		gaoaData[i] = row;
	}
	var tahArray = new Array();
	
<#list taxAuthorityHavingNoGlAccountList as taxAuthorityHavingNoGlAccount>
	<#assign taxAuthPartyId = taxAuthorityHavingNoGlAccount.taxAuthPartyId?if_exists />
	<#assign taxAuthGeoId = taxAuthorityHavingNoGlAccount.taxAuthGeoId?if_exists />
	<#assign partyView = delegator.findOne("PartyNameView", {"partyId" : taxAuthPartyId}, true) !/>
	<#assign geo = delegator.findOne("Geo", {"geoId" : taxAuthGeoId}, true) />		
	var row = {};
	row['taxAuthPartyGeoId'] = '${taxAuthPartyId}' + ';' + '${taxAuthGeoId}';
	<#if partyView?exists>
		row['description'] = '[${taxAuthPartyId}]'+'${partyView.firstName?if_exists}' +'${partyView.middleName?if_exists}' +'${partyView.lastName?if_exists}' +'${partyView.groupName?if_exists}' + '-' + '[${geo.geoId?if_exists}]' + '${geo.geoName?if_exists}';
	<#else>	
		row['description'] = '[${taxAuthPartyId}]'+ '-' + '[${geo.geoId?if_exists}]' + '${geo.geoName?if_exists}';
	</#if>
	tahArray[i] = row;
</#list>


<#assign itlength = listGeo.size()/>
<#if listGeo?size gt 0>
    <#assign lg="var lg = ['" + StringUtil.wrapString(listGeo.get(0).geoId?if_exists) + "'"/>
	<#assign lgValue="var lgValue = [\"" + StringUtil.wrapString(listGeo.get(0).geoId?if_exists) + " - " + StringUtil.wrapString(listGeo.get(0).geoName?if_exists) +"\""/>
	<#if listGeo?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lg=lg + ",'" + StringUtil.wrapString(listGeo.get(i).geoId?if_exists) + "'"/>
			<#assign lgValue=lgValue + ",\"" + StringUtil.wrapString(listGeo.get(i).geoId?if_exists) + " - " + StringUtil.wrapString(listGeo.get(i).geoName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lg=lg + "];"/>
	<#assign lgValue=lgValue + "];"/>
<#else>
	<#assign lg="var lg = [];"/>
	<#assign lgValue="var lgValue = [];"/>
</#if>
${lg}
${lgValue}	

var listTAGRenderer = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < lg.length; i++){
    	if(lg[i] == data.taxAuthGeoId){
    		return "<span>" + lgValue[i] + "</span>";
    	}
    }
    return "";
}

var listGlAccountOrganizationAndClassRenderer = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < lg.length; i++){
    	if(gaoaType[i] == data.glAccountId){
    		return "<span>" + gaoaDes[i] + "</span>";
    	}
    }
    return "";
}

</script>
<#assign dataField="[{ name: 'taxAuthPartyId', type: 'string'},
					 { name: 'taxAuthGeoId', type: 'string'},
					 { name: 'glAccountId', type: 'string'},
					 { name: 'organizationPartyId', type: 'string'}
					]"/>

<#assign columnlist="{ text: '${uiLabelMap.taxAuthPartyId}', datafield: 'taxAuthPartyId', editable: false, width: 200},
					 { text: '${uiLabelMap.taxAuthGeoId}', datafield: 'taxAuthGeoId', editable: false, cellsrenderer:listTAGRenderer,width: 350},
					 { text: '${uiLabelMap.GLAccountId}', datafield: 'glAccountId', columntype: 'template', cellsrenderer:listGlAccountOrganizationAndClassRenderer,
					 	createeditor: function (row, column, editor) {
                            editor.jqxDropDownList({source: gaoaData, displayMember:\"description\", valueMember: \"glAccountId\",
                            renderer: function (index, label, value) {
			                    var datarecord = gaoaData[index];
			                    return datarecord.description;
			                  }
                        });
                        }
                        }
					"/>
	
<@jqGrid  filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" deleterow="true" editable="true" alternativeAddPopup="alterpopupWindow"
		 url="jqxGeneralServicer?sname=JQListTaxAuthorityGLAccounts&organizationPartyId=${parameters.organizationPartyId}"
		 removeUrl="jqxGeneralServicer?sname=deleteTaxAuthorityGlAccount&jqaction=D&organizationPartyId=${parameters.organizationPartyId}"
		 updateUrl="jqxGeneralServicer?sname=updateTaxAuthorityGlAccount&jqaction=U&organizationPartyId=${parameters.organizationPartyId}"
		 createUrl="jqxGeneralServicer?sname=createTaxAuthorityGlAccount&jqaction=C&organizationPartyId=${parameters.organizationPartyId}"
		 editColumns="taxAuthPartyId;taxAuthGeoId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 deleteColumn="taxAuthPartyId;taxAuthGeoId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 addColumns="taxAuthPartyId;taxAuthGeoId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]" 
		 />
<div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.taxAuthPartyId}:</td>
	 			<td align="left">
	 				<div id="taxAuthPartyGeoIdAdd">
	 				</div>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.GLAccountId}:</td>
	 			<td align="left">
	 				<div id="glAccountIdAdd">
	 				</div>
	 			</td>
    	 	</tr>
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div>
<script>
	 $.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	//Create TaxAuthPartyGeoId
	$('#taxAuthPartyGeoIdAdd').jqxDropDownList({ selectedIndex: 0,  source: tahArray, displayMember: "description", valueMember: "taxAuthPartyGeoId"});
	$('#glAccountIdAdd').jqxDropDownList({ selectedIndex: 0,  source: gaoaData, displayMember: "description", valueMember: "glAccountId"});
	$("#alterpopupWindow").jqxWindow({
        width: 450, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7           
    });
    $("#alterCancel").jqxButton();
    $("#alterSave").jqxButton();

    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
    	var row;
    	var taxAuthPartyGeoIdAdd = $('#taxAuthPartyGeoIdAdd').val();
		var temp = taxAuthPartyGeoIdAdd.split(";");
    	var taxAuthPartyId = temp[0];
    	var taxAuthGeoId = temp[1];
        row = { 
        		taxAuthPartyId:taxAuthPartyId,
        		taxAuthGeoId:taxAuthGeoId,
        		glAccountId:$('#glAccountIdAdd').val()           
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
        // select the first row and clear the selection.
        $("#jqxgrid").jqxGrid('clearSelection');                        
        $("#jqxgrid").jqxGrid('selectRow', 0);  
        $("#alterpopupWindow").jqxWindow('close');
    });
</script>