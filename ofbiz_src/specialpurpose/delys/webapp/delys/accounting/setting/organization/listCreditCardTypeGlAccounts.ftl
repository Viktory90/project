<script type="text/javascript" language="Javascript">
	<#assign itlength = listCardType.size()/>
    <#if listCardType?size gt 0>
	    <#assign lct="var lct = ['" + StringUtil.wrapString(listCardType.get(0).enumId?if_exists) + "'"/>
		<#assign lctValue="var lctValue = [\"" + StringUtil.wrapString(listCardType.get(0).enumId?if_exists) + " - " + StringUtil.wrapString(listCardType.get(0).enumCode?if_exists) +"\""/>
		<#if listCardType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lct=lct + ",'" + StringUtil.wrapString(listCardType.get(i).enumId?if_exists) + "'"/>
				<#assign lctValue=lctValue + ",\"" + StringUtil.wrapString(listCardType.get(i).enumId?if_exists) + " - " + StringUtil.wrapString(listCardType.get(i).enumCode?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lct=lct + "];"/>
		<#assign lctValue=lctValue + "];"/>
	<#else>
    	<#assign lct="var lct = [];"/>
    	<#assign lctValue="var lctValue = [];"/>
    </#if>
	${lct}
	${lctValue}	
	
	var dataLCT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["enumId"] = lct[i];
        row["description"] = lctValue[i];
        dataLCT[i] = row;
    }
	<#assign itlength = listGlAccountOrganizationAndClass.size()/>
    <#if listGlAccountOrganizationAndClass?size gt 0>
	    <#assign lgaoac="var lgaoac = ['" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).glAccountId?if_exists) + "'"/>
		<#assign lgaoacValue="var lgaoacValue = ['" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).accountCode?if_exists) + " - " + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).accountName?if_exists) + "[" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).glAccountId?if_exists) + "]'"/>
		<#if listGlAccountOrganizationAndClass?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lgaoac=lgaoac + ",'" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).glAccountId?if_exists) + "'"/>
				<#assign lgaoacValue=lgaoacValue + ",'" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).accountCode?if_exists) + " - " + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).accountName?if_exists) + "[" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).glAccountId?if_exists) + "]'"/>
			</#list>
		</#if>
		<#assign lgaoac=lgaoac + "];"/>
		<#assign lgaoacValue=lgaoacValue + "];"/>
	<#else>
    	<#assign lgaoac="var lgaoac = [];"/>
    	<#assign lgaoacValue="var lgaoacValue = [];"/>
    </#if>
	${lgaoac}
	${lgaoacValue}	
	var dataGAOAC = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["description"] = lgaoacValue[i];
        row["glAccountId"] = lgaoac[i];
        dataGAOAC[i] = row;
    };
    var linkGOACrenderer = function (row, column, value) {
		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
        for(i=0;i < lgaoac.length; i++){
        	if(lgaoac[i] == data.glAccountId){
        		return "<span>" + lgaoacValue[i] + "</span>";
        	}
        }
        return "";
	}
</script>


<#assign dataField="[{ name: 'cardType', type: 'string' },
					 { name: 'glAccountId', type: 'string' }
					 ]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.CardType}', datafield: 'cardType', editable: false},
					 { text: '${uiLabelMap.GLAccountId}', datafield: 'glAccountId', cellsrenderer:linkGOACrenderer, columntype: 'dropdownlist',
					 	createeditor: function (row, column, editor) {
                            var sourceGAOAC =
				            {
				                localdata: dataGAOAC,
				                datatype: \"array\"
				            };
				            var dataAdapterGAOAC = new $.jqx.dataAdapter(sourceGAOAC);
                            editor.jqxDropDownList({source: dataAdapterGAOAC, displayMember:\"glAccountId\", valueMember: \"glAccountId\",
                            renderer: function (index, label, value) {
			                    var datarecord = dataGAOAC[index];
			                    return datarecord.description;
			                } 
                        });
					 }}
					 
					 
					"/>
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListCreditCardTypeGlAccount" dataField=dataField columnlist=columnlist
		 
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true"
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow"
		 createUrl="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&jqaction=C&sname=createCreditCardTypeGlAccount"
		 addColumns="cardType;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 editable="true" editrefresh="true"
		 updateUrl="jqxGeneralServicer?sname=updateCreditCardTypeGlAccount&jqaction=U&organizationPartyId=${parameters.organizationPartyId}" 
		 editColumns="cardType;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=deleteCreditCardTypeGlAccount&jqaction=D" 
		 deleteColumn="cardType;organizationPartyId[${parameters.organizationPartyId}]"
 />				
 <div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.PaymentMethodType}:</td>
	 			<td align="left"><div id="CardType"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.GLAccountId}:</td>
	 			<td align="left"><div id="GlAccountId" ></div></td>
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
	
	var sourceLct =
    {
        localdata: dataLCT,
        datatype: "array"
    };
	var sourceGaoac =
    {
        localdata: dataGAOAC,
        datatype: "array"
    };
    var dataAdapterLct = new $.jqx.dataAdapter(sourceLct);
    var dataAdapterGaoac = new $.jqx.dataAdapter(sourceGaoac);
    $('#CardType').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLct, displayMember: "description", valueMember: "enumId"});
    $('#GlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGaoac, displayMember: "description", valueMember: "glAccountId"});
    $("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
   
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
	$("#alterSave").click(function () {
		var row;
        row = {
        		cardType: $('#CardType').val(),
        		glAccountId: $('#GlAccountId').val()
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	   $("#jqxgrid").jqxGrid('clearSelection');                        
       $("#jqxgrid").jqxGrid('selectRow', 0);  
       $("#alterpopupWindow").jqxWindow('close');
		
	});
	
</script>			