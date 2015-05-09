<script type="text/javascript" language="Javascript">
	<#assign itlength = listPaymentMethodType.size()/>
    <#if listPaymentMethodType?size gt 0>
	    <#assign lpmt="var lpmt = ['" + StringUtil.wrapString(listPaymentMethodType.get(0).paymentMethodTypeId?if_exists) + "'"/>
		<#assign lpmtValue="var lpmtValue = [\"" + StringUtil.wrapString(listPaymentMethodType.get(0).paymentMethodTypeId?if_exists) + " - " + StringUtil.wrapString(listPaymentMethodType.get(0).description?if_exists) +"\""/>
		<#if listPaymentMethodType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lpmt=lpmt + ",'" + StringUtil.wrapString(listPaymentMethodType.get(i).paymentMethodTypeId?if_exists) + "'"/>
				<#assign lpmtValue=lpmtValue + ",\"" + StringUtil.wrapString(listPaymentMethodType.get(i).paymentMethodTypeId?if_exists) + " - " + StringUtil.wrapString(listPaymentMethodType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lpmt=lpmt + "];"/>
		<#assign lpmtValue=lpmtValue + "];"/>
	<#else>
    	<#assign lpmt="var lpmt = [];"/>
    	<#assign lpmtValue="var lpmtValue = [];"/>
    </#if>
	${lpmt}
	${lpmtValue}	
	
	var dataLPMT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["paymentMethodTypeId"] = lpmt[i];
        row["description"] = lpmtValue[i];
        dataLPMT[i] = row;
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
    var listGlAccountOrganizationAndClassRender = function (row, column, value) {
    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
        for(i=0;i < lgaoac.length; i++){
        	if(lgaoac[i] == data.glAccountId){
        		return "<span>" + lgaoacValue[i] + "</span>";
        	}
        }
        return "";
    }
    var listDefaultGlAccountRender = function (row, column, value) {
    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
        for(i=0;i < lgaoac.length; i++){
        	if(lgaoac[i] == data.defaultGlAccountId){
        		return "<span>" + lgaoacValue[i] + "</span>";
        	}
        }
        return "";
    }
</script>


<#assign dataField="[{ name: 'paymentMethodTypeId', type: 'string' },
					 { name: 'glAccountId', type: 'string' },
					 { name: 'defaultGlAccountId', type: 'string' }
					
					 ]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.PaymentMethodType}', datafield: 'paymentMethodTypeId'},
					 { text: '${uiLabelMap.GLAccountId}', datafield: 'glAccountId', cellsrenderer:listGlAccountOrganizationAndClassRender},
					 { text: '${uiLabelMap.DefaultGlAccountId}', cellsrenderer:listDefaultGlAccountRender, datafield: 'defaultGlAccountId', filterable: false, sortable: false}
					 
					"/>
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListGlAccountNrPaymentMethod" dataField=dataField columnlist=columnlist
		 
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true" addrefresh="true"
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow"
		 createUrl="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&jqaction=C&sname=addPaymentMethodTypeGlAssignment"
		 addColumns="paymentMethodTypeId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 otherParams="defaultGlAccountId:S-getPaymentMethodType(paymentMethodTypeId)<defaultGlAccountId>;"
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=removePaymentMethodTypeGlAssignment&jqaction=D" 
		 deleteColumn="paymentMethodTypeId;organizationPartyId[${parameters.organizationPartyId}]"
 />				
 <div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.PaymentMethodType}:</td>
	 			<td align="left"><div id="paymentMethodTypeId"></div></td>
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
	
	var sourcePmt =
    {
        localdata: dataLPMT,
        datatype: "array"
    };
	var sourceGaoac =
    {
        localdata: dataGAOAC,
        datatype: "array"
    };
    var dataAdapterPmt = new $.jqx.dataAdapter(sourcePmt);
    var dataAdapterGaoac = new $.jqx.dataAdapter(sourceGaoac);
    $('#paymentMethodTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterPmt, displayMember: "description", valueMember: "paymentMethodTypeId"});
    $('#GlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGaoac, displayMember: "description", valueMember: "glAccountId"});
    $("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
	$("#alterSave").click(function () {
		var row;
        row = {
        		paymentMethodTypeId: $('#paymentMethodTypeId').val(),
        		glAccountId: $('#GlAccountId').val()
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
       $("#alterpopupWindow").jqxWindow('close');
		
	});
</script>			